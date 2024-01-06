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
        name: "UMNCoreKit",
        targets: ["UMNCoreKit"]),
        //=--------------------------------------=
        // Double Int Kit
        //=--------------------------------------=
        .library(
        name: "UMNDoubleIntKit",
        targets: ["UMNDoubleIntKit"]),
        //=--------------------------------------=
        // Normal Int Kit
        //=--------------------------------------=
        .library(
        name: "UMNNormalIntKit",
        targets: ["UMNNormalIntKit"]),
        //=--------------------------------------=
        // Signed Int Kit
        //=--------------------------------------=
        .library(
        name: "UMNSignedIntKit",
        targets: ["UMNSignedIntKit"]),
    ],
    targets: [
        //=--------------------------------------=
        // Ultimathnum
        //=--------------------------------------=
        .target(
        name: "Ultimathnum",
        dependencies: ["UMNCoreKit", "UMNDoubleIntKit", "UMNNormalIntKit", "UMNSignedIntKit"]),
        //=--------------------------------------=
        // Core Kit
        //=--------------------------------------=
        .target(
        name: "UMNCoreKit",
        dependencies: []),
        
        .testTarget(
        name: "UMNCoreKitTests",
        dependencies: ["UMNCoreKit", "UMNTestKit"]),
        //=--------------------------------------=
        // Double Int Kit
        //=--------------------------------------=
        .target(
        name: "UMNDoubleIntKit",
        dependencies: ["UMNCoreKit"]),
        
        .testTarget(
        name: "UMNDoubleIntKitTests",
        dependencies: ["UMNDoubleIntKit", "UMNTestKit"]),
        //=--------------------------------------=
        // Normal Int Kit
        //=--------------------------------------=
        .target(
        name: "UMNNormalIntKit",
        dependencies: ["UMNCoreKit"]),
        
        .testTarget(
        name: "UMNNormalIntKitTests",
        dependencies: ["UMNNormalIntKit", "UMNTestKit"]),
        //=--------------------------------------=
        // Signed Int Kit
        //=--------------------------------------=
        .target(
        name: "UMNSignedIntKit",
        dependencies: ["UMNCoreKit"]),
        
        .testTarget(
        name: "UMNSignedIntKitTests",
        dependencies: ["UMNSignedIntKit", "UMNTestKit"]),
        //=--------------------------------------=
        // Test Kit
        //=--------------------------------------=
        .target(
        name: "UMNTestKit",
        dependencies: ["UMNCoreKit"]),
    ]
)
