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
// MARK: * Infini Int x Count
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testCount() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            IntegerInvariants(T.self).bitCountForEachBitSelection()
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testBitSelection() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = InfiniInt<B>
            typealias M = T.Magnitude
            
            Test()     .count(T(0x00000000000000000000000000000000), 0 as Bit, ~000 as M)
            Test()     .count(T(0x0F0E0D0C0B0A09080706050403020100), 0 as Bit, ~032 as M)
            Test()     .count(T(0x87868584838281807F7E7D7C7B7A7978), 0 as Bit, ~064 as M)
            Test()     .count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 0 as Bit, ~096 as M)
            Test()     .count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0 as Bit, ~128 as M)
            
            Test()     .count(T(0x00000000000000000000000000000000), 1 as Bit, 0000 as M)
            Test()     .count(T(0x0F0E0D0C0B0A09080706050403020100), 1 as Bit, 0032 as M)
            Test()     .count(T(0x87868584838281807F7E7D7C7B7A7978), 1 as Bit, 0064 as M)
            Test()     .count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 1 as Bit, 0096 as M)
            Test()     .count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 1 as Bit, 0128 as M)
            
            Test() .ascending(T(0x00000000000000000000000000000000), 0 as Bit, ~000 as M)
            Test() .ascending(T(0x0F0E0D0C0B0A09080706050403020100), 0 as Bit, 0008 as M)
            Test() .ascending(T(0x87868584838281807F7E7D7C7B7A7978), 0 as Bit, 0003 as M)
            Test() .ascending(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 0 as Bit, 0004 as M)
            Test() .ascending(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0 as Bit, 0000 as M)
            
            Test() .ascending(T(0x00000000000000000000000000000000), 1 as Bit, 0000 as M)
            Test() .ascending(T(0x0F0E0D0C0B0A09080706050403020100), 1 as Bit, 0000 as M)
            Test() .ascending(T(0x87868584838281807F7E7D7C7B7A7978), 1 as Bit, 0000 as M)
            Test() .ascending(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 1 as Bit, 0000 as M)
            Test() .ascending(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 1 as Bit, 0128 as M)
            
            Test().descending(T(0x00000000000000000000000000000000), 0 as Bit,  ~00 as M)
            Test().descending(T(0x0F0E0D0C0B0A09080706050403020100), 0 as Bit, ~124 as M)
            Test().descending(T(0x87868584838281807F7E7D7C7B7A7978), 0 as Bit, ~128 as M)
            Test().descending(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 0 as Bit, ~128 as M)
            Test().descending(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0 as Bit, ~128 as M)
            
            Test().descending(T(0x00000000000000000000000000000000), 1 as Bit, 0000 as M)
            Test().descending(T(0x0F0E0D0C0B0A09080706050403020100), 1 as Bit, 0000 as M)
            Test().descending(T(0x87868584838281807F7E7D7C7B7A7978), 1 as Bit, 0000 as M)
            Test().descending(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 1 as Bit, 0000 as M)
            Test().descending(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 1 as Bit, 0000 as M)
        }
        
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
}
