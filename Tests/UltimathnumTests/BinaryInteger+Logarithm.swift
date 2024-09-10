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
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Logarithm
//*============================================================================*

final class BinaryIntegerTestsOnLogarithm: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBinaryLogarithmForSmallEntropies() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            let max = Count(raw: IX(raw: T.size) - 1)
            
            func check(_ value: T, _ expectation: Count?) {
                Test().same(value.ilog2(), expectation)
                Test().same(Nonzero(exactly: value)?.ilog2(), expectation)
            }
            
            check( 0 as T, nil)
            check( 1 as T, Count(0))
            check( 2 as T, Count(1))
            check( 3 as T, Count(1))
            check( 4 as T, Count(2))
            check( 5 as T, Count(2))
            check( 6 as T, Count(2))
            check( 7 as T, Count(2))
            check( 8 as T, Count(3))
            check( 9 as T, Count(3))
            
            check(~9 as T, T.isSigned ? nil : max)
            check(~8 as T, T.isSigned ? nil : max)
            check(~7 as T, T.isSigned ? nil : max)
            check(~6 as T, T.isSigned ? nil : max)
            check(~5 as T, T.isSigned ? nil : max)
            check(~4 as T, T.isSigned ? nil : max)
            check(~3 as T, T.isSigned ? nil : max)
            check(~2 as T, T.isSigned ? nil : max)
            check(~1 as T, T.isSigned ? nil : max)
            check(~0 as T, T.isSigned ? nil : max)
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
}
