//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Global x Types
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Integers
//=----------------------------------------------------------------------------=

public let typesAsCoreInteger: [any CoreInteger.Type] = {
    typesAsCoreIntegerAsSigned +
    typesAsCoreIntegerAsUnsigned
}()

public let typesAsCoreIntegerAsByte: [any CoreInteger.Type] = [
    I8.self,
    U8.self,
]

public let typesAsCoreIntegerAsSigned: [any CoreIntegerAsSigned.Type] = reduce([]) {
    $0.append(IX .self)
    $0.append(I8 .self)
    $0.append(I16.self)
    $0.append(I32.self)
    $0.append(I64.self)
    
    #if false
    if #available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *) {
        $0.append(CoreKit.I128.self)
    }
    #endif
}

public let typesAsCoreIntegerAsUnsigned: [any CoreIntegerAsUnsigned.Type] = reduce([]) {
    $0.append(UX .self)
    $0.append(U8 .self)
    $0.append(U16.self)
    $0.append(U32.self)
    $0.append(U64.self)
    
    #if false
    if #available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *) {
        $0.append(CoreKit.U128.self)
    }
    #endif
}

//=----------------------------------------------------------------------------=
// MARK: + Floats
//=----------------------------------------------------------------------------=

public let typesAsSwiftIEEE754: [any SwiftIEEE754.Type] = [
    Float32.self,
    Float64.self,
]

public let typesAsSwiftBinaryFloatingPoint: [any Swift.BinaryFloatingPoint.Type] = [
    Float32.self,
    Float64.self,
]
