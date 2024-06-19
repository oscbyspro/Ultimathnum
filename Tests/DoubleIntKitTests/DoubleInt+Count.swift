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
            IntegerInvariants(T.self).bitCountForEachBitSelection()
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
            let half = M(low: B.size, high: 0)
            let none = M.zero
            //=----------------------------------=
            Test()     .count(T(low:  00, high: 00), 0 as Bit, full)
            Test()     .count(T(low: ~00, high: 00), 0 as Bit, half)
            Test()     .count(T(low:  00, high: 11), 0 as Bit, full - 3 as M)
            Test()     .count(T(low: ~00, high: 11), 0 as Bit, half - 3 as M)
            Test()     .count(T(low:  11, high: 00), 0 as Bit, full - 3 as M)
            Test()     .count(T(low: ~11, high: 00), 0 as Bit, half + 3 as M)
            Test()     .count(T(low:  11, high: 11), 0 as Bit, full - 6 as M)
            Test()     .count(T(low: ~11, high: 11), 0 as Bit, half)
            
            Test()     .count(T(low:  00, high: 00), 1 as Bit, none)
            Test()     .count(T(low: ~00, high: 00), 1 as Bit, half)
            Test()     .count(T(low:  00, high: 11), 1 as Bit, none + 3 as M)
            Test()     .count(T(low: ~00, high: 11), 1 as Bit, half + 3 as M)
            Test()     .count(T(low:  11, high: 00), 1 as Bit, none + 3 as M)
            Test()     .count(T(low: ~11, high: 00), 1 as Bit, half - 3 as M)
            Test()     .count(T(low:  11, high: 11), 1 as Bit, none + 6 as M)
            Test()     .count(T(low: ~11, high: 11), 1 as Bit, half)
            
            Test() .ascending(T(low:  00, high: 00), 0 as Bit, full)
            Test() .ascending(T(low: ~00, high: 00), 0 as Bit, none)
            Test() .ascending(T(low:  00, high: 11), 0 as Bit, half)
            Test() .ascending(T(low: ~00, high: 11), 0 as Bit, none)
            Test() .ascending(T(low:  11, high: 00), 0 as Bit, none)
            Test() .ascending(T(low: ~11, high: 00), 0 as Bit, none + 2 as M)
            Test() .ascending(T(low:  11, high: 11), 0 as Bit, none)
            Test() .ascending(T(low: ~11, high: 11), 0 as Bit, none + 2 as M)
            
            Test() .ascending(T(low:  00, high: 00), 1 as Bit, none)
            Test() .ascending(T(low: ~00, high: 00), 1 as Bit, half)
            Test() .ascending(T(low:  00, high: 11), 1 as Bit, none)
            Test() .ascending(T(low: ~00, high: 11), 1 as Bit, half + 2 as M)
            Test() .ascending(T(low:  11, high: 00), 1 as Bit, none + 2 as M)
            Test() .ascending(T(low: ~11, high: 00), 1 as Bit, none)
            Test() .ascending(T(low:  11, high: 11), 1 as Bit, none + 2 as M)
            Test() .ascending(T(low: ~11, high: 11), 1 as Bit, none)
            
            Test().descending(T(low:  00, high: 00), 0 as Bit, full)
            Test().descending(T(low: ~00, high: 00), 0 as Bit, half)
            Test().descending(T(low:  00, high: 11), 0 as Bit, half - 4 as M)
            Test().descending(T(low: ~00, high: 11), 0 as Bit, half - 4 as M)
            Test().descending(T(low:  11, high: 00), 0 as Bit, full - 4 as M)
            Test().descending(T(low: ~11, high: 00), 0 as Bit, half)
            Test().descending(T(low:  11, high: 11), 0 as Bit, half - 4 as M)
            Test().descending(T(low: ~11, high: 11), 0 as Bit, half - 4 as M)
            
            Test().descending(T(low:  00, high: 00), 1 as Bit, none)
            Test().descending(T(low: ~00, high: 00), 1 as Bit, none)
            Test().descending(T(low:  00, high: 11), 1 as Bit, none)
            Test().descending(T(low: ~00, high: 11), 1 as Bit, none)
            Test().descending(T(low:  11, high: 00), 1 as Bit, none)
            Test().descending(T(low: ~11, high: 00), 1 as Bit, none)
            Test().descending(T(low:  11, high: 11), 1 as Bit, none)
            Test().descending(T(low: ~11, high: 11), 1 as Bit, none)
        }

        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
}
