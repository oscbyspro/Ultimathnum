// swift-tools-version: 5.9
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
        .iOS(.v17),
        .macCatalyst(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
    ],
    products: [
        //=--------------------------------------=
        // Ultimathnum
        //=--------------------------------------=
        .library(
        name: "Ultimathnum",
        targets: ["Ultimathnum"]),
        //=--------------------------------------=
        // Core Kit
        //=--------------------------------------=
        .library(
        name: "CoreKit",
        targets: ["CoreKit"]),
        //=--------------------------------------=
        // Double Int Kit
        //=--------------------------------------=
        .library(
        name: "DoubleIntKit",
        targets: ["DoubleIntKit"]),
        //=--------------------------------------=
        // Infini Int Kit
        //=--------------------------------------=
        .library(
        name: "InfiniIntKit",
        targets: ["InfiniIntKit"]),
        //=--------------------------------------=
        // Normal Int Kit
        //=--------------------------------------=
        .library(
        name: "NormalIntKit",
        targets: ["NormalIntKit"]),
    ],
    targets: [
        //=--------------------------------------=
        // Ultimathnum
        //=--------------------------------------=
        .target(
        name: "Ultimathnum",
        dependencies: [
            "CoreKit",
            "DoubleIntKit",
            "InfiniIntKit",
            "NormalIntKit",
        ]),
        
        .testTarget(
        name: "UltimathnumTests",
        dependencies: ["Ultimathnum", "TestKit"]),
        //=--------------------------------------=
        // Core Kit
        //=--------------------------------------=
        .target(
        name: "CoreKit",
        dependencies: []),
        
        .testTarget(
        name: "CoreKitTests",
        dependencies: [
            "CoreKit",
            "DoubleIntKit",
            "InfiniIntKit",
            "NormalIntKit",
            "TestKit",
        ]),
        //=--------------------------------------=
        // Double Int Kit
        //=--------------------------------------=
        .target(
        name: "DoubleIntKit",
        dependencies: ["CoreKit"]),
        
        .testTarget(
        name: "DoubleIntKitTests",
        dependencies: ["DoubleIntKit", "TestKit"]),
        //=--------------------------------------=
        // Infini Int Kit
        //=--------------------------------------=
        .target(
        name: "InfiniIntKit",
        dependencies: ["CoreKit"]),
        
        .testTarget(
        name: "InfiniIntKitTests",
        dependencies: ["InfiniIntKit", "TestKit"]),
        //=--------------------------------------=
        // Normal Int Kit
        //=--------------------------------------=
        .target(
        name: "NormalIntKit",
        dependencies: ["CoreKit"]),
        
        .testTarget(
        name: "NormalIntKitTests",
        dependencies: ["NormalIntKit", "TestKit"]),
        //=--------------------------------------=
        // Test Kit
        //=--------------------------------------=
        .target(
        name: "TestKit",
        dependencies: ["CoreKit"]),
    ]
)
