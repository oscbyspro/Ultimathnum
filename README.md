# Ultimathnum

> [!IMPORTANT]\
> This is an experimental work in progress.

## Table of Contents

* [Introduction](#introduction)
* [CoreKit](#corekit)
* [DoubleIntKit](#doubleintkit)
* [InfiniIntKit](#infiniintkit)
* [FibonacciKit](#fibonaccikit)
* [Installation](#installation)

<a name="introduction"/>

## Introduction

> Binary integers are dead.\
> Long live binary integers!

### What's a binary integer?

This project presents a novel binary integer abstraction that works for all sizes.
In fact, it views all binary integers as infinite bit sequences with various modes of operation.
It also extends the maximum unsigned value to infinity and lets you recover from failure through 
intuitive and ergonomic error propagation mechanisms.

```swift
(~0 as IXL) // -1
(~1 as IXL) // -1 - 1
(~0 as UXL) //  ∞
(~1 as UXL) //  ∞ - 1
```

Some definitions have been updated to fit the new binary integer format. What was once called
the *sign* bit is now the *appendix* bit. This means a so-called signed right shift treats an 
infinite unsigned integer like a negative signed integer.

```swift
(~2 as UXL) >> 1 == (~1 as UXL)
(~1 as UXL) >> 1 == (~0 as UXL)
(~0 as UXL) >> 1 == (~0 as UXL)
( 0 as UXL) >> 1 == ( 0 as UXL)
( 1 as UXL) >> 1 == ( 0 as UXL)
( 2 as UXL) >> 1 == ( 1 as UXL)
```

In practice, an infinite integer is represented by its least significant *body* elements,
followed by an infinite repetition of its *appendix* bit. All signed integers and all infinite 
integers store this bit in memory, but unsigned *systems* integers return zero through the 
type system. This makes all *systems* integers compatible with the un/signed two's complement format.

```
~(~(x)) == x for all x
┌────────────────────┐
│ some BinaryInteger │
├──────┬─────────────┤
│ body │ appendix... │
└──────┴─────────────┘
```

### What's a data integer?

A binary integer must provide contigous access to their endianess sensitive *body*. This
allocation may be viewed through a *data* integer. Such types keep track of memory alignment 
and may downsize their element type by through reinterpretation.

| some DataInteger           | some DataIntegerBody           |
|:---------------------------|:-------------------------------|
| DataInt\<Element\>         | DataInt\<Element\>.Body        |
| MutableDataInt\<Element\>  | MutableDataInt\<Element\>.Body |

Note that element reinrepretation simplifies the binary integer conversion process. All 
binary integers implement a fixed number of conversions to and from *data* integers and 
intrinsic *systems* integer types. This prevents the square-matrix-of-doom formed by generic 
conversion requirements. 

### What's a systems integer?

You may realize that the infinite bit pattern definition binary integers implies a static size
for all such types. Indeed, you can compare the size of all binary integers through their type
meta data. Still, not all binary integers are trivial. A *systems* integer is represented in memory
by its bit pattern. Additionally, a systems integer's size must be a power of two in [8, IX.max].

| Signed | Unsigned |
|:------:|:--------:|
| IX     | UX       |
| I8     | U8       |
| I16    | U16      |
| I32    | U32      |
| I64    | U64      |

Systems integers are intentionally simple, because it's better to remove complexity than deal
with it. The only protocol requirements are multiplication and divison algorithms for working
with full precision in generic code.

<a name="corekit"/>

## CoreKit

> It doesn't matter how many times you fall.\
> It matters how many time you get back up.

### Validation and recovery through Fallible\<Value\>.

Proper error handling is a cornerstone of this project and a lot of effort goes into ensuring
that a path to redemption. The Fallible\<Value\> wrapper plays an important part in this story.
Use it to handle errors when you want and how you want. Here's a real example from the generic 
Fibonacci\<Value\> sequence:

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
lazily checked in the throwing *prune(\_:)* method. Alternatively, you may use *optional(\_:)*, *result(\_:)*
*unwrap(\_:)*, *assert(\_:)* or plain *value* and *error* to validate your results. Also, note that each
operation accepts both `Value` and Fallible\<Value\> inputs to make error handling as seamless as possible.
In the same vein, use any of the common arithmetic operators for trapping or wrapping results:

```swift
static func  +(lhs: consuming Self, borrowing Self) -> Self // trapping
static func &+(lhs: consuming Self, borrowing Self) -> Self // wrapping
```

### Upsize binary integer elements with LoadInt\<Element\>

The *data* integer types lets you downsize *binary* integer elements by reinterpretation. This awesome power 
comes from the strict *systems* integer memory layout requirements. Note that you may not upsize integers in 
this way because the memory alignment of a smaller *systems* integer may not be compatible with a larger *systems* 
integer. Instead, you may use LoadInt\<Element\> to load elements of any size. It performs an unaligned load when
possible and handles the case where the load would read past the end.

### Perform type-safe bit casts with BitCastable\<BitPattern\>

The BitCastable\<BitPattern\> protocol lets you perform this type-safe bit casts in bulk. This is expecially
pertinent to binary integer algorithms since the binary integer abstraction is basically two representations
bridged by a common bit pattern transformation. 

```swift
U8(raw:  -1 as I8) // 255
I8(raw: 255 as U8) //  -1
```

The *init(raw:)* initializer is basically *init(load:)* with a same-size requirement, so it should be free as
long as the optimizer wills it. Each BitCastable\<BitPattern\> types provides an input and output conversion, 
which allows this type-safe operation to cascade through nested objects.

```swift
@inlinable public consuming func distance<Other>(
    to other: Self,
    as type: Other.Type = Other.self
)   -> Fallible<Other> where Other: SignedInteger {
    
    if  Self.size < Other.size {
        return Other(load: other).minus(Other(load: self))
    
    }   else if Self.isSigned {
        return other.minus(self).map(Other.exactly)
        
    }   else {
        let distance = Fallible<Signitude>(raw: other.minus(self))
        let superoverflow = (distance.value).isNegative != distance.error
        return Other.exactly(distance.value).invalidated(superoverflow)
    }
}
```

The above example shows the a generic *Strideable/distance(from:to:)*-esque method. In the unsigned, 
narrowing, case you find that the subtraction is immediately converted to a same-size signed integer 
type via the *init(raw:)* bulk operation. Note that such type relationships are generically available 
to all binary integers. Also, note that this method is both fully generic and fully recoverable. 

<details>
<summary>
Here's how you would translate it to <i>Strideable/distance(from:to:)</i>-proper...
</summary>

```swift
@inlinable public consuming func distance(to other: Self) -> Swift.Int {
    Swift.Int(self.distance(to: other, as: IX.self).unwrap())
}
```
</details>

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

<a name="fibonaccikit"/>

## FibonacciKit

> Question: How do you test silly numbers?\
> Answer: With silly number generators, of course!

### Fibonacci

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

<a name="installation"/>

## Installation

This project contains several modules. Import some or all of them.

### [SemVer 2.0.0](https://semver.org)

> Major version zero (0.y.z) is for initial development.\
> Anything MAY change at any time.\
> The public API SHOULD NOT be considered stable.

### [Swift Package Manager](https://swift.org/package-manager)

Add this package to your list of package dependencies.

```swift
.package(url: "https://github.com/oscbyspro/Ultimathnum.git", exact: "x.y.z"),
```

Choose target dependencies from the products in [Package.swift](Package.swift).

```swift
.product(name: "Ultimathnum",  package: "Ultimathnum"), // umbrella
.product(name: "CoreKit",      package: "Ultimathnum"),
.product(name: "DoubleIntKit", package: "Ultimathnum"),
.product(name: "InfiniIntKit", package: "Ultimathnum"),
.product(name: "FibonacciKit", package: "Ultimathnum"),
```
