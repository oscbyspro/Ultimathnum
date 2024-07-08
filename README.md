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
  - [What is an unchecked operation?](#nomenclature-unchecked-value)
* [CoreKit](#corekit)
  - [Validation and recovery with Fallible\<Value\>](#corekit-validation)
  - [Let there be binary integers with RootInt](#corekit-rootint)
  - [Access binary integer data with DataInt\<Element\>](#corekit-dataint)
  - [Upsize binary integer elements with DataInt\<U8\>](#corekit-upsize)
  - [Lightweight text decoding and encoding with TextInt](#corekit-text-int)
  - [Type-safe bit casts with BitCastable\<BitPattern\>](#corekit-bit-cast)
  - [Bit counting with Count\<Layout\> and BitCountable](#corekit-bit-count)
  - [Generic logic gates with BitOperable](#corekit-bitwise-logic)
  - [More ones and zeros with Bit, Sign and Signum](#corekit-bit-sign-signum)
* [DoubleIntKit](#doubleintkit)
  - [A big systems integer](#doubleintkit-systems-integer)
  - [A non-recursive model](#doubleintkit-non-recursive-model)
* [InfiniIntKit](#infiniintkit)
  - [Recoverable infinite addition (+/-)](#infiniintkit-addition)
  - [Recoverable infinite multiplication](#infiniintkit-multiplication)
  - [Recoverable infinite division](#infiniintkit-division)
* [StdlibIntKit](#stdlibintkit)
  - [A signed big integer in Swift proper with StdlibInt](#stdlibintkit-bigint)
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

In programming, complexity is sand, and simplicity is a rock. The former is 
a sum of parts. This project unifies abstractions and streamlines models to
keep the parts few and similar to each other.

<a name="introduction-stdlib"/>

#### Keep stdlib extensions to a minimum

This project is mostly self-contained. It only extends the standard library when 
necessary. In practice, this means adding conversion to and from new types. Other 
kinds of functionality either belongs to the new types or is kept private through 
access control. This ensures interoperability without confusion or accidental dependencies.

<a name="introduction-minimalistic"/>

#### Derive all the things!

The are many ways to abstract and there are pros and cons to all of them.
Here, we keep it simple. We use a small set of primitives to derive most things. 
Our abstractions are purposeful and close to the machine. Likewise, you will not 
find many mutating methods. Instead, we opt for consuming methods. This cuts the 
project in half, compared to previous iterations of it.

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
are trivial. A systems integer is represented in memory by its bit pattern. Additionally, a systems 
integer's size is a power of two in 8 through IX.max.

| Size    | Signed | Unsigned |
|--------:|:------:|:--------:|
| pointer | IX     | UX       |
|   8-bit | I8     | U8       |
|  16-bit | I16    | U16      |
|  32-bit | I32    | U32      |
|  64-bit | I64    | U64      |

Systems integers are intentionally simple so that the things you build with them may be simple. 
The only protocol requirements are multiplication and division algorithms for working with full 
precision in generic code, and byte swapping for efficient endianness conversions.

<a name="nomenclature-trusted-input"/>

#### What is a trusted input?

> Trust me, I know what I'm doing...

| Type         | Guarantee |
|:-------------|:----------|
| Divisor      | x ≠ 0     |
| Finite       | x ∈ ℤ     |
| Natural      | x ∈ ℕ     |
| Shift        | x \< size |

Once you start using primitive types to form more complex types, you notice that some behaviors
compose better than others. A trusted input delegates precondition checks to the programmer 
so that complex types can be built with less overhead. The type system will ask you to accept or 
reject such inputs. Your validation strategy will either make your code safer or easier to audit.


```swift
init(_:)         // error: traps
init(_:prune:)   // error: throws
init(exactly:)   // error: nil
init(unchecked:) // error: unchecked
```

<a name="nomenclature-unchecked-value"/>

#### What is an unchecked operation?

We all know that dynamic validation comes at a price. The validation tax tends to be small
in everyday code, but it can be noticeable when working with primitives. That is why some 
operations have unchecked alternatives. In this project, we validate unchecked operations in 
debug mode only. You may realize that it is sometimes correct to ignore errors completely. 
It is, therefore, best to view unchecked operations as semantic markers in performance-sensitive 
places.

```swift
U8.zero.decremented().error       // true, because the result is not representable
U8.zero.decremented().value       // 255,  this is the truncated bit pattern of -1
U8.zero.decremented().unchecked() // 255,  with precondition failure in debug mode
```

<a name="corekit"/>

## CoreKit

<a name="corekit-validation"/>

#### Validation and recovery with Fallible\<Value\>

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
operation accepts both Value and Fallible\<Value\> inputs to make error handling as seamless as possible.
Alternatively, you may use any of the common arithmetic operators for trapping or wrapping results:

```swift
static func  +(lhs: consuming Self, borrowing Self) -> Self // trapping
static func &+(lhs: consuming Self, borrowing Self) -> Self // wrapping
```

<a name="corekit-rootint"/>

#### Let there be binary integers with RootInt

> *We don't know where it comes from, only that it exists.*

You may create integers out of thin air with RootInt, a wrapper around Swift.StaticBigInt. It comes 
with some additional bells and whistles. You may, for example, query whether a generic type can represent 
an integer literal or load the extended bit pattern that fits.

```swift
static func exactly(_ source: RootInt) -> Fallible<Self>
```

<a name="corekit-dataint"/>

#### Access binary integer data with DataInt\<Element\>

Each data integer operates on the contiguous in-memory representation of binary integers without
taking ownership of them. The [Mutable]DataInt.Body type is fundamentally a buffer pointer. The
[Mutable]DataInt type extends the bit pattern of its body with a repeating appendix bit. You may
perform various buffer and arithmetic operations on these types, but remember that their operations
are finite, unsigned, and unchecked by default. Additionally, a data integer subsequence is usually
represented by a rebased instance of the same type.

<a name="corekit-upsize"/>

#### Upsize binary integer elements with DataInt\<U8\>

The data integer types let you downsize binary integer elements by reinterpretation. This versatile
power stems from strict systems integer layout requirements. You may not upsize elements in this way,
however, because the memory alignment of a smaller systems integer may not be compatible with a
larger systems integer. Instead, you may use DataInt\<U8\> to load elements of any size. It performs 
an unaligned load when possible and handles the case where the load would read past the end. All 
binary integers can form a DataInt\<U8\> view since a byte is the smallest possible systems integer type.

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

You may realize that the introduction of infinite values necessitates changes to the integer
description format. The new format adds the # and & markers. The former is a spacer (cf. +)
whereas the latter represents bitwise negation. In other words, +&123 translates to ∞ minus 123.

###### The case-insensitive base 36 regex.

```swift
let regex: Regex = #/^(\+|-)?(#|&)?([0-9A-Za-z]+)$/#
```

While this model prioritizes size, its operations are still fast enough for most purposes. 
The 210k-digit measurement illustrates this point. Keep in mind that hexadecimal radix 
conversions are linear operations, whereas decimal conversions are superlinear but instant 
for numbers intended to be read by humans.

###### MacBook Pro, 13-inch, M1, 2020, -O, code coverage disabled.

```swift
let fib1e6 = try! Fibonacci<UXL>(1_000_000)

let fib1e6r10 = fib1e6.element.description(as:     .decimal) // 0.924s (208988 digits)
let fib1e6r16 = fib1e6.element.description(as: .hexadecimal) // 0.002s (173561 digits)

try! UXL(fib1e6r10, as:     .decimal) // 0.040s (208988 digits)
try! UXL(fib1e6r16, as: .hexadecimal) // 0.002s (173561 digits)
```

###### TextInt optimizes base 2, 4, and 16 conversions (but not 8 or 32).

<a name="corekit-bit-cast"/>

#### Type-safe bit casts with BitCastable\<BitPattern\>

The BitCastable\<BitPattern\> protocol lets you perform type-safe bit casts in bulk. This is 
especially pertinent to binary integers since the abstraction is two representations bridged 
by a bit pattern transformation. You perform type-safe bit-casts by calling init(raw:). 

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
        let superoverflow = distance.value.isNegative != distance.error
        return Distance.exactly(distance.value).veto(superoverflow)
    }
}
```

The above example shows a generic Strideable/distance(from:to:) esque method. In the narrowing 
unsigned case you find that the difference is reinterpreted as a same-size signed integer type 
via the init(raw:) bulk operation. Note that such type relationships are generically available 
to all binary integers. Also, note that this method is both fully generic and fully recoverable.
The init(load:) method is similar, but it returns the bit pattern that fits.

<a name="corekit-bit-count"/>

#### Bit counting with Count\<Layout\> and BitCountable

> Please roll a **D20** arcana check.

An arbitrary binary integer's bit pattern extends infinitely, yet its bit pattern has an end.
Count\<IX\> is a pointer-bit model that can count the bits of any binary integer stored in memory.
It does this by reinterpreting the last bit as logarithmically infinite.

```
min ..< msb: [0,  IX.max + 0]
msb ... max: [∞ - IX.max,  ∞] ≤ log2(UXL.max + 1)
```

All binary integer types and all data integer types let you perform bit-counting operations; 
the BitCountable protocol unifies them. Their common protocol requires methods like *size()* 
and *ascending(\_:)* then derives methods like *entropy()* and *nonascending(\_:)* for them.

<a name="corekit-bitwise-logic"/>

#### Generic logic gates with BitOperable

Types that let you perform bitwise logic, such as AND, OR, XOR, and NOT, conform to BitOperable. 
It powers logic gates in generic code, and all binary integer types conform to it. Arbitrary unsigned 
integers also perform these operations losslessly thanks to the notion of infinite binary integers.

```swift
static prefix func ~(instance: consuming Self) -> Self
static func &(lhs: consuming Self, rhs: borrowing Self) -> Self
static func |(lhs: consuming Self, rhs: borrowing Self) -> Self
static func ^(lhs: consuming Self, rhs: borrowing Self) -> Self
```

<a name="corekit-bit-sign-signum"/>

#### More ones and zeros with Bit, Sign and Signum

This project introduces various additional types. Some are more important than other,
so here's a rundown of the three most prominent ones: Bit, Sign and Signum. Bit and 
Sign are a lot like Bool, but with bitwise operations and no short-circuits. Signum is
most notably the return type of the compared(to:) methods.

| Type   | Values         |
|:-------|---------------:|
| Bit    |       `0`, `1` |
| Sign   |       `+`, `-` |
| Signum | `-1`, `0`, `1` |

<a name="doubleintkit"/>

## DoubleIntKit

> Veni, vidi, vici. I came, I saw, I conquered.

```
 DoubleInt<I128>          DoubleInt<U128>
┌───────────────────────┐┌───────────────────────┐
│ I256                  ││ U256                  │
├───────────┬───────────┤├───────────┬───────────┤
│ U128      │ I128      ││ U128      │ U128      │
├─────┬─────┼─────┬─────┤├─────┬─────┼─────┬─────┤
│ U64 │ U64 │ U64 │ I64 ││ U64 │ U64 │ U64 │ U64 │
└─────┴─────┴─────┴─────┘└─────┴─────┴─────┴─────┘
```

<a name="doubleintkit-systems-integer"/>

#### A big systems integer

The DoubleInt\<Base\> model lets you create software-defined systems integers
larger than the ones supported by your hardware. Like all systems integers, 
it is stored without indirection. This makes it superior to arbitrary precision 
models in situations where the doubled precision is enough. It also has a niche
on the stack when heap allocations are prohibitive.

<a name="doubleintkit-non-recursive-model"/> 

#### A non-recursive model

Given that systems integers need some 2x width operations, it is both easy and
tempting to accept and return DoubleInt\<Base\> instances. Swift's generic type
system even allows it! The problem, however, is that it makes the model recursive
and reliant on unspecialized runtime features. While runtime generics are awesome 
and overpowered in some cases, they're not appropriate for primitives. This is 
why the core module features Doublet\<Base\> instead. Here's a brief illustration 
of how that stops the recusion:

```swift
DoubleInt<Base> -> Doublet  <DoubleInt<Base>> // Doublet cannot upsize itself
DoubleInt<Base> -> DoubleInt<DoubleInt<Base>> -> ............................
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

Addition and subtraction at and around infinity just works.

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
U32.max.times(U32.max) // value: 1, error: true
UXL.max.times(UXL.max) // value: 1, error: true
```

<a name="infiniintkit-division"/>

#### Recoverable infinite division

So, this is where things get tricky. Wait, no, it still just works in most cases.
Since you know finite-by-finite division, I'm sure you intuit that finite-by-infinite
division is trivial and that infinite-by-infinite division is at most one subtraction.
The only weird case is infinite-by-finite division because the proper computation
requires infinite memory. So, in this case, we just let the algorithm run and mark it 
as an error. This yields results similar to signed division.

```swift
dividend == divisor &* quotient &+ remainder // for all binary integers
```

<a name="stdlibintkit"/>

## StdlibIntKit

```      
           Ultimathnum.BinaryInteger                  Swift.BinaryInteger
           ┌───────────┬───────────┐            ┌───────────┬───────────┐
           │  Systems  │ Arbitrary |            │  Systems  │ Arbitrary |
┌──────────┼───────────┤───────────┤ ┌──────────┼───────────┤───────────┤
│   Signed │     X     │     X     │ │   Signed │     X     │     X     │
├──────────┼───────────┤───────────┤ ├──────────┼───────────┤───────────┤
│ Unsigned │     X     │     X     │ │ Unsigned │     X     │           │
└──────────┴───────────┴───────────┘ └──────────┴───────────┴───────────┘
```

<a name="stdlibintkit-bigint"/>

#### A signed big integer in Swift proper with StdlibInt

StdlibInt is super simple. It wraps InfiniInt\<IX\> and conforms to Swift.BinaryInteger
by forwarding all relevant function calls. The latter is approximately a trapping 
Ultimathnum.FiniteInteger plus/minus some miscellaneous stuff. StdlibInt is also its own 
magnitude type since Swift.BinaryInteger does not support the notion of infinity.

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

###### MacBook Pro, 13-inch, M1, 2020, -O, code coverage disabled.

```swift
try! Fibonacci<UXL>( 1_000_000) // 0.04s
try! Fibonacci<UXL>(10_000_000) // 1.65s
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
-------------------------------------------------
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
-----------------------------------------------
f(x - y) == ± f(x) * f(y + 1) ± f(x + 1) * f(y)
```

<a name="fibonaccikit-invariants"/>

#### Code coverage with sequence invariants

We have some cute algorithms and a generic sequence. Let's combine them and
unit-test our models! We can rearrange the sequence addition formula in such 
a way that we call all basic arithmetic operations. Note that we don't need 
to know the inputs and outputs ahead of time because it's an equation. Neat!

```swift
f(x) * f(y) == (f(x+y+1) / f(x+1) - f(y+1)) * f(x+1) + f(x+y+1) % f(x+1)
```

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
.product(name: "FibonacciKit", package: "Ultimathnum"),
.product(name: "InfiniIntKit", package: "Ultimathnum"),
.product(name: "StdlibIntKit", package: "Ultimathnum"),
```
