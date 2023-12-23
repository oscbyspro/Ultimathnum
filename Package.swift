// swift-tools-version: 5.7
//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
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
        .iOS("16.4"),
        .macCatalyst("16.4"),
        .macOS("13.3"),
        .tvOS("16.4"),
        .watchOS("9.4"),
    ],
    products: [
        //=--------------------------------------=
        // UMN
        //=--------------------------------------=
        .library(
        name: "Ultimathnum",
        targets: ["Ultimathnum"]),
        //=--------------------------------------=
        // UMN x Core Kit
        //=--------------------------------------=
        .library(
        name: "UMNCoreKit",
        targets: ["UMNCoreKit"]),
    ],
    targets: [
        //=--------------------------------------=
        // UMN
        //=--------------------------------------=
        .target(
        name: "Ultimathnum",
        dependencies: ["UMNCoreKit"]),
        //=--------------------------------------=
        // UMN x Core Kit
        //=--------------------------------------=
        .target(
        name: "UMNCoreKit",
        dependencies: []),
        
        .testTarget(
        name: "UMNCoreKitBenchmarks",
        dependencies: ["UMNCoreKit"]),
        
        .testTarget(
        name: "UMNCoreKitTests",
        dependencies: ["UMNCoreKit"]),
    ]
)
