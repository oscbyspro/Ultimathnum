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

let binaryIntegers: [any BinaryInteger.Type] = {
    binaryIntegersWhereIsSigned +
    binaryIntegerssWhereIsUnsigned
}()
        
let binaryIntegersWhereIsSigned: [any SignedInteger.Type] = {
    systemsIntegersWhereIsSigned +
    arbitraryIntegersWhereIsSigned
}()
        
let binaryIntegerssWhereIsUnsigned: [any UnsignedInteger.Type] = {
    systemsIntegersWhereIsUnsigned +
    arbitraryIntegersWhereIsUnsigned
}()

let arbitraryIntegers: [any BinaryInteger.Type] = {
    arbitraryIntegersWhereIsSigned +
    arbitraryIntegersWhereIsUnsigned
}()

let arbitraryIntegersWhereIsSigned: [any SignedInteger.Type] = [
    InfiniInt<I8>.self,
    InfiniInt<IX>.self,
]

let arbitraryIntegersWhereIsUnsigned: [any UnsignedInteger.Type] = [
    InfiniInt<U8>.self,
    InfiniInt<UX>.self,
]

let systemsIntegers: [any SystemsInteger.Type] = {
    systemsIntegersWhereIsSigned +
    systemsIntegersWhereIsUnsigned
}()

let systemsIntegersWhereIsSigned: [any (SystemsInteger & SignedInteger).Type] = [
    IX.self,  I8 .self, I16.self, I32.self, I64 .self,
    DoubleInt<I8>.self, DoubleInt<DoubleInt<I8>>.self,
    DoubleInt<IX>.self, DoubleInt<DoubleInt<IX>>.self,
]

let systemsIntegersWhereIsUnsigned: [any (SystemsInteger & UnsignedInteger).Type] = [
    UX.self,  U8 .self, U16.self, U32.self, U64 .self,
    DoubleInt<U8>.self, DoubleInt<DoubleInt<U8>>.self,
    DoubleInt<UX>.self, DoubleInt<DoubleInt<UX>>.self,
]
