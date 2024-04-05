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
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsSigned() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = Triplet<Base>
            
            Test().same(T.isSigned, Base.isSigned)
        }
        
        for base in coreSystemsIntegers {
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
        
        for base in coreSystemsIntegers {
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
        
        for base in coreSystemsIntegers {
            whereTheBaseIs(base)
        }
    }
}
