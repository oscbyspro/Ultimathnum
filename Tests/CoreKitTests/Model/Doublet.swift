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
// MARK: * Doublet
//*============================================================================*

final class DoubletTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsSigned() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = Doublet<Base>
            
            Test().same(T.mode.isSigned, Base.isSigned)
        }
        
        for base in coreSystemsIntegers {
            whereTheBaseIs(base)
        }
    }
    
    func testBitWidth() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = Doublet<Base>
            
            Test().same(T.size, Base.size.multiplication(2))
        }
        
        for base in coreSystemsIntegers {
            whereTheBaseIs(base)
        }
    }
    
    func testMemoryLayout() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = Doublet<Base>
            
            Test().same(MemoryLayout<T>.self, MemoryLayout<(Base, Base)>.self)
            Test().same(MemoryLayout<T>.size, 2 * MemoryLayout<Base>.size)
            Test().same(MemoryLayout<T>.size, 2 * MemoryLayout<Base>.stride)
            Test().same(MemoryLayout<T>.size, 2 * MemoryLayout<Base>.alignment)
        }
        
        for base in coreSystemsIntegers {
            whereTheBaseIs(base)
        }
    }
}
