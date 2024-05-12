# Ultimathnum

> Everyone who hears these words of mine and does them is like a wise man who
> built his house on rock. The rain fell, the flood came, and the winds beat 
> against that house, but it did not collapse because its foundation had been 
> laid on rock. (Matthew 7:24-25)

## Table of Contents

* [Introduction](#introduction)
  - [A rock-solid foundation](#introduction-foundation)
  - [Keep stdlib extensions to a minimum](#introduction-stdlib)
  - [Derive  all the things!](#introduction-minimalistic)
  - [Recover all the things!](#introduction-recoverable)
* [Nomenclature](#nomenclature)
  - [What is a binary integer?](#nomenclature-binary-integer)
  - [What is a data integer?](#nomenclature-data-integer)
  - [What is a systems integer?](#nomenclature-systems-integer)
  - [What is a trusted input?](#nomenclature-trusted-input)
* [CoreKit](#corekit)
  - [Validation and recovery through Fallible\<Value\>](#corekit-validation)
  - [Upsize binary integer elements with DataInt\<U8\>](#corekit-upsize)
  - [Type-safe bit casts with BitCastable\<BitPattern\>](#corekit-bit-cast)
  - [Lightweight text decoding and encoding with TextInt](#corekit-text-int)
* [DoubleIntKit](#doubleintkit)
* [InfiniIntKit](#infiniintkit)
  - [Recoverable infinite addition (+/-)](#infiniintkit-addition)
  - [Recoverable infinite multiplication](#infiniintkit-multiplication)
  - [Recoverable infinite division](#infiniintkit-division)
* [FibonacciKit](#fibonaccikit)
  - [The Fibonacci\<Value\> sequence](#fibonaccikit-sequence)
  - [Fast sequence addition (+/-)](#fibonaccikit-addition)
  - [Code coverage with sequence invariants](#fibonaccikit-invariants)
* [Installation](#installation)
  - [SemVer 2.0.0](#installation-semver)
  - [Swift Package Manager](#installation-swift-package-manager)

<a name="introduction"/>

## Introduction

<a name="introduction-foundation"/>

#### A rock-solid foundation

In programming, complexity is sand, and simplicity is a rock. The former is, by 
definition, a sum of parts. In this project, you will find unified abstractions 
that reduce the number of individual parts and streamlined design principles to 
keep the parts similar to each other. So make some tea, have a seat, then let's 
explore what it's all about.

<a name="introduction-stdlib"/>

#### Keep stdlib extensions to a minimum

Note that this project is mostly self-contained. It only extends the standard 
library when necessary. In practice, this means adding conversion to and from
new types. All other functionality either belongs to the new types or is kept 
private through access control. This ensures interoperability without confusion 
or accidental dependencies.

<a name="introduction-minimalistic"/>

#### Derive all the things!

The are many ways to abstract and there are pros and cons to all of them. Here,
we keep it simple. We use a small set of primitives to derive most things. Our 
abstractions are purposeful and close to the machine so that our derivatives 
perform like would-be primitives. Similarly, you will not find many mutating 
methods. Instead, we introduce a mutating syntax that destructures functional 
results. This cuts the project in half, compared to previous iterations of it.

<a name="introduction-recoverable"/>

#### Recover all the things!

If simplicity is a rock, then recovery is the capstone. Gone are they days of
unavoidable traps because there now exists a recoverable alternative for every 
safe operation. Overflow, underflow, whatever—the framework will lazily prompt
you to handle it. Furthermore, the abstractions and recovery mechanisms presented 
to you are ever-present in generic code as well.

## Nomenclature

<a name="nomenclature-binary-integer"/>

#### What is a binary integer?

> Binary integers are dead.\
> Long live binary integers!

This project presents a novel binary integer abstraction that unifies the different
sizes. It views all binary integers as infinite bit sequences with various modes 
of operation. It extends the maximum unsigned value to infinity and lets you recover 
from failure through intuitive, ergonomic, and generic error propagation mechanisms.

```swift
(~0 as IXL) // -1
(~1 as IXL) // -1 - 1
(~0 as UXL) //  ∞
(~1 as UXL) //  ∞ - 1
```

Some definitions have been updated to fit the new binary integer format. What was once 
called the sign bit is now the appendix bit. This means a so-called signed right shift
treats an infinite unsigned integer like a negative signed integer, for example.

```swift
(~2 as UXL) >> 1 == (~1 as UXL)
(~1 as UXL) >> 1 == (~0 as UXL)
(~0 as UXL) >> 1 == (~0 as UXL)
( 0 as UXL) >> 1 == ( 0 as UXL)
( 1 as UXL) >> 1 == ( 0 as UXL)
( 2 as UXL) >> 1 == ( 1 as UXL)
```

In practice, an infinite integer is represented by its least significant body
elements, followed by an infinite repetition of its appendix bit. All signed integers
and all infinite integers store this bit in memory, but unsigned systems integers 
return zero through the type system. This makes all systems integers compatible with 
the un/signed two's complement format.

```
~(~(x)) == x for all x
┌────────────────────┐
│ some BinaryInteger │
├──────┬─────────────┤
│ body │ appendix... │
└──────┴─────────────┘
```

<a name="nomenclature-data-integer"/>

#### What is a data integer?

A binary integer must provide contiguous access to its endianness-sensitive body, which can
be viewed through a data integer. Such view types keep track of memory alignments and may downsize 
their element type through reinterpretation.

| Read                     | Read & Write                   |
|:-------------------------|:-------------------------------|
| DataInt\<Element\>       | MutableDataInt\<Element\>.Body |
| DataInt\<Element\>.Body  | MutableDataInt\<Element\>.Body |

All binary integers agree on this format, which lets us perform arbitrary conversions with 
a fixed set of protocol witnesses. Compare this to the square matrix of doom that is formed 
by generic protocol requirements. In theory, a binary integer needs two initializers. One 
for aligned loads from compatible sources and one for unaligned loads from unknown sources.
In practice, this depends on whether the optimizer can turn them into appropriate instructions.

```swift
init(load source: DataInt<U8>)                // unknown
init(load source: DataInt<Element.Magnitude>) // aligned
```

<details><summary>
Here are the other conversion requirements...
</summary>

```swift
@inlinable init(load source: consuming  UX.Signitude)
@inlinable init(load source: consuming  UX.Magnitude)
@inlinable borrowing func load(as type: UX.BitPattern.Type) -> UX.BitPattern

@inlinable init(load source: consuming  Element.Signitude)
@inlinable init(load source: consuming  Element.Magnitude)
@inlinable borrowing func load(as type: Element.BitPattern.Type) -> Element.BitPattern
```
</details>

<a name="nomenclature-systems-integer"/>

#### What is a systems integer?

> Keep it simple.

You may realize that the infinite bit pattern definition implies a static size for all binary
integers. Indeed, you can compare their sizes through metadata alone. Still, not all binary integers 
are trivial. A systems integer is represented in memory by its bit pattern alone. Additionally, a 
systems integer's size must be a power of two in [8, IX.max].

| Size    | Signed | Unsigned |
|--------:|:------:|:--------:|
| pointer | IX     | UX       |
|   8-bit | I8     | U8       |
|  16-bit | I16    | U16      |
|  32-bit | I32    | U32      |
|  64-bit | I64    | U64      |

Systems integers are intentionally simple so that the things you build with them may be simple. 
The only protocol requirements are multiplication and division algorithms for working with full 
precision in generic code.

<a name="nomenclature-trusted-input"/>

#### What is a trusted input?

> Trust me, I know what I'm doing...

Once you start using primitive types to form more complex types, you notice that some semantics
compose better than others. A trusted input delegates some precondition validation to the 
programmer so that complex types can be built with less overhead. The type system will compel you 
to approve each trusted input with one of the following methods. Your choice will either make your 
code safer or easier to audit.

```swift
init(_:)         // error: traps
init(_:prune:)   // error: throws
init(exactly:)   // error: nil
init(unchecked:) // error: unsafe (with debug assertions)
```

<a name="corekit"/>

## CoreKit

<a name="corekit-validation"/>

#### Validation and recovery through Fallible\<Value\>

> It doesn't matter how many times you fall.\
> It matters how many times you get back up.

Ergonomic error handling is one of the cornerstones of this project and a lot of effort has 
gone into ensuring that there's always a path to redemption. The Fallible\<Value\> wrapper plays 
an important part the recovery story. Use it to handle errors when you want and how you want. 
Here's a real example from the generic Fibonacci\<Value\> sequence:

```swift
/// Forms the sequence pair at `index + x.index`.
@inlinable public mutating func increment(by x: Self) throws {
    let ix = try i.plus (x.i).prune(Failure.overflow)
    let ax = try a.times(x.b).plus(b.minus(a).times(x.a)).prune(Failure.overflow)
    let bx = try b.times(x.b).plus(       (a).times(x.a)).prune(Failure.overflow)

    self.i = consume ix
    self.a = consume ax
    self.b = consume bx
}
```

Note that each operation propagates failure by setting Fallible\<Value\>'s error indicator, which is 
lazily checked in the throwing prune(\_:) method. Alternatively, you may use optional(\_:), result(\_:)
unwrap(\_:), assert(\_:) or plain value and error to validate your results. Also, note that each
operation accepts both `Value` and Fallible\<Value\> inputs to make error handling as seamless as possible.
In the same vein, use any of the common arithmetic operators for trapping or wrapping results:

```swift
static func  +(lhs: consuming Self, borrowing Self) -> Self // trapping
static func &+(lhs: consuming Self, borrowing Self) -> Self // wrapping
```

<a name="corekit-upsize"/>

#### Upsize binary integer elements with DataInt\<U8\>

The data integer types let you downsize binary integer elements by reinterpretation. This versatile
power stems from strict systems integer layout requirements. You may not upsize elements in this way,
however, because the memory alignment of a smaller systems integer may not be compatible with a
larger systems integer. Instead, you may use DataInt\<U8\> to load elements of any size. It performs 
an unaligned load when possible and handles the case where the load would read past the end. All 
binary integers can form a DataInt\<U8\> view since a byte is the smallest possible systems integer type.

<a name="corekit-bit-cast"/>

#### Type-safe bit casts with BitCastable\<BitPattern\>

The BitCastable\<BitPattern\> protocol lets you perform type-safe bit casts in bulk. This is pertinent
to binary integers since the abstraction is two representations bridged by a bit pattern transformation. 

```swift
U8(raw:  -1 as I8) // 255
I8(raw: 255 as U8) //  -1
```

You perform type-safe bit-casts by calling the init(raw:) method. It is similar to init(load:) 
but with same-size, and possibly other, requirements. Alternatively, you can use subscript(raw:) 
to the same effect, or to perform an in-place reinterpretation.

```swift
@inlinable public func distance<Distance>(
    to other: Self,
    as type: Distance.Type = Distance.self
)   -> Fallible<Distance> where Distance: SignedInteger {
            
    if  Self.size < Distance.size {
        return Distance(load: other).minus(Distance(load: self))
    
    }   else if Self.isSigned {
        return other.minus(self).map(Distance.exactly)
        
    }   else {
        let distance = Fallible<Signitude>(raw: other.minus(self))
        let superoverflow = (distance.value).isNegative != distance.error
        return Distance.exactly(distance.value).invalidated(superoverflow)
    }
}
```

<details>
<summary>
Here's how you translate it to Strideable/distance(from:to:) proper...
</summary>

```swift
@inlinable public func distance(to other: Self) -> Swift.Int {
    Swift.Int(self.distance(to: other, as: IX.self).unwrap())
}
```
</details>

The above example shows a generic Strideable/distance(from:to:) esque method. In the narrowing 
unsigned case you find that the difference is reinterpreted as a same-size signed integer type 
via the init(raw:) bulk operation. Note that such type relationships are generically available 
to all binary integers. Also, note that this method is both fully generic and fully recoverable. 

<a name="corekit-text-int"/>

#### Lightweight text decoding and encoding with TextInt

At some point, you'll want to convert your binary integers to a human-readable format. When 
that happens, the description(as:) and init(\_:as:) methods let you perform the common radix 
conversions via TextInt. The latter uses a fixed number of non-generic and non-inlinable
algorithms, which are shared by all binary integers. This is an intentional size-over-performance 
optimization.

```swift
try! TextInt(radix:  12, letters: .uppercase)
try! IXL("123", as: .decimal).description(as: .hexadecimal) //  7b
try! IXL("123", as: .hexadecimal).description(as: .decimal) // 291
```

Note that the introduction of infinite values necessitates changes to the integer description 
format. The new format adds the # and & markers. The former is a just spacer whereas the latter 
represents bitwise negation. In other words, +&123 translates to ∞ minus 123.

```swift
let regex: Regex = /^(?<sign>\+|-)(?<mask>#|&)(?<body>[0-9a-zA-z]+)$/
```

<a name="doubleintkit"/>

## DoubleIntKit

> Veni, vidi, vici. I came, I saw, I conquered.

```
 DoubleInt<I64>           DoubleInt<U64>
┌───────────────────────┐┌───────────────────────┐
│ I256                  ││ U256                  │
├───────────┬───────────┤├───────────┬───────────┤
│ U128      │ I128      ││ U128      │ U128      │
├─────┬─────┼─────┬─────┤├─────┬─────┼─────┬─────┤
│ U64 │ U64 │ U64 │ I64 ││ U64 │ U64 │ U64 │ U64 │
└─────┴─────┴─────┴─────┘└─────┴─────┴─────┴─────┘
```

<a name="infiniintkit"/>

## InfiniIntKit

> Author: *Slaps roof of car.* This baby can fit infinity!

```
 InfiniInt<IX>            InfiniInt<UX>
┌───────────────────────┐┌───────────────────────┐
│ IXL                   ││ UXL                   │
├─────────────────┬─────┤├─────────────────┬─────┤
│ UX............. │ Bit ││ UX............. │ Bit │
└─────────────────┴─────┘└─────────────────┴─────┘
```

It may or may not sound intuitive at first, but this infinite binary integer
has a fixed size too. It is important to remember this when you consider the
recovery modes of its arithmetic operations. It overflows and underflows just
like the systems integers you know and love. 

The main difference between a systems integer and an infinite integer is that 
the appendix bit is the only addressable infinity bit, which means you cannot 
cut infinity in half. Likewise, the log2(max+1) size must be promoted. To
work with infinite numerical values, you must track where your values come 
from. Keep in mind that recovery from failure is the main purpose of infinity.

> ![NOTE]
> The introduction of infinity is what permits \~(\~(x)) == x for all x.

<a name="infiniintkit-addition"/>

#### Recoverable infinite addition (+/-)

Addition at and around infinity just works.

```swift
UXL.min.decremented() // value: max, error: true
UXL.max.incremented() // value: min, error: true
```

<a name="infiniintkit-multiplication"/>

#### Recoverable infinite multiplication

Multiplication is also unchanged. All of the complicated stuff forms at one bit
past the appendix bit. Imagine a really big integer and a product of twice that 
size with truncating behavior. It just works.

```swift
U32.max.times(U32.max) // value: 001, error: true
UXL.max.times(UXL.max) // value: 001, error: true
```

<a name="infiniintkit-division"/>

#### Recoverable infinite division

So, this is where things get tricky. Wait, no, it still just works in most cases.
Since you know finite-by-finite division, I'm sure you intuit that finite-by-infinite
division is trivial and that infinite-by-infinite division is at most one subtraction.
The only weird case is infinite-by-finite division because the proper computation
requires infinite memory. So, in this case, we just let the algorithm run and mark it 
as an error unless the divisor is one. This yields results similar to signed division.

```swift
dividend == divisor &* quotient &+ remainder // for all binary integers
```

<a name="fibonaccikit"/>

## FibonacciKit

<a name="fibonaccikit-sequence"/>

#### The Fibonacci\<Value\> sequence

> Question: How do you test silly numbers?\
> Answer: With silly number generators, of course!

```swift
try! Fibonacci<UXL>(0) // (index: 0, element: 0, next: 1)
try! Fibonacci<UXL>(1) // (index: 1, element: 1, next: 1)
try! Fibonacci<UXL>(2) // (index: 2, element: 1, next: 2)
try! Fibonacci<UXL>(3) // (index: 3, element: 2, next: 3)
try! Fibonacci<UXL>(4) // (index: 4, element: 3, next: 5)
try! Fibonacci<UXL>(5) // (index: 5, element: 5, next: 8)
```

It uses a fast double-and-add algorithm:

```swift
try! Fibonacci<UXL>(1_000_000) // 0.06s on MacBook Pro, 13-inch, M1, 2020
```

But you can also step through it manually:

```swift
mutating func double()       throws // index * 2
mutating func increment()    throws // index + 1
mutating func decrement()    throws // index - 1
mutating func increment(by:) throws // index + x.index
mutating func decrement(by:) throws // index - x.index
```

<a name="fibonaccikit-addition"/>

#### Fast sequence addition (+/-)

You may have noticed that you can pick any two adjacent elements and express
the sequence in terms of those elements. This observation allows us to climb
up and down the index ladder. The idea is super simple:

```
f(x + 1 + 0) == f(x) * 0000 + f(x + 1) * 00000001
f(x + 1 + 1) == f(x) * 0001 + f(x + 1) * 00000001
f(x + 1 + 2) == f(x) * 0001 + f(x + 1) * 00000002
f(x + 1 + 3) == f(x) * 0002 + f(x + 1) * 00000003
f(x + 1 + 4) == f(x) * 0003 + f(x + 1) * 00000005
f(x + 1 + 5) == f(x) * 0005 + f(x + 1) * 00000008
f(x + 1 + y) == f(x) * f(y) + f(x + 1) * f(y + 1)
```

Going the other direction is a bit more complicated, but not much:

```
f(x - 0) == + f(x) * 00000001 - f(x + 1) * 0000
f(x - 1) == - f(x) * 00000001 + f(x + 1) * 0001
f(x - 2) == + f(x) * 00000002 - f(x + 1) * 0001
f(x - 3) == - f(x) * 00000003 + f(x + 1) * 0002
f(x - 4) == + f(x) * 00000005 - f(x + 1) * 0003
f(x - 5) == - f(x) * 00000008 + f(x + 1) * 0005
f(x - 6) == + f(x) * 00000013 - f(x + 1) * 0008
f(x - y) == ± f(x) * f(y + 1) ± f(x + 1) * f(y)
```

<a name="fibonaccikit-invariants"/>

#### Code coverage with sequence invariants

We have some peculiar algorithms and a generic sequence. Let's use them to
stress test our models! Note that the sequence addition formula can be 
rearranged in such a way that we call all of the basic arithmetic operations.
We don't need to know the inputs and outputs ahead of time, because we know
that this equation must hold true for all indices. It's neat, isn't it?

```swift
f(x) * f(y) == (f(x+y+1) / f(x+1) - f(y+1)) * f(x+1) + f(x+y+1) % f(x+1)
```

<details>
<summary>
Here's the actual implementation that we call in all, or most, of our tests...
</summary>

```swift
/// Generates new instances and uses them to check math invariants.
///
/// #### Invariants
///
/// ```
/// f(x) * f(y) == (f(x+y+1) / f(x+1) - f(y+1)) * f(x+1) + f(x+y+1) % f(x+1)
/// ```
///
/// #### Calls: Fibonacci<Value>
///
/// - Fibonacci.init(\_:)
/// - Fibonacci/increment(by:)
/// - Fibonacci/decrement(by:)
///
/// #### Calls: BinaryInteger
///
/// - BinaryInteger/plus(\_:)
/// - BinaryInteger/minus(\_:)
/// - BinaryInteger/times(\_:)
/// - BinaryInteger/quotient(\_:)
/// - BinaryInteger/division(\_:)
///
func checkMathInvariants() {
    for divisor: Divisor<Value> in [2, 3, 5, 7, 11].map(Divisor.init) {
        always: do {
            var a = self.item as Fibonacci<Value>
            let b = try Fibonacci(a.index.quotient(divisor).prune(Bad.division))
            let c = try a.next.division(Divisor(b.next, prune: Bad.divisor)).prune(Bad.division)
            
            try a.decrement(by: b)
            
            let d = try b.element.times(a.element).prune(Bad.multiplication)
            let e = try c.quotient.minus(a.next).times(b.next).plus(c.remainder).prune(Bad.any)
            
            try a.increment(by: b)
            
            test.same(d, e, "arithmetic invariant error")
            self.same(index: a.index, element: a.element, next: a.next)
            
        }   catch let error {
            test.fail("unexpected arithmetic failure: \(error)")
        }
    }
}
```
</details>

<a name="installation"/>

## Installation

<a name="installation-semver"/>

#### SemVer 2.0.0

> Major version zero (0.y.z) is for initial development.\
> Anything MAY change at any time.\
> The public API SHOULD NOT be considered stable.

<a name="installation-swift-package-manager"/>

#### Swift Package Manager

Add this package to your list of package dependencies.

```swift
.package(url: "https://github.com/oscbyspro/Ultimathnum.git", exact: "x.y.z"),
```

Choose target dependencies from this list of products.

```swift
.product(name: "Ultimathnum",  package: "Ultimathnum"), // umbrella
.product(name: "CoreKit",      package: "Ultimathnum"),
.product(name: "DoubleIntKit", package: "Ultimathnum"),
.product(name: "InfiniIntKit", package: "Ultimathnum"),
.product(name: "FibonacciKit", package: "Ultimathnum"),
```
