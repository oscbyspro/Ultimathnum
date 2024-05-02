# Ultimathnum

> Binary integers are dead.\
> Long live binary integers!

## Table of Contents

* [CoreKit](#corekit)
* [DoubleIntKit](#doubleintkit)
* [FibonacciKit](#fibonaccikit)
* [InfiniIntKit](#infiniintkit)
* [Installation](#installation)

<a name="corekit"/>

## CoreKit

> [!IMPORTANT]
> Work in progress...

### Protocols

- BinaryInteger
- BitCastable
- BitCountable
- BitOperable
- BitSelection
- CoreInteger
- EnclosedInteger
- Functional
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
- MakeInt
- Shift
- Sign
- Signed
- Signum
- TextInt
- Triplet
- Unsigned

<a name="doubleintkit"/>

## DoubleIntKit

> [!IMPORTANT]
> Work in progress...

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
mutating func increment() throws // index + 1
mutating func decrement() throws // index - 1
mutating func    double() throws // index * 2
```

<a name="infiniintkit"/>

## InfiniIntKit

> [!IMPORTANT]
> Work in progress...

<a name="installation"/>

## Installation

> [!IMPORTANT]
> Work in progress...
