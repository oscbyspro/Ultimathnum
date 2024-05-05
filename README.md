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

In practice, an infinite integer is represented by its least significant *body* elements,
followed by a repetition of its *appendix* bit. All signed and/or infinite integers store
this bit in memory, but unsigned fixed-width integers return zero through the type system. 
This makes all *systems* integers compatible with the standard un/signed two's complement
representation.

```
~(~(x)) == x for all x
┌────────────────────┐
│ some BinaryInteger │
├──────┬─────────────┤
│ body │ appendix... │
└──────┴─────────────┘
```

Some definitions have been updated to fit the new binary integer format. What was once called
the sign bit is now the appendix bit. This means a so-called signed right shift treats an infinite
unsigned integer like a negative signed integer.

```swift
(~2 as UXL) >> 1 == (~1 as UXL)
(~1 as UXL) >> 1 == (~0 as UXL)
(~0 as UXL) >> 1 == (~0 as UXL)
( 0 as UXL) >> 1 == ( 0 as UXL)
( 1 as UXL) >> 1 == ( 0 as UXL)
( 2 as UXL) >> 1 == ( 1 as UXL)
```

<a name="corekit"/>

## CoreKit

> It doesn't matter how many times you fall.\
> It matters how many time you get back up.

### Validation and recovery through `Fallible<Value>`.

Proper error handling is a cornerstone of this project and a lot of effort goes into ensuring
that a path to redemption. The `Fallible<Value>` wrapper plays an important part in this story. 
Use it to handle errors when you want, and how you want. Here's a real example from the generic 
`Fibonacci<Value>` sequence:

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

Note that each operation propagates failure by setting `Fallible<Value>`'s error indicator, which is 
lazily checked in the throwing *prune(\_:)* method. Alternatively, you may use *optional(\_:)*, *result(\_:)*
*unwrap(\_:)*, *assert(\_:)* or plain *value* and *error* to validate your results. Also, note that each
operation accepts both `Value` and `Fallible<Value>` inputs to make error handling as seamless as possible.
In the same vein, use any of the common arithmetic operators for trapping or wrapping results:

```swift
static func  +(lhs: consuming Self, borrowing Self) -> Self // trapping
static func &+(lhs: consuming Self, borrowing Self) -> Self // wrapping
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
