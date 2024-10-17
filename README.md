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

> Todo...

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

> TODO...
