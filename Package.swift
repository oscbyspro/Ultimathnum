// swift-tools-version: 5.9
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
        //=--------------------------------------=
        // Ultimathnum
        //=--------------------------------------=
        .library(
            name: "Ultimathnum",
            targets: ["Ultimathnum"]
        ),
        //=--------------------------------------=
        // CoreKit
        //=--------------------------------------=
        .library(
            name: "CoreKit",
            targets: ["CoreKit"]
        ),
        //=--------------------------------------=
        // DoubleIntKit
        //=--------------------------------------=
        .library(
            name: "DoubleIntKit",
            targets: ["DoubleIntKit"]
        ),
        //=--------------------------------------=
        // FibonacciKit
        //=--------------------------------------=
        .library(
            name: "FibonacciKit",
            targets: ["FibonacciKit"]
        ),
        //=--------------------------------------=
        // InfiniIntKit
        //=--------------------------------------=
        .library(
            name: "InfiniIntKit",
            targets: ["InfiniIntKit"]
        ),
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
                "FibonacciKit",
                "InfiniIntKit",
            ]
        ),
        
        .testTarget(
            name: "UltimathnumTests",
            dependencies: ["Ultimathnum", "TestKit"]
        ),
        //=--------------------------------------=
        // CoreKit
        //=--------------------------------------=
        .target(
            name: "CoreKit",
            dependencies: []
        ),
        
        .testTarget(
            name: "CoreKitTests",
            dependencies: [
                "CoreKit",
                "DoubleIntKit",
                "InfiniIntKit",
                "TestKit",
            ]
        ),
        //=--------------------------------------=
        // DoubleIntKit
        //=--------------------------------------=
        .target(
            name: "DoubleIntKit",
            dependencies: ["CoreKit"]
        ),
        
        .testTarget(
            name: "DoubleIntKitTests",
            dependencies: ["DoubleIntKit", "TestKit"]
        ),
        //=--------------------------------------=
        // FibonacciKit
        //=--------------------------------------=
        .target(
            name: "FibonacciKit",
            dependencies: ["CoreKit"]
        ),
        
        .testTarget(
            name: "FibonacciKitTests",
            dependencies: [
                "DoubleIntKit",
                "FibonacciKit",
                "InfiniIntKit",
                "TestKit"
            ]
        ),
        //=--------------------------------------=
        // InfiniIntKit
        //=--------------------------------------=
        .target(
            name: "InfiniIntKit",
            dependencies: ["CoreKit"]
        ),
        
        .testTarget(
            name: "InfiniIntKitTests",
            dependencies: ["InfiniIntKit", "TestKit"]
        ),
        //=--------------------------------------=
        // TestKit
        //=--------------------------------------=
        .target(
            name: "TestKit",
            dependencies: ["CoreKit"]
        ),
    ]
)
