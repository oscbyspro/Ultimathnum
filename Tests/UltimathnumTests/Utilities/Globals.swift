//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Globals
//*============================================================================*
// Imagine an array of chosen types and a bunch of type filters...
//=----------------------------------------------------------------------------=

let typesAsArbitraryInteger: [any ArbitraryInteger.Type] = {
    typesAsArbitraryIntegerAsSigned +
    typesAsArbitraryIntegerAsUnsigned
}()

let typesAsBinaryIntegerAsAppendix: [any BinaryInteger.Type] = {
    typesAsBinaryIntegerAsSigned +
    typesAsArbitraryIntegerAsUnsigned
}()

let typesAsArbitraryIntegerAsByte: [any ArbitraryInteger.Type] = [
    InfiniInt<I8>.self,
    InfiniInt<U8>.self,
]

let typesAsArbitraryIntegerAsSigned: [any ArbitraryIntegerAsSigned.Type] = [
    InfiniInt<I8>.self,
    InfiniInt<IX>.self,
]

let typesAsArbitraryIntegerAsUnsigned: [any ArbitraryIntegerAsUnsigned.Type] = [
    InfiniInt<U8>.self,
    InfiniInt<UX>.self,
]

let typesAsAppendixInteger: [any BinaryInteger.Type] = {
    typesAsAppendixIntegerAsSigned +
    typesAsAppendixIntegerAsUnsigned
}()

let typesAsAppendixIntegerAsSigned: [any BinaryInteger.Type] = {
    typesAsBinaryIntegerAsSigned
}()

let typesAsAppendixIntegerAsUnsigned: [any BinaryInteger.Type] = {
    typesAsArbitraryIntegerAsUnsigned
}()

let typesAsBinaryInteger: [any BinaryInteger.Type] = {
    typesAsBinaryIntegerAsSigned +
    typesAsBinaryIntegerAsUnsigned
}()
        
let typesAsBinaryIntegerAsSigned: [any SignedInteger.Type] = {
    typesAsSystemsIntegerAsSigned +
    typesAsArbitraryIntegerAsSigned
}()
        
let typesAsBinaryIntegerAsUnsigned: [any UnsignedInteger.Type] = {
    typesAsSystemsIntegerAsUnsigned +
    typesAsArbitraryIntegerAsUnsigned
}()

let typesAsEdgyInteger: [any EdgyInteger.Type] = {
    typesAsEdgyIntegerAsSigned +
    typesAsEdgyIntegerAsUnsigned
}()

let typesAsEdgyIntegerAsSigned: [any EdgyIntegerAsSigned.Type] = {
    typesAsSystemsIntegerAsSigned
}()

let typesAsEdgyIntegerAsUnsigned: [any EdgyIntegerAsUnsigned.Type] = {
    typesAsBinaryIntegerAsUnsigned
}()

let typesAsFiniteInteger: [any FiniteInteger.Type] = {
    typesAsFiniteIntegerAsSigned +
    typesAsFiniteIntegerAsUnsigned
}()

let typesAsFiniteIntegerAsSigned: [any FiniteIntegerAsSigned.Type] = {
    typesAsBinaryIntegerAsSigned
}()

let typesAsFiniteIntegerAsUnsigned: [any FiniteIntegerAsUnsigned.Type] = {
    typesAsSystemsIntegerAsUnsigned
}()

let typesAsSystemsInteger: [any SystemsInteger.Type] = {
    typesAsSystemsIntegerAsSigned +
    typesAsSystemsIntegerAsUnsigned
}()

let typesAsSystemsIntegerAsSigned: [any SystemsIntegerAsSigned.Type] = reduce([]) {
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
    
    $0.append(DoubleInt<I8>.self)
    $0.append(DoubleInt<IX>.self)
    
    $0.append(DoubleInt<DoubleInt<I8>>.self)
    $0.append(DoubleInt<DoubleInt<IX>>.self)
}

let typesAsSystemsIntegerAsUnsigned: [any SystemsIntegerAsUnsigned.Type] = reduce([]) {
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
