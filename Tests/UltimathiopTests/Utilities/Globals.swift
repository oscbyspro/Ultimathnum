//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreIop
import CoreKit
import DoubleIntIop
import DoubleIntKit
import InfiniIntIop
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Globals
//*============================================================================*
// Imagine an array of chosen types and a bunch of type filters...
//=----------------------------------------------------------------------------=

let typesAsFiniteIntegerInteroperable: [any FiniteIntegerInteroperable.Type] = {
    typesAsCompactIntegerInteroperable +
    typesAsLenientIntegerInteroperable +
    typesAsNaturalIntegerInteroperable
}()

let typesAsSignedIntegerInteroperable: [any SignedIntegerInteroperable.Type] = {
    typesAsCompactIntegerInteroperable +
    typesAsLenientIntegerInteroperable
}()

let typesAsSystemsIntegerInteroperable: [any SystemsIntegerInteroperable.Type] = {
    typesAsCompactIntegerInteroperable +
    typesAsNaturalIntegerInteroperable
}()

let typesAsLenientIntegerInteroperable: [any LenientIntegerInteroperable.Type] = [
    InfiniInt<I8>.self,
    InfiniInt<IX>.self,
]

let typesAsCompactIntegerInteroperable: [any CompactIntegerInteroperable.Type] = reduce([]) {
    $0.append(IX .self)
    $0.append(I8 .self)
    $0.append(I16.self)
    $0.append(I32.self)
    $0.append(I64.self)
    
    #if false
    if  #available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *) {
        $0.append(CoreKit.I128.self)
    }
    #endif
    
    $0.append(DoubleInt<I8>.self)
    $0.append(DoubleInt<IX>.self)
    $0.append(DoubleInt<DoubleInt<I8>>.self)
    $0.append(DoubleInt<DoubleInt<IX>>.self)
}

let typesAsNaturalIntegerInteroperable: [any NaturalIntegerInteroperable.Type] = reduce([]) {
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
    
    $0.append(DoubleInt<U8>.self)
    $0.append(DoubleInt<UX>.self)
    $0.append(DoubleInt<DoubleInt<U8>>.self)
    $0.append(DoubleInt<DoubleInt<UX>>.self)
}
