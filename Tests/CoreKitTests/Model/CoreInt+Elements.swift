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
// MARK: * Core Int x Elements
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBody() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().commonInitBody(T.self, id: SystemsIntegerID())
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    func testMakeBody() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().elements(~1 as T, [~1 as T.Element.Magnitude])
            Test().elements(~0 as T, [~0 as T.Element.Magnitude])
            Test().elements( 0 as T, [ 0 as T.Element.Magnitude])
            Test().elements( 1 as T, [ 1 as T.Element.Magnitude])
            
            Test().elements(~1 as T, [U8(load: ~1 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test().elements(~0 as T, [U8(load: ~0 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test().elements( 0 as T, [U8(load:  0 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test().elements( 1 as T, [U8(load:  1 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            
            Test().elements(~1 as T, [UX(load: ~1 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test().elements(~0 as T, [UX(load: ~0 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test().elements( 0 as T, [UX(load:  0 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test().elements( 1 as T, [UX(load:  1 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
        }

        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
}
