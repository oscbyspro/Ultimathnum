# Ultimathnum

> Everyone who hears these words of mine and does them is like a wise man who built his house on rock. The rain fell, the flood came, and the winds beat against that house, but it did not collapse because its foundation had been laid on rock. (Matthew 7:24-25)

## Table of Contents

* [Prelude](#prelude)
  - [The abstract symphony](#prelude-the-abstract-symphony)
  - [The grateful guest](#prelude-the-grateful-guest)
* [Installation](#installation)
  - [SemVer 2.0.0](#installation-semver)
  - [Using Swift Package Manager](#installation-swift-package-manager)
  - [How to run unit tests](#installation-how-to-run-unit-tests)
  - [How to run performance tests](#installation-how-to-run-performance-tests)
* [Overview](#overview)
  - [The overpowered `BinaryInteger`](#overview-the-overpowered-binary-integer)
  - [The `Fallible<T>` redemption arc](#overview-the-fallible-redemption-arc)
  - [The precondition `Guarantee` types](#overview-the-precondition-guarantee-types)
  - [The magic `Divider<T>` constants](#overview-the-magic-divider-constants)
  - [The arbitrary bit `Count` unification](#overview-the-arbitrary-bit-count-unification)

<a name="prelude"/>

## Prelude

<a name="prelude-the-abstract-symphony"/>

### The abstract symphony

This work seeks to unify the various concepts of low-level arithmetic. It streamlines error handling and introduces arbitrary binary integer infinities, among other things. But, the emphasis is not on the diversity of ideas but on the orchestration of scalable abstractions. It's more of a symphony than a library.

<a name="prelude-the-grateful-guest"/>

### The grateful guest

In this project, we build custom abstractions using Swift's powerful type system. In gratitude, we extend our functionality to Swift-proper through various interoperability modules. Importing these modules gives you access types conforming to the appropriate protocols.

```swift
var randomness = RandomInt() // from RandomIntKit
let random = Bool.random(using: &randomness.stdlib) // from Swift
```

Some models—like the core binary integer types and the system random number generator—are intrinsically interoperable, meaning their `stdlib()` functions return appropriate standard library types. As a result, the interoperability features of the `Interoperable` protocol do not introduce any unnecessary monomorphization.

<a name="installation"/>

## Installation

<a name="installation-semver"/>

### SemVer 2.0.0

Please install the latest release, or a specific commit.

> Major version zero (0.y.z) is for initial development.\
> Anything MAY change at any time.\
> The public API SHOULD NOT be considered stable.

<a name="installation-swift-package-manager"/>

### Swift Package Manager

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
.product(name: "RandomIntKit", package: "Ultimathnum"),

.product(name: "Ultimathiop",  package: "Ultimathnum"), // umbrella
.product(name: "CoreIop",      package: "Ultimathnum"),
.product(name: "DoubleIntIop", package: "Ultimathnum"),
.product(name: "InfiniIntIop", package: "Ultimathnum"),
.product(name: "RandomIntIop", package: "Ultimathnum"),
```

<a name="installation-how-to-run-unit-tests"/>

### How to run unit tests

Run unit tests with the following terminal command(s):

```
swift test --skip Benchmarks -Xswiftc -O
swift test --skip Benchmarks -Xswiftc -O --configuration release
```

<a name="installation-how-to-run-performance-tests"/>

### How to run performance tests

Run performance tests with the following terminal command(s):

```
xcodebuild test -scheme Ultimathnum-Performance -destination 'platform=macOS'
```

This setup enables optimizations and omits unrelated metrics. These steps are critical since the project is both abstracted and modularized. Omitting compiler optimizations degrades performance by up to two orders of magnitude. Similarly, failing to omit code coverage degrades performance by another order of magnitude. If your measurements show poor results for reasonable inputs, feel free to open an issue about it or ask any questions you may have.

<a name="overview"/>

## Overview

<a name="overview-the-overpowered-binary-integer"/>

### The overpowered `BinaryInteger`

```
           ┌───────────┬───────────┐
           │  Systems  │ Arbitrary │
┌──────────┼───────────┤───────────┤
│   Signed │ B,E,F,S,X │  A,B,F,X  │
├──────────┼───────────┤───────────┤
│ Unsigned │ B,E,F,S,Y │  A,B,E,Y  │
└──────────┴───────────┴───────────┘
 A) ArbitraryInteger: B
 B)    BinaryInteger: -
 E)      EdgyInteger: B
 F)    FiniteInteger: B
 S)   SystemsInteger: E, F
 X)    SignedInteger: F
 Y)  UnsignedInteger: E
```

#### The lossy invariant

Lossy operations are remarkably well-behaved. In the case of binary integers, we use this term specifically to denote truncation. In other words, lossy binary integer results omit bits that don't fit, meaning all existing bits are still valid. In practice, types of different sizes agree on the bits that fit in the smaller type. The following example demonstrates this invariant.

```swift
let a = I32.random()
let b = I32.random()
#expect((a).times(b) == I32.exactly(IXL(a) * IXL(b)))
```

#### Type-agnostic hashes

Binary integers of equal value agree on a common low-level representation, specifically, the contents of their normalized byte sequences. This common ground produces equal hashes for equal values across type boundaries. Note that we may use this reinterpretation strategy to perform comparisons too. The following snippet of code shows you what to expect.

```swift
let x = I32.random()
#expect(x.hashValue == I64(x).hashValue)
#expect(x.hashValue == IXL(x).hashValue)
```

#### Lone description coder

You may need to convert binary integers to human-readable text. In that case, `description(using:)` and `init(_:using:)` let you perform dynamic radix conversions using the given coder. It uses a fixed number of non-generic and non-inlinable algorithms to encode and decode all binary integer types.

```swift
//  MacBook Pro, 13-inch, M1, 2020, -O, code coverage disabled.

let fib1e6    = IXL.fibonacci(1_000_000)                // 0.015s
let fib1e6r10 = fib1e6.description(using:     .decimal) // 0.297s (208988 numerals)
let fib1e6s10 = IXL(((fib1e6r10)), using:     .decimal) // 0.040s (208988 numerals)
let fib1e6r16 = fib1e6.description(using: .hexadecimal) // 0.002s (173561 numerals)
let fib1e6s16 = IXL(((fib1e6r16)), using: .hexadecimal) // 0.002s (173561 numerals)
```

<a name="overview-the-fallible-redemption-arc"/>

### The `Fallible<T>` redemption arc

The value-error pair is undoubtedly a top-tier recovery mechanism when the value preserves relevant information, like in many binary integer operations. `Fallible<T>` supercharges this idea by adding powerful transformations and ergonomic utilities. It promotes soundness by streamlining the process of propagating errors. Let's get you up to speed by examining your scalable error-handling arsenal.

#### Propagation: `veto(_:)`, `map(_:)`, `sink(_:)`

A single error is usually enough to invalidate an operation, but you may want to group all errors corresponding to a semantically meaningful unit of work. The `veto(_:)` operation allows you to combine multiple error indicators efficiently and with ease. It forwards the underlying value alongside the logical disjunction of the current error indicator and the given argument. Here's how it works in practice.

```swift
U8.max.veto(false).veto(false) // value: 255, error: false
U8.max.veto(false).veto(true ) // value: 255, error: true
U8.max.veto(true ).veto(false) // value: 255, error: true
U8.max.veto(true ).veto(true ) // value: 255, error: true
```

Chaining multiple expressions is a common functional approach and something you may want to consider. The `map(_:)` transforms the underlying value and merges additional error indicators at the end of the given function. Please take a close look at the following example. We'll revisit it in a moment.

```swift
func sumsquare<T: UnsignedInteger>(a: T, b: T) -> Fallible<T> {
    a.plus(b).map{$0.squared()}
}
```

Now that you know the basics of error propagation, let's equip you with the means to take on the world. While `map(_:)` is fantastic, at times, you may have noticed that it sometimes devolves into a pyramid of doom. In other words, it doesn't scale to fit the needs of more complex problems. But do not worry, the `sink(_:)` method has arrived! It lets you offload error indicators between operations. Let's rewrite our example by using another formula.

```swift
func sumsquare<T: UnsignedInteger>(a: T, b: T) -> Fallible<T> {
    var w: Bool = false
    let x: T = a.squared().sink(&w)
    let y: T = a.times(b ).sink(&w).doubled().sink(&w)
    let z: T = b.squared().sink(&w)
    return x.plus(y).sink(&w).plus(z).veto(w)
}
```

#### Transformation: `optional()`, `result(_:)`, `prune(_:)`

The value-error pair has important properties for writing expressive library code. But what if you're the end user? Good news! Let's take a look at `optional()`, `result(_:)` and `prune(_:)`. The first two methods transform errors into well-understood types with similar names, nice and simple. The last one throws its argument on error. Imagine a laid-back version of `sink(_:)`. Let's rewrite our example again, using `prune(_:)` this time.

```swift
enum Oops: Error { case such, error, much, wow, very, impressive }

func sumsquare<T: UnsignedInteger>(a: T, b: T) throws(Oops) -> T {
    let x: T = try a.squared().prune(Oops.such)
    let y: T = try a.times(b ).prune(Oops.error).doubled().prune(Oops.much)
    let z: T = try b.squared().prune(Oops.wow)
    return try x.plus(y).prune(Oops.very).plus(z).prune(Oops.impressive)
}
```

#### Expectation: `unwrap(_:)`, `unchecked(_:)`

What about expectations? Sometimes, you make a fallible function call that should never produce an error; the function only happens to be generalized beyond the scope of the call site. In that case, an error would indicate program misbehavior. Consider using `unwrap(_:)` to stop program execution and `unchecked(_:)` to stop program execution of unoptimized builds only. Additionally, you may pass a clarifying comment for debugging purposes.

```swift
U8.min.incremented().unwrap("precondition") // must not fail
U8.min.incremented().unchecked("assertion") // must not fail, must go brrr
```

#### Destructuring: `value`, `error`, `components()`

While `Fallible<T>` strives to streamline the error-handling process, perhaps you like to do things manually. Good luck, have fun! You can read and write to its value and error fields. Alternatively, consider destructuring the pair by invoking the consuming `components()` method.

```swift
var pair = Fallible("Hello")
pair.value.append(", World")
pair.error.toggle()
let (value, error) = pair.components()
```

#### Conveniences: `error(...)`, `init(_:error:setup:)`

With sufficient hands-on experience, you may notice some recurring usage patterns. The ever-so-useful `sink(_:)` method requires a mutable error indicator that you usually want to merge at the end—for example. The static `error(...)` functions cover you on both fronts. At other times, you may want to consume an initial value. In that case, you should consider using `init(_:error:setup:)`.

```swift
let x0 = Fallible.error {
    U8.zero.decremented().sink(&$0)
}   // value: 255, error: true

let x1 = Fallible(U8.zero) {
    $0 = $0.decremented().sink(&$1)
}   // value: 255, error: true
```

<a name="overview-the-precondition-guarantee-types"/>

### The precondition `Guarantee` types

| Type         | Guarantee          |
|:-------------|:-------------------|
| Divider      | x ≠ 0              |
| Finite       | x ∈ ℤ              |
| Natural      | x ∈ ℕ              |
| Nonzero      | x ≠ 0              |
| Shift        | x ∈ 0 up to T.size |

Guarantee types encode their preconditions into the type system. You may leverage their semantics to compose complex types with less overhead or reduce the number of failure modes in your algorithms. Additionally, the type system will prompt you to accept or reject their arguments using one of the following methods.

```swift
init(_:prune:)   // error: throws
init(exactly:)   // error: nil
init(_:)         // error: precondition
init(unchecked:) // error: assert
init(unsafe:)    // error: %%%%%%
```

<a name="overview-the-magic-divider-constants"/>

### The magic `Divider<T>` constants

You know how the compiler sometimes replaces division with multiplication, right? Great, now you can be a wizard too! `Divider<T>` and `Divider21<T>` find magic constants and divide numbers using only multiplication, addition, and shifts. Note that the latter divides numbers twice the size of the corresponding divisor.

```swift
let random  = U8.random()
let divisor = Nonzero(U8.random(in: 1...255))
let divider = Divider(divisor)
let typical = random.division(divisor) as Division<U8, U8> // div
let magical = random.division(divider) as Division<U8, U8> // mul-add-shr
precondition(typical == magical) // quotient and remainder
```

```swift
let random  = Doublet(low: U8.random(), high: U8.random())
let divisor = Nonzero(U8.random(in: 1...255))
let divider = Divider21(divisor)
let typical = U8.division(random, by: divisor) as Fallible<Division<U8, U8>>
let magical = U8.division(random, by: divider) as Fallible<Division<U8, U8>>
precondition(typical == magical) // quotient, remainder, and error indicator
```

<a name="overview-the-arbitrary-bit-count-unification"/>

### The arbitrary bit `Count` unification

> Please roll a D20 arcana check.

An arbitrary integer's bit pattern extends infinitely—yet it has an end. It must be this way, or it would be unlike its systems integer brothers and sisters. As such, we need a different model to represent arbitrary integer sizes. `Count` satisfies our need by reinterpreting the last bit of a machine word as logarithmically infinite.

```
UXL.max = &0
min ..< msb: [0,  IX.max + 0]
msb ... max: [∞ - IX.max,  ∞] ≤ log2(&0+1)
```
