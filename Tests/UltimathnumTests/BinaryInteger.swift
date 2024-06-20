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
// MARK: * Binary Integer
//*============================================================================*

final class BinaryIntegerTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let types: [any BinaryInteger.Type] = {
        typesWhereIsSigned +
        typesWhereIsUnsigned
    }()
            
    static let typesWhereIsSigned: [any SignedInteger.Type] = {
        systemsIntegersWhereIsSigned +
        arbitraryIntegersWhereIsSigned
    }()
            
    static let typesWhereIsUnsigned: [any UnsignedInteger.Type] = {
        systemsIntegersWhereIsUnsigned +
        arbitraryIntegersWhereIsUnsigned
    }()
    
    static let arbitraryIntegersWhereIsSigned: [any SignedInteger.Type] = [
        InfiniInt<I8>.self,
        InfiniInt<IX>.self,
    ]
            
    static let arbitraryIntegersWhereIsUnsigned: [any UnsignedInteger.Type] = [
        InfiniInt<U8>.self,
        InfiniInt<UX>.self,
    ]
    
    static var systemsIntegers: [any SystemsInteger.Type] = {
        systemsIntegersWhereIsSigned +
        systemsIntegersWhereIsUnsigned
    }()
    
    static var systemsIntegersWhereIsSigned: [any (SystemsInteger & SignedInteger).Type] = [
        IX.self,  I8 .self, I16.self, I32.self, I64 .self,
        DoubleInt<I8>.self, DoubleInt<DoubleInt<I8>>.self,
        DoubleInt<IX>.self, DoubleInt<DoubleInt<IX>>.self,
    ]
    
    static var systemsIntegersWhereIsUnsigned: [any (SystemsInteger & UnsignedInteger).Type] = [
        UX.self,  U8 .self, U16.self, U32.self, U64 .self,
        DoubleInt<U8>.self, DoubleInt<DoubleInt<U8>>.self,
        DoubleInt<UX>.self, DoubleInt<DoubleInt<UX>>.self,
    ]
}
