//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Triplet
//*============================================================================*

final class TripletTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    static let bases: [any SystemsInteger.Type] = {
        basesIsSigned +
        basesIsUnsigned
    }()
    
    static let basesIsSigned: [any (SystemsInteger & SignedInteger).Type] = [
        IX.self, I8.self, I16.self, I32.self, I64.self,
    ]
    
    static let basesIsUnsigned: [any (SystemsInteger & UnsignedInteger).Type] = [
        UX.self, U8.self, U16.self, U32.self, U64.self,
    ]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsSigned() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = Triplet<Base>
            
            Test().same(T.isSigned, Base.isSigned)
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
    
    func testBitWidth() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = Triplet<Base>
            
            Test().same(T.bitWidth.low,  Base.bitWidth.multiplication(3).low)
            Test().same(T.bitWidth.mid,  Base.bitWidth.multiplication(3).high)
            Test().same(T.bitWidth.high, Base.Magnitude())
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
    
    func testMemoryLayout() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = Triplet<Base>
            
            Test().same(MemoryLayout<T>.self, MemoryLayout<(Base, Base, Base)>.self)
            Test().same(MemoryLayout<T>.size, 3 * MemoryLayout<Base>.size)
            Test().same(MemoryLayout<T>.size, 3 * MemoryLayout<Base>.stride)
            Test().same(MemoryLayout<T>.size, 3 * MemoryLayout<Base>.alignment)
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
}
