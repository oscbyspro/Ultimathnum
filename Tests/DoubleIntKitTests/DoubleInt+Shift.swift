//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import TestKit

//*============================================================================*
// MARK: * Double Int x Shift
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testShift() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            let low = T.zero
            let mid = T(low: B.size)
            let top = T(raw: T.size)
            
            for semantics: Test.ShiftSemantics in [.smart, .masked] {
                Test().shift(T(low: 1, high:  2), low + 0 as T, T(low:  1, high:  2), .left,  semantics)
                Test().shift(T(low: 1, high:  2), low + 1 as T, T(low:  2, high:  4), .left,  semantics)
                Test().shift(T(low: 1, high:  2), low + 2 as T, T(low:  4, high:  8), .left,  semantics)
                Test().shift(T(low: 1, high:  2), low + 3 as T, T(low:  8, high: 16), .left,  semantics)
                
                Test().shift(T(low: 1, high:  2), mid + 0 as T, T(low:  0, high:  1), .left,  semantics)
                Test().shift(T(low: 1, high:  2), mid + 1 as T, T(low:  0, high:  2), .left,  semantics)
                Test().shift(T(low: 1, high:  2), mid + 2 as T, T(low:  0, high:  4), .left,  semantics)
                Test().shift(T(low: 1, high:  2), mid + 3 as T, T(low:  0, high:  8), .left,  semantics)
            }
            
            for semantics: Test.ShiftSemantics in [.smart, .masked] {
                Test().shift(T(low: 8, high: 16), low + 0 as T, T(low:  8, high: 16), .right, semantics)
                Test().shift(T(low: 8, high: 16), low + 1 as T, T(low:  4, high:  8), .right, semantics)
                Test().shift(T(low: 8, high: 16), low + 2 as T, T(low:  2, high:  4), .right, semantics)
                Test().shift(T(low: 8, high: 16), low + 3 as T, T(low:  1, high:  2), .right, semantics)
                
                Test().shift(T(low: 8, high: 16), mid + 0 as T, T(low: 16, high:  0), .right, semantics)
                Test().shift(T(low: 8, high: 16), mid + 1 as T, T(low:  8, high:  0), .right, semantics)
                Test().shift(T(low: 8, high: 16), mid + 2 as T, T(low:  4, high:  0), .right, semantics)
                Test().shift(T(low: 8, high: 16), mid + 3 as T, T(low:  2, high:  0), .right, semantics)
            }
            
            for semantics: Test.ShiftSemantics in [.smart, .masked] {
                if  T.isSigned {
                    Test().shift(T(low: 0, high: B.msb), mid - 1 as T, T(low:  0, high: ~0), .right, semantics)
                    Test().shift(T(low: 0, high: B.msb), top - 1 as T, T(low: ~0, high: ~0), .right, semantics)
                }   else {
                    Test().shift(T(low: 0, high: B.msb), mid - 1 as T, T(low:  0, high:  1), .right, semantics)
                    Test().shift(T(low: 0, high: B.msb), top - 1 as T, T(low:  1, high:  0), .right, semantics)
                }
            }
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    func testSmartShiftByMinSigned() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            //=----------------------------------=
            precondition(T.isSigned)
            //=----------------------------------=
            for value in [T.zero, ~T.zero, T.min, ~T.min, T.max, ~T.max] {
                Test().shift(value, T.min, T(repeating: value.appendix), .left, .smart)
            }
        }
        
        for base in Self.bases where base.isSigned {
            whereTheBaseTypeIs(base)
        }
    }
}
