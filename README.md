# Ultimathnum

> Everyone who hears these words of mine and does them is like a wise man who built his house on rock. The rain fell, the flood came, and the winds beat against that house, but it did not collapse because its foundation had been laid on rock. (Matthew 7:24-25)

## Table of Contents

* [Introduction](#introduction)
  - [Holistic low-level abstractions](#introduction-holistic-low-level-abstractions)
  - [How can I support this project?](#introduction-how-can-i-support)
* [Installation](#installation)
  - [SemVer 2.0.0](#installation-semver)
  - [Using Swift Package Manager](#installation-swift-package-manager)
  - [How to run unit tests](#installation-how-to-run-unit-tests)
  - [How to run performance tests](#installation-how-to-run-performance-tests)
* [Overview](#overview)
  - [The overpowered `BinaryInteger`](#overview-binary-integers)
  - [The `Fallible<T>` redemption arc](#overview-the-fallible-redemption-arc)

<a name="introduction"/>

## Introduction

<a name="introduction-holistic-low-level-abstractions"/>

#### Holistic low-level abstractions

> TODO...

<a name="introduction-how-can-i-support"/>

#### How can I support this project?

Leave a like; it doesn't hurt. I'm also open to work.

<a name="installation"/>

## Installation

<a name="installation-semver"/>

#### SemVer 2.0.0

Please install the latest release, or a specific commit.

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
.product(name: "RandomIntKit", package: "Ultimathnum"),
.product(name: "StdlibIntKit", package: "Ultimathnum"),
```

<a name="installation-how-to-run-unit-tests"/>

#### How to run unit tests

Run unit tests with the following terminal command(s):

```
swift test --skip Benchmarks -Xswiftc -O
swift test --skip Benchmarks -Xswiftc -O --configuration release
```

<a name="installation-how-to-run-performance-tests"/>

#### How to run performance tests

Run performance tests with the following terminal command(s):

```
xcodebuild test -scheme Ultimathnum-Performance -destination 'platform=macOS'
```

The above Xcode scheme enables optimizations and disables instrumentation that may limit performance. These steps are exceptionally important for this project since it is both highly abstracted and highly modularized. Omitting compiler optimizations reduces performance by up two orders of magnitude, for example. Similarly, failing to ommit code coverage reduces performance by yet another order of magnitude. If your measurements show poor results for reasonable inputs, feel free to open an issue about it or ask any questions that you may have.

<a name="overview"/>

## Overview

<a name="overview-binary-integers"/>

#### The overpowered `BinaryInteger`

> TODO...

<a name="overview-the-fallible-redemption-arc"/>

#### The `Fallible<T>` redemption arc

The value-error pair is undoubtedly a top-tier recovery mechanism when the value preserves relevant information, like in many binary integer operations. `Fallible<T>` supercharges this idea by adding powerful transformations and ergonomic utilities. It promotes soundness by easing the process of propagating errors. Let's get you up to speed by examining your scalable error-handling arsenal.

##### Propagation: `veto(_:)`

A single error is usually enough to invalidate an operation, but you may want to group all errors corresponding to a semantically meaningful unit of work. The `veto(_:)` operation lets you efficiently combine multiple errors. It forwards its value, along with the logical disjunction of its error indicator and the given argument. Here's how it works in practice.

```swift
U8.max.veto(false).veto(false) // value: 255, error: false
U8.max.veto(false).veto(true ) // value: 255, error: true
U8.max.veto(true ).veto(false) // value: 255, error: true
U8.max.veto(true ).veto(true ) // value: 255, error: true
```

##### Propagation: `map(_:)`

Chaining multiple expressions is a common functional approach and something you may want to consider. The `map(_:)` transforms the underlying value and marges additional error indicators at the end of the given function. Please take a close look at the following example. We'll revisit it in a moment.

```swift
func sumsquare<T: UnsignedInteger>(a: T, b: T) -> Fallible<T> {
    a.plus(b).map{$0.squared()}
}
```

##### Propagation: `sink(_:)`

Now that you know the basics of error propagation, let's equip you with the means to take on the world. While `map(_:)` is fantastic, at times, you may have noticed that it sometimes devolves into a pyramid-of-doom. In short, it doesn't scale. But do not fret! You may use the `sink(_:)` method to offload error indicators between operations. Let's rewrite our example by using another formula.

```swift
// tip: Fallible.sink(_:) creates the Bool and calls veto(_:)

func sumsquare<T: UnsignedInteger>(a: T, b: T) -> Fallible<T> {
    var w: Bool = false
    let x: T = a.squared().sink(&w)
    let y: T = a.times(b ).sink(&w).times(2).sink(&w)
    let z: T = b.squared().sink(&w)
    return x.plus(y).sink(&w).plus(z).veto(w)
}
```

##### Propagation: `optional(_:)`, `result(_:)` and `prune(_:)`

The value-error pair has important properties for writing expressive library code. But what if you're the end user? Good news! Let's take a look at `optional(_:)`, `result(_:)` and `prune(_:)`. The first two methods transform errors into well-understood types with similar names, nice and simple. The last one throws its argument on error. Imagine a laid-back version of `sink(_:)`. Let's rewrite our example again, using `prune(_:)` this time.

```swift
enum Oops: Error { case such, error, much, wow, very, impressive }

func sumsquare<T: UnsignedInteger>(a: T, b: T) throws -> T {
    let x: T = try a.squared().prune(Oops.such)
    let y: T = try a.times(b ).prune(Oops.error).times(2).prune(Oops.much)
    let z: T = try b.squared().prune(Oops.wow)
    return try x.plus(y).prune((Oops.very)).plus(z).prune(Oops.impressive)
}
```
