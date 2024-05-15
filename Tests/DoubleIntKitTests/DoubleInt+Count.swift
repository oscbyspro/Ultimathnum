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
    
    func testCount() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            IntegerInvariants(T.self).count()
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testBitSelection() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias M = DoubleInt<B>.Magnitude
            //=----------------------------------=
            let full = M.size
            let half = M(low: B.size)
            let none = M.zero
            //=----------------------------------=
            Test().count(T(low:  00, high: 00),            (0), full)
            Test().count(T(low: ~00, high: 00),            (0), half)
            Test().count(T(low:  00, high: 11),            (0), full - 3 as M)
            Test().count(T(low: ~00, high: 11),            (0), half - 3 as M)
            Test().count(T(low:  11, high: 00),            (0), full - 3 as M)
            Test().count(T(low: ~11, high: 00),            (0), half + 3 as M)
            Test().count(T(low:  11, high: 11),            (0), full - 6 as M)
            Test().count(T(low: ~11, high: 11),            (0), half)
            
            Test().count(T(low:  00, high: 00),            (1), none)
            Test().count(T(low: ~00, high: 00),            (1), half)
            Test().count(T(low:  00, high: 11),            (1), none + 3 as M)
            Test().count(T(low: ~00, high: 11),            (1), half + 3 as M)
            Test().count(T(low:  11, high: 00),            (1), none + 3 as M)
            Test().count(T(low: ~11, high: 00),            (1), half - 3 as M)
            Test().count(T(low:  11, high: 11),            (1), none + 6 as M)
            Test().count(T(low: ~11, high: 11),            (1), half)
            
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
