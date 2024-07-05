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
            
            Test()     .count(T(0x00000000000000000000000000000000), 0 as Bit, Count(raw: ~000 as IX))
            Test()     .count(T(0x0F0E0D0C0B0A09080706050403020100), 0 as Bit, Count(raw: ~032 as IX))
            Test()     .count(T(0x87868584838281807F7E7D7C7B7A7978), 0 as Bit, Count(raw: ~064 as IX))
            Test()     .count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 0 as Bit, Count(raw: ~096 as IX))
            Test()     .count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0 as Bit, Count(raw: ~128 as IX))
            
            Test()     .count(T(0x00000000000000000000000000000000), 1 as Bit, Count(raw: 0000 as IX))
            Test()     .count(T(0x0F0E0D0C0B0A09080706050403020100), 1 as Bit, Count(raw: 0032 as IX))
            Test()     .count(T(0x87868584838281807F7E7D7C7B7A7978), 1 as Bit, Count(raw: 0064 as IX))
            Test()     .count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 1 as Bit, Count(raw: 0096 as IX))
            Test()     .count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 1 as Bit, Count(raw: 0128 as IX))
            
            Test() .ascending(T(0x00000000000000000000000000000000), 0 as Bit, Count(raw: ~000 as IX))
            Test() .ascending(T(0x0F0E0D0C0B0A09080706050403020100), 0 as Bit, Count(raw: 0008 as IX))
            Test() .ascending(T(0x87868584838281807F7E7D7C7B7A7978), 0 as Bit, Count(raw: 0003 as IX))
            Test() .ascending(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 0 as Bit, Count(raw: 0004 as IX))
            Test() .ascending(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0 as Bit, Count(raw: 0000 as IX))
            
            Test() .ascending(T(0x00000000000000000000000000000000), 1 as Bit, Count(raw: 0000 as IX))
            Test() .ascending(T(0x0F0E0D0C0B0A09080706050403020100), 1 as Bit, Count(raw: 0000 as IX))
            Test() .ascending(T(0x87868584838281807F7E7D7C7B7A7978), 1 as Bit, Count(raw: 0000 as IX))
            Test() .ascending(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 1 as Bit, Count(raw: 0000 as IX))
            Test() .ascending(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 1 as Bit, Count(raw: 0128 as IX))
            
            Test().descending(T(0x00000000000000000000000000000000), 0 as Bit, Count(raw:  ~00 as IX))
            Test().descending(T(0x0F0E0D0C0B0A09080706050403020100), 0 as Bit, Count(raw: ~124 as IX))
            Test().descending(T(0x87868584838281807F7E7D7C7B7A7978), 0 as Bit, Count(raw: ~128 as IX))
            Test().descending(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 0 as Bit, Count(raw: ~128 as IX))
            Test().descending(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0 as Bit, Count(raw: ~128 as IX))
            
            Test().descending(T(0x00000000000000000000000000000000), 1 as Bit, Count(raw: 0000 as IX))
            Test().descending(T(0x0F0E0D0C0B0A09080706050403020100), 1 as Bit, Count(raw: 0000 as IX))
            Test().descending(T(0x87868584838281807F7E7D7C7B7A7978), 1 as Bit, Count(raw: 0000 as IX))
            Test().descending(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 1 as Bit, Count(raw: 0000 as IX))
            Test().descending(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 1 as Bit, Count(raw: 0000 as IX))
        }
        
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
}
