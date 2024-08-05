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
            let max = Count<IX>(raw: IX(raw: T.size) - 1)
            
            Test().none(( 0 as T).ilog2())
            Test().same(( 1 as T).ilog2(), Count(0))
            Test().same(( 2 as T).ilog2(), Count(1))
            Test().same(( 3 as T).ilog2(), Count(1))
            Test().same(( 4 as T).ilog2(), Count(2))
            Test().same(( 5 as T).ilog2(), Count(2))
            Test().same(( 6 as T).ilog2(), Count(2))
            Test().same(( 7 as T).ilog2(), Count(2))
            Test().same(( 8 as T).ilog2(), Count(3))
            Test().same(( 9 as T).ilog2(), Count(3))
            
            Test().same((~9 as T).ilog2(), T.isSigned ? Count(3) : max)
            Test().same((~8 as T).ilog2(), T.isSigned ? Count(3) : max)
            Test().same((~7 as T).ilog2(), T.isSigned ? Count(3) : max)
            Test().same((~6 as T).ilog2(), T.isSigned ? Count(2) : max)
            Test().same((~5 as T).ilog2(), T.isSigned ? Count(2) : max)
            Test().same((~4 as T).ilog2(), T.isSigned ? Count(2) : max)
            Test().same((~3 as T).ilog2(), T.isSigned ? Count(2) : max)
            Test().same((~2 as T).ilog2(), T.isSigned ? Count(1) : max)
            Test().same((~1 as T).ilog2(), T.isSigned ? Count(1) : max)
            Test().same((~0 as T).ilog2(), T.isSigned ? Count(0) : max)
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
}
