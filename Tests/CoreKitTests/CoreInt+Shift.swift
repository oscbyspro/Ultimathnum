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
// MARK: * Core Int x Shift
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testShift() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            //=----------------------------------=
            IntegerInvariants(T.self)  .upshiftRepeatingBit()
            IntegerInvariants(T.self).downshiftRepeatingBit()
            //=----------------------------------=
            for direction: Test.ShiftDirection in [.left, .right] {
                Test().shift( 1 as T,  T .max,  00000000000000000000000000000000000000000000000 as T, direction, .smart)
                Test().shift(~0 as T,  T .max,  T(repeating: Bit(T.isSigned && direction == .right)), direction, .smart)
            }
            
            for semantics: Test.ShiftSemantics in [.smart, .masked] {
                //=------------------------------=
                Test().shift( 1 as T,  0 as T,  1 as T, .left,  semantics)
                Test().shift( 1 as T,  1 as T,  2 as T, .left,  semantics)
                Test().shift( 1 as T,  2 as T,  4 as T, .left,  semantics)
                Test().shift( 1 as T,  3 as T,  8 as T, .left,  semantics)
                //=------------------------------=
                Test().shift(~0 as T,  0 as T, ~0 as T, .left,  semantics)
                Test().shift(~0 as T,  1 as T, ~1 as T, .left,  semantics)
                Test().shift(~0 as T,  2 as T, ~3 as T, .left,  semantics)
                Test().shift(~0 as T,  3 as T, ~7 as T, .left,  semantics)
            }
            
            for semantics: Test.ShiftSemantics in [.smart, .masked] {
                //=------------------------------=
                Test().shift( 8 as T,  0 as T,  8 as T, .right, semantics)
                Test().shift( 8 as T,  1 as T,  4 as T, .right, semantics)
                Test().shift( 8 as T,  2 as T,  2 as T, .right, semantics)
                Test().shift( 8 as T,  3 as T,  1 as T, .right, semantics)
                //=------------------------------=
                Test().shift(~0 as T,  0 as T, ~(~0 << T(raw: T.size - (T.isSigned ? 0 : 0))), .right, semantics)
                Test().shift(~0 as T,  1 as T, ~(~0 << T(raw: T.size - (T.isSigned ? 0 : 1))), .right, semantics)
                Test().shift(~0 as T,  2 as T, ~(~0 << T(raw: T.size - (T.isSigned ? 0 : 2))), .right, semantics)
                Test().shift(~0 as T,  3 as T, ~(~0 << T(raw: T.size - (T.isSigned ? 0 : 3))), .right, semantics)
            }
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
}
