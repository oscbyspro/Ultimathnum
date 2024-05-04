# Ultimathnum

> [!IMPORTANT]
> Work in progress...

## Table of Contents

* [Introduction](#introduction)
* [CoreKit](#corekit)
* [DoubleIntKit](#doubleintkit)
* [InfiniIntKit](#infiniintkit)
* [FibonacciKit](#fibonaccikit)
* [Installation](#installation)

<a name="introduction"/>

## Introduction

> It doesn't matter how many times you fall.\
> It matters how many time you get back up.

### What's a binary integer?

This project presents a novel binary integer abstraction that works for all sizes.
In fact, it views all binary integers as infinite bit sequences with various modes of operation.
It also extends the maximum unsigned value to infinity and lets you recover from failure through 
an intuitive and ergonomic failure propagation mechanism.

```swift
IXL(raw: 0 &- 1 as UXL) == -1
UXL(raw: 0 &- 1 as IXL) == ~0
```

```
func sum<T: BinaryInteger>(_ a: T, b: T) throws(Oops) -> T {
    a.plus(b).prune(Oops.overflow) // the error can be whatever
}
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

The abstraction layer.

### Protocols

- BinaryInteger
- BitCastable
- BitCountable
- BitOperable
- BodyInteger
- CoreInteger
- DataInteger
- EnclosedInteger
- SignedInteger
- Signedness
- SystemsInteger
- UnsignedInteger

### Models

- Bit
- CoreInt
- DataInt
- Division
- Divisor
- Doublet
- Fallible
- LoadInt
- RootInt
- Shift
- Sign
- Signed
- Signum
- TextInt
- Triplet
- Unsigned

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

> [!IMPORTANT]
> Work in progress...
