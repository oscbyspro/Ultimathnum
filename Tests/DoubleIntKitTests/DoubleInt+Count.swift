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
// MARK: * Double Int x Count
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBitSelection() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            //=----------------------------------=
            let full = M.size
            let half = M(low: Base.size)
            let none = M.zero
            //=----------------------------------=
            Test().count(T(low:  00, high: 00),   .anywhere(0), full)
            Test().count(T(low: ~00, high: 00),   .anywhere(0), half)
            Test().count(T(low:  00, high: 11),   .anywhere(0), full - 3 as M)
            Test().count(T(low: ~00, high: 11),   .anywhere(0), half - 3 as M)
            Test().count(T(low:  11, high: 00),   .anywhere(0), full - 3 as M)
            Test().count(T(low: ~11, high: 00),   .anywhere(0), half + 3 as M)
            Test().count(T(low:  11, high: 11),   .anywhere(0), full - 6 as M)
            Test().count(T(low: ~11, high: 11),   .anywhere(0), half)
            
            Test().count(T(low:  00, high: 00),   .anywhere(1), none)
            Test().count(T(low: ~00, high: 00),   .anywhere(1), half)
            Test().count(T(low:  00, high: 11),   .anywhere(1), none + 3 as M)
            Test().count(T(low: ~00, high: 11),   .anywhere(1), half + 3 as M)
            Test().count(T(low:  11, high: 00),   .anywhere(1), none + 3 as M)
            Test().count(T(low: ~11, high: 00),   .anywhere(1), half - 3 as M)
            Test().count(T(low:  11, high: 11),   .anywhere(1), none + 6 as M)
            Test().count(T(low: ~11, high: 11),   .anywhere(1), half)
            
            Test().count(T(low:  00, high: 00),  .ascending(0), full)
            Test().count(T(low: ~00, high: 00),  .ascending(0), none)
            Test().count(T(low:  00, high: 11),  .ascending(0), half)
            Test().count(T(low: ~00, high: 11),  .ascending(0), none)
            Test().count(T(low:  11, high: 00),  .ascending(0), none)
            Test().count(T(low: ~11, high: 00),  .ascending(0), none + 2 as M)
            Test().count(T(low:  11, high: 11),  .ascending(0), none)
            Test().count(T(low: ~11, high: 11),  .ascending(0), none + 2 as M)
            
            Test().count(T(low:  00, high: 00),  .ascending(1), none)
            Test().count(T(low: ~00, high: 00),  .ascending(1), half)
            Test().count(T(low:  00, high: 11),  .ascending(1), none)
            Test().count(T(low: ~00, high: 11),  .ascending(1), half + 2 as M)
            Test().count(T(low:  11, high: 00),  .ascending(1), none + 2 as M)
            Test().count(T(low: ~11, high: 00),  .ascending(1), none)
            Test().count(T(low:  11, high: 11),  .ascending(1), none + 2 as M)
            Test().count(T(low: ~11, high: 11),  .ascending(1), none)
            
            Test().count(T(low:  00, high: 00), .descending(0), full)
            Test().count(T(low: ~00, high: 00), .descending(0), half)
            Test().count(T(low:  00, high: 11), .descending(0), half - 4 as M)
            Test().count(T(low: ~00, high: 11), .descending(0), half - 4 as M)
            Test().count(T(low:  11, high: 00), .descending(0), full - 4 as M)
            Test().count(T(low: ~11, high: 00), .descending(0), half)
            Test().count(T(low:  11, high: 11), .descending(0), half - 4 as M)
            Test().count(T(low: ~11, high: 11), .descending(0), half - 4 as M)
            
            Test().count(T(low:  00, high: 00), .descending(1), none)
            Test().count(T(low: ~00, high: 00), .descending(1), none)
            Test().count(T(low:  00, high: 11), .descending(1), none)
            Test().count(T(low: ~00, high: 11), .descending(1), none)
            Test().count(T(low:  11, high: 00), .descending(1), none)
            Test().count(T(low: ~11, high: 00), .descending(1), none)
            Test().count(T(low:  11, high: 11), .descending(1), none)
            Test().count(T(low: ~11, high: 11), .descending(1), none)
        }

        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
}
