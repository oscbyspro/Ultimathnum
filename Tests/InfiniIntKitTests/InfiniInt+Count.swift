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
// MARK: * Infinite Int x Count
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testCount() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            IntegerInvariants(T.self).count()
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testBitSelection() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias E = B.Element
            typealias L = B.Element.Magnitude
            typealias T = InfiniInt<E>
            typealias M = T.Magnitude
            
            Test().count(T(0x00000000000000000000000000000000),            (0), ~000 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100),            (0), ~032 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978),            (0), ~064 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0),            (0), ~096 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),            (0), ~128 as M)
            
            Test().count(T(0x00000000000000000000000000000000),            (1), 0000 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100),            (1), 0032 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978),            (1), 0064 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0),            (1), 0096 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),            (1), 0128 as M)
            
            Test().count(T(0x00000000000000000000000000000000),  .ascending(0), ~000 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100),  .ascending(0), 0008 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978),  .ascending(0), 0003 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0),  .ascending(0), 0004 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),  .ascending(0), 0000 as M)
            
            Test().count(T(0x00000000000000000000000000000000),  .ascending(1), 0000 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100),  .ascending(1), 0000 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978),  .ascending(1), 0000 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0),  .ascending(1), 0000 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),  .ascending(1), 0128 as M)
            
            Test().count(T(0x00000000000000000000000000000000), .descending(0),  ~00 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100), .descending(0), ~124 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978), .descending(0), ~128 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), .descending(0), ~128 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), .descending(0), ~128 as M)
            
            Test().count(T(0x00000000000000000000000000000000), .descending(1), 0000 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100), .descending(1), 0000 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978), .descending(1), 0000 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), .descending(1), 0000 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), .descending(1), 0000 as M)
        }
        
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
}
