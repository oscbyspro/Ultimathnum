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
import TestKit2

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

let typesAsSystemsIntegerAsSigned: [any SystemsIntegerAsSigned.Type] = [
    IX.self,  I8 .self, I16.self, I32.self, I64 .self,
    DoubleInt<I8>.self, DoubleInt<DoubleInt<I8>>.self,
    DoubleInt<IX>.self, DoubleInt<DoubleInt<IX>>.self,
]

let typesAsSystemsIntegerAsUnsigned: [any SystemsIntegerAsUnsigned.Type] = [
    UX.self,  U8 .self, U16.self, U32.self, U64 .self,
    DoubleInt<U8>.self, DoubleInt<DoubleInt<U8>>.self,
    DoubleInt<UX>.self, DoubleInt<DoubleInt<UX>>.self,
]
