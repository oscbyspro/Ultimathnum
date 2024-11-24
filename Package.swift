// swift-tools-version: 6.0
//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import PackageDescription

//*============================================================================*
// MARK: * Ultimathnum
//*============================================================================*

let package = Package(
    name: "Ultimathnum",
    platforms: [
        .iOS(.v17),
        .macCatalyst(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
    ],
    products: [
        .library(
            name: "CoreIop",
            targets: ["CoreIop"]
        ),
        .library(
            name: "CoreKit",
            targets: ["CoreKit"]
        ),
        .library(
            name: "DoubleIntIop",
            targets: ["DoubleIntIop"]
        ),
        .library(
            name: "DoubleIntKit",
            targets: ["DoubleIntKit"]
        ),
        .library(
            name: "FibonacciKit",
            targets: ["FibonacciKit"]
        ),
        .library(
            name: "InfiniIntIop",
            targets: ["InfiniIntIop"]
        ),
        .library(
            name: "InfiniIntKit",
            targets: ["InfiniIntKit"]
        ),
        .library(
            name: "RandomIntKit",
            targets: ["RandomIntKit"]
        ),
        .library(
            name: "Ultimathnum",
            targets: ["Ultimathnum"]
        ),
    ],
    targets: [
        .testTarget(
            name: "Benchmarks",
            dependencies: ["Ultimathnum", "TestKit"]
        ),
        .target(
            name: "CoreIop",
            dependencies: ["CoreKit"]
        ),
        .testTarget(
            name: "CoreIopTests",
            dependencies: ["CoreIop", "TestKit"]
        ),
        .target(
            name: "CoreKit",
            dependencies: []
        ),
        .testTarget(
            name: "CoreKitTests",
            dependencies: ["CoreKit", "TestKit"]
        ),
        .target(
            name: "DoubleIntIop",
            dependencies: ["CoreIop", "DoubleIntKit"]
        ),
        .testTarget(
            name: "DoubleIntIopTests",
            dependencies: ["DoubleIntIop", "TestKit", "InfiniIntIop"]
        ),
        .target(
            name: "DoubleIntKit",
            dependencies: ["CoreKit"]
        ),
        .testTarget(
            name: "DoubleIntKitTests",
            dependencies: ["DoubleIntKit", "TestKit"]
        ),
        .target(
            name: "FibonacciKit",
            dependencies: ["CoreKit"]
        ),
        .testTarget(
            name: "FibonacciKitTests",
            dependencies: ["DoubleIntKit", "FibonacciKit", "InfiniIntKit", "TestKit"]
        ),
        .target(
            name: "InfiniIntIop",
            dependencies: ["CoreIop", "InfiniIntKit"]
        ),
        .testTarget(
            name: "InfiniIntIopTests",
            dependencies: ["InfiniIntIop", "TestKit"]
        ),
        .target(
            name: "InfiniIntKit",
            dependencies: ["CoreKit"]
        ),
        .testTarget(
            name: "InfiniIntKitTests",
            dependencies: ["InfiniIntKit", "TestKit"]
        ),
        .target(
            name: "PrototypeKit",
            dependencies: ["CoreKit"]
        ),
        .testTarget(
            name: "PrototypeKitTests",
            dependencies: ["PrototypeKit", "TestKit"]
        ),
        .target(
            name: "RandomIntKit",
            dependencies: ["CoreKit"]
        ),
        .testTarget(
            name: "RandomIntKitTests",
            dependencies: ["RandomIntKit", "TestKit"]
        ),
        .target(
            name: "TestKit",
            dependencies: ["CoreKit", "RandomIntKit"]
        ),
        .target(
            name: "Ultimathnum",
            dependencies: ["CoreIop", "DoubleIntIop", "FibonacciKit", "InfiniIntIop", "RandomIntKit"]
        ),
        .testTarget(
            name: "UltimathnumTests",
            dependencies: ["Ultimathnum", "TestKit"]
        ),
    ]
)
