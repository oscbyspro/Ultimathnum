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
            for direction: Test.ShiftDirection in [.up, .down] {
                //=------------------------------=
                Test().shift( 1 as T,  T .min,  T(Bit(!T.isSigned)),                                  direction, .smart)
                Test().shift(~0 as T,  T .min,  T(repeating: Bit(!T.isSigned || direction == .up  )), direction, .smart)
                Test().shift( 1 as T,  T .max,  T(0000000000000000000000000000000000000000000000000), direction, .smart)
                Test().shift(~0 as T,  T .max,  T(repeating: Bit( T.isSigned && direction == .down)), direction, .smart)
                //=------------------------------=
                Test().shift( 1 as T, ~T .msb,  T(0000000000000000000000000000000000000000000000000), direction, .smart)
                Test().shift(~0 as T, ~T .msb,  T(repeating: Bit( T.isSigned && direction == .down)), direction, .smart)
                Test().shift( 1 as T,  T .msb,  T(0000000000000000000000000000000000000000000000000), direction, .smart)
                Test().shift(~0 as T,  T .msb,  T(repeating: Bit( T.isSigned && direction == .up  )), direction, .smart)
            }
            
            for semantics: Test.ShiftSemantics in [.smart, .exact] {
                //=------------------------------=
                Test().shift( 1 as T,  0 as T,  1 as T,   .up, semantics)
                Test().shift( 1 as T,  1 as T,  2 as T,   .up, semantics)
                Test().shift( 1 as T,  2 as T,  4 as T,   .up, semantics)
                Test().shift( 1 as T,  3 as T,  8 as T,   .up, semantics)
                //=------------------------------=
                Test().shift(~0 as T,  0 as T, ~0 as T,   .up, semantics)
                Test().shift(~0 as T,  1 as T, ~1 as T,   .up, semantics)
                Test().shift(~0 as T,  2 as T, ~3 as T,   .up, semantics)
                Test().shift(~0 as T,  3 as T, ~7 as T,   .up, semantics)
            }
            
            for semantics: Test.ShiftSemantics in [.smart, .exact] {
                //=------------------------------=
                Test().shift( 8 as T,  0 as T,  8 as T, .down, semantics)
                Test().shift( 8 as T,  1 as T,  4 as T, .down, semantics)
                Test().shift( 8 as T,  2 as T,  2 as T, .down, semantics)
                Test().shift( 8 as T,  3 as T,  1 as T, .down, semantics)
                //=------------------------------=
                Test().shift(~0 as T,  0 as T, ~(~0 << T(raw: T.size - (T.isSigned ? 0 : 0))), .down, semantics)
                Test().shift(~0 as T,  1 as T, ~(~0 << T(raw: T.size - (T.isSigned ? 0 : 1))), .down, semantics)
                Test().shift(~0 as T,  2 as T, ~(~0 << T(raw: T.size - (T.isSigned ? 0 : 2))), .down, semantics)
                Test().shift(~0 as T,  3 as T, ~(~0 << T(raw: T.size - (T.isSigned ? 0 : 3))), .down, semantics)
            }
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
