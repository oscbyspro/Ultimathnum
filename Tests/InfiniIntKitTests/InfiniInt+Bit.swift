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
// MARK: * Infinit Int x Addition
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBitCountSelection() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias E = Base.Element
            typealias L = Base.Element.Magnitude
            typealias T = InfiniInt<E>
            typealias M = InfiniInt<E>.Magnitude
            
            Test().count(T(0x00000000000000000000000000000000), 0 as Bit, .anywhere,   ~000 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100), 0 as Bit, .anywhere,   ~032 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978), 0 as Bit, .anywhere,   ~064 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 0 as Bit, .anywhere,   ~096 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0 as Bit, .anywhere,   ~128 as M)
            
            Test().count(T(0x00000000000000000000000000000000), 1 as Bit, .anywhere,   0000 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100), 1 as Bit, .anywhere,   0032 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978), 1 as Bit, .anywhere,   0064 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 1 as Bit, .anywhere,   0096 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 1 as Bit, .anywhere,   0128 as M)
            
            Test().count(T(0x00000000000000000000000000000000), 0 as Bit, .ascending,  ~000 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100), 0 as Bit, .ascending,  0008 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978), 0 as Bit, .ascending,  0003 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 0 as Bit, .ascending,  0004 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0 as Bit, .ascending,  0000 as M)
            
            Test().count(T(0x00000000000000000000000000000000), 1 as Bit, .ascending,  0000 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100), 1 as Bit, .ascending,  0000 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978), 1 as Bit, .ascending,  0000 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 1 as Bit, .ascending,  0000 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 1 as Bit, .ascending,  0128 as M)
            
            Test().count(T(0x00000000000000000000000000000000), 0 as Bit, .descending,  ~00 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100), 0 as Bit, .descending, ~124 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978), 0 as Bit, .descending, ~128 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 0 as Bit, .descending, ~128 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0 as Bit, .descending, ~128 as M)
            
            Test().count(T(0x00000000000000000000000000000000), 1 as Bit, .descending, 0000 as M)
            Test().count(T(0x0F0E0D0C0B0A09080706050403020100), 1 as Bit, .descending, 0000 as M)
            Test().count(T(0x87868584838281807F7E7D7C7B7A7978), 1 as Bit, .descending, 0000 as M)
            Test().count(T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0), 1 as Bit, .descending, 0000 as M)
            Test().count(T(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 1 as Bit, .descending, 0000 as M)
        }
        
        for element in elements {
            whereTheBaseTypeIs(element)
        }
    }
}
