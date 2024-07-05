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
            //=----------------------------------=
            let none = IX.zero
            let half = IX(size: B.self)
            let full = IX(size: T.self)
            //=----------------------------------=
            Test()     .count(T(low:  00, high: 00), 0 as Bit, Count(full))
            Test()     .count(T(low: ~00, high: 00), 0 as Bit, Count(half))
            Test()     .count(T(low:  00, high: 11), 0 as Bit, Count(full - 3))
            Test()     .count(T(low: ~00, high: 11), 0 as Bit, Count(half - 3))
            Test()     .count(T(low:  11, high: 00), 0 as Bit, Count(full - 3))
            Test()     .count(T(low: ~11, high: 00), 0 as Bit, Count(half + 3))
            Test()     .count(T(low:  11, high: 11), 0 as Bit, Count(full - 6))
            Test()     .count(T(low: ~11, high: 11), 0 as Bit, Count(half))
            
            Test()     .count(T(low:  00, high: 00), 1 as Bit, Count(none))
            Test()     .count(T(low: ~00, high: 00), 1 as Bit, Count(half))
            Test()     .count(T(low:  00, high: 11), 1 as Bit, Count(none + 3))
            Test()     .count(T(low: ~00, high: 11), 1 as Bit, Count(half + 3))
            Test()     .count(T(low:  11, high: 00), 1 as Bit, Count(none + 3))
            Test()     .count(T(low: ~11, high: 00), 1 as Bit, Count(half - 3))
            Test()     .count(T(low:  11, high: 11), 1 as Bit, Count(none + 6))
            Test()     .count(T(low: ~11, high: 11), 1 as Bit, Count(half))
            
            Test() .ascending(T(low:  00, high: 00), 0 as Bit, Count(full))
            Test() .ascending(T(low: ~00, high: 00), 0 as Bit, Count(none))
            Test() .ascending(T(low:  00, high: 11), 0 as Bit, Count(half))
            Test() .ascending(T(low: ~00, high: 11), 0 as Bit, Count(none))
            Test() .ascending(T(low:  11, high: 00), 0 as Bit, Count(none))
            Test() .ascending(T(low: ~11, high: 00), 0 as Bit, Count(none + 2))
            Test() .ascending(T(low:  11, high: 11), 0 as Bit, Count(none))
            Test() .ascending(T(low: ~11, high: 11), 0 as Bit, Count(none + 2))
            
            Test() .ascending(T(low:  00, high: 00), 1 as Bit, Count(none))
            Test() .ascending(T(low: ~00, high: 00), 1 as Bit, Count(half))
            Test() .ascending(T(low:  00, high: 11), 1 as Bit, Count(none))
            Test() .ascending(T(low: ~00, high: 11), 1 as Bit, Count(half + 2))
            Test() .ascending(T(low:  11, high: 00), 1 as Bit, Count(none + 2))
            Test() .ascending(T(low: ~11, high: 00), 1 as Bit, Count(none))
            Test() .ascending(T(low:  11, high: 11), 1 as Bit, Count(none + 2))
            Test() .ascending(T(low: ~11, high: 11), 1 as Bit, Count(none))
            
            Test().descending(T(low:  00, high: 00), 0 as Bit, Count(full))
            Test().descending(T(low: ~00, high: 00), 0 as Bit, Count(half))
            Test().descending(T(low:  00, high: 11), 0 as Bit, Count(half - 4))
            Test().descending(T(low: ~00, high: 11), 0 as Bit, Count(half - 4))
            Test().descending(T(low:  11, high: 00), 0 as Bit, Count(full - 4))
            Test().descending(T(low: ~11, high: 00), 0 as Bit, Count(half))
            Test().descending(T(low:  11, high: 11), 0 as Bit, Count(half - 4))
            Test().descending(T(low: ~11, high: 11), 0 as Bit, Count(half - 4))
            
            Test().descending(T(low:  00, high: 00), 1 as Bit, Count(none))
            Test().descending(T(low: ~00, high: 00), 1 as Bit, Count(none))
            Test().descending(T(low:  00, high: 11), 1 as Bit, Count(none))
            Test().descending(T(low: ~00, high: 11), 1 as Bit, Count(none))
            Test().descending(T(low:  11, high: 00), 1 as Bit, Count(none))
            Test().descending(T(low: ~11, high: 00), 1 as Bit, Count(none))
            Test().descending(T(low:  11, high: 11), 1 as Bit, Count(none))
            Test().descending(T(low: ~11, high: 11), 1 as Bit, Count(none))
        }

        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
}
