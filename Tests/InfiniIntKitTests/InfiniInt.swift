//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Infini Int
//*============================================================================*

final class InfiniIntTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
        
    static let types: [any BinaryInteger.Type] = {
        typesWhereIsSigned +
        typesWhereIsUnsigned
    }()
            
    static let typesWhereIsSigned: [any SignedInteger.Type] = [
        InfiniInt<IX >.self,
        InfiniInt<I8 >.self,
        InfiniInt<I16>.self,
        InfiniInt<I32>.self,
        InfiniInt<I64>.self,
    ]
            
    static let typesWhereIsUnsigned: [any UnsignedInteger.Type] = [
        InfiniInt<UX >.self,
        InfiniInt<U8 >.self,
        InfiniInt<U16>.self,
        InfiniInt<U32>.self,
        InfiniInt<U64>.self,
    ]
    
    static let elements: [any (BinaryInteger & SystemsInteger).Type] = {
        elementsWhereIsSigned +
        elementsWhereIsUnsigned
    }()
            
    static let elementsWhereIsSigned: [any (SignedInteger & SystemsInteger).Type] = [
        IX .self,
        I8 .self,
        I16.self,
        I32.self,
        I64.self,
    ]
            
    static let elementsWhereIsUnsigned: [any (UnsignedInteger & SystemsInteger).Type] = [
        UX .self,
        U8 .self,
        U16.self,
        U32.self,
        U64.self,
    ]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInvariants() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            IntegerInvariants(T.self).mode(BinaryIntegerID())
            IntegerInvariants(T.self).size(BinaryIntegerID())
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
