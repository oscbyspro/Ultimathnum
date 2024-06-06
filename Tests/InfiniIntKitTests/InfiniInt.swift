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
    // MARK: Metadata
    //=------------------------------------------------------------------------=
        
    static let types: [any BinaryInteger.Type] = {
        typesWhereIsSigned +
        typesWhereIsUnsigned
    }()
            
    static let typesWhereIsSigned: [any SignedInteger.Type] = [
        InfiniInt<IX>.self,
        InfiniInt<I8>.self,
    ]
            
    static let typesWhereIsUnsigned: [any UnsignedInteger.Type] = [
        InfiniInt<UX>.self,
        InfiniInt<U8>.self,
    ]
    
    static let elements: [any (BinaryInteger & SystemsInteger).Type] = {
        elementsWhereIsSigned +
        elementsWhereIsUnsigned
    }()
            
    static let elementsWhereIsSigned: [any (SignedInteger & SystemsInteger).Type] = [
        IX.self,
        I8.self,
    ]
            
    static let elementsWhereIsUnsigned: [any (UnsignedInteger & SystemsInteger).Type] = [
        UX.self,
        U8.self,
    ]
    
    /// A collection of all primes that fit in one byte.
    ///
    /// - Note: It contains `54` elements.
    ///
    static let primes54: [U8] = [
        0002, 0003, 0005, 0007, 0011, 0013, 0017, 0019,
        0023, 0029, 0031, 0037, 0041, 0043, 0047, 0053,
        0059, 0061, 0067, 0071, 0073, 0079, 0083, 0089,
        0097, 0101, 0103, 0107, 0109, 0113, 0127, 0131,
        0137, 0139, 0149, 0151, 0157, 0163, 0167, 0173,
        0179, 0181, 0191, 0193, 0197, 0199, 0211, 0223,
        0227, 0229, 0233, 0239, 0241, 0251
    ]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInvariants() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            IntegerInvariants(T.self).mode(BinaryIntegerID())
            IntegerInvariants(T.self).size(BinaryIntegerID())
            IntegerInvariants(T.self).protocols()
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
