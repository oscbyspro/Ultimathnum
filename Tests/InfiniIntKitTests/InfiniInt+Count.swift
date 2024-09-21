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
    
    func testBitSelection() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            Test()     .count(T(0x00000000000000000000000000000000), Bit.zero, Count(raw: ~000 as IX))
            Test()     .count(T(0x0F0E0D0C0B0A09080706050403020100), Bit.zero, Count(raw: ~032 as IX))
            Test()     .count(T(0x87868584838281807F7E7D7C7B7A7978), Bit.zero, Count(raw: ~064 as IX))
            Test()     .count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), Bit.zero, Count(raw: ~096 as IX))
            Test()     .count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), Bit.zero, Count(raw: ~128 as IX))
            
            Test()     .count(T(0x00000000000000000000000000000000), Bit.one,  Count(raw: 0000 as IX))
            Test()     .count(T(0x0F0E0D0C0B0A09080706050403020100), Bit.one,  Count(raw: 0032 as IX))
            Test()     .count(T(0x87868584838281807F7E7D7C7B7A7978), Bit.one,  Count(raw: 0064 as IX))
            Test()     .count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), Bit.one,  Count(raw: 0096 as IX))
            Test()     .count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), Bit.one,  Count(raw: 0128 as IX))
            
            Test() .ascending(T(0x00000000000000000000000000000000), Bit.zero, Count(raw: ~000 as IX))
            Test() .ascending(T(0x0F0E0D0C0B0A09080706050403020100), Bit.zero, Count(raw: 0008 as IX))
            Test() .ascending(T(0x87868584838281807F7E7D7C7B7A7978), Bit.zero, Count(raw: 0003 as IX))
            Test() .ascending(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), Bit.zero, Count(raw: 0004 as IX))
            Test() .ascending(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), Bit.zero, Count(raw: 0000 as IX))
            
            Test() .ascending(T(0x00000000000000000000000000000000), Bit.one,  Count(raw: 0000 as IX))
            Test() .ascending(T(0x0F0E0D0C0B0A09080706050403020100), Bit.one,  Count(raw: 0000 as IX))
            Test() .ascending(T(0x87868584838281807F7E7D7C7B7A7978), Bit.one,  Count(raw: 0000 as IX))
            Test() .ascending(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), Bit.one,  Count(raw: 0000 as IX))
            Test() .ascending(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), Bit.one,  Count(raw: 0128 as IX))
            
            Test().descending(T(0x00000000000000000000000000000000), Bit.zero, Count(raw:  ~00 as IX))
            Test().descending(T(0x0F0E0D0C0B0A09080706050403020100), Bit.zero, Count(raw: ~124 as IX))
            Test().descending(T(0x87868584838281807F7E7D7C7B7A7978), Bit.zero, Count(raw: ~128 as IX))
            Test().descending(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), Bit.zero, Count(raw: ~128 as IX))
            Test().descending(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), Bit.zero, Count(raw: ~128 as IX))
            
            Test().descending(T(0x00000000000000000000000000000000), Bit.one,  Count(raw: 0000 as IX))
            Test().descending(T(0x0F0E0D0C0B0A09080706050403020100), Bit.one,  Count(raw: 0000 as IX))
            Test().descending(T(0x87868584838281807F7E7D7C7B7A7978), Bit.one,  Count(raw: 0000 as IX))
            Test().descending(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), Bit.one,  Count(raw: 0000 as IX))
            Test().descending(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), Bit.one,  Count(raw: 0000 as IX))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
