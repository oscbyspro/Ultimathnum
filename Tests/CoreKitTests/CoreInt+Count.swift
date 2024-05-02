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
// MARK: * Core Int x Count
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testCount() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            IntegerInvariants(T.self).entropy()
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    func testBitSelection() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            for bit: Bit in [0, 1] {
                for selection: any BitSelection<T> in [
                    Bit  .Anywhere<T>(bit),
                    Bit .Ascending<T>(bit),
                    Bit.Descending<T>(bit)
                ] {
                    Test().same(( 0 as T).count(selection), bit == 0 ? T.size : 0)
                    Test().same((~0 as T).count(selection), bit == 1 ? T.size : 0)
                }
                
                for element: (value: T, bit: Bit) in [(11, 0), (~11, 1)] {
                    Test().same(element.value.count(           (bit)), bit == element.bit ? T.size - 3 : 3)
                    Test().same(element.value.count( .ascending(bit)), bit == element.bit ? 0000000000 : 2)
                    Test().same(element.value.count(.descending(bit)), bit == element.bit ? T.size - 4 : 0)
                }
            }
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
}
