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
// MARK: * Triple Int Layout x Division
//*============================================================================*

extension TripleIntLayoutTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivision3212MSB() {
        func whereTheBaseIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias X = DoubleIntLayout<T>
            typealias Y = TripleIntLayout<T>
            
            Test().division3212MSB(Y(low:  0, mid:  0, high: ~0), X(low:  1, high: ~0), ~0 as T, X(low:  1, high: ~1))
            Test().division3212MSB(Y(low:  0, mid:  0, high: ~0), X(low: ~1, high: ~0), ~0 as T, X(low: ~1, high:  1))
            Test().division3212MSB(Y(low: ~0, mid: ~0, high: ~1), X(low:  0, high: ~0), ~0 as T, X(low: ~0, high: ~1))
            Test().division3212MSB(Y(low: ~0, mid: ~0, high: ~1), X(low: ~0, high: ~0), ~0 as T, X(low: ~1, high:  0))
            
            Test().division3212MSB(Y(low:  0, mid:  0, high: T.msb - 1), X(low: ~0, high: T.msb), ~3 as T, X(low: ~3, high: 4)) // 2
            Test().division3212MSB(Y(low: ~0, mid:  0, high: T.msb - 1), X(low: ~0, high: T.msb), ~3 as T, X(low: ~4, high: 5)) // 2
            Test().division3212MSB(Y(low:  0, mid: ~0, high: T.msb - 1), X(low: ~0, high: T.msb), ~1 as T, X(low: ~1, high: 1)) // 1
            Test().division3212MSB(Y(low: ~0, mid: ~0, high: T.msb - 1), X(low: ~0, high: T.msb), ~1 as T, X(low: ~2, high: 2)) // 1
        }
        
        for base in Self.basesWhereIsUnsigned {
            whereTheBaseIs(base)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func division3212MSB<Base>(
        _ dividend:  TripleIntLayout<Base>,
        _ divisor:   DoubleIntLayout<Base>,
        _ quotient:  Base,
        _ remainder: DoubleIntLayout<Base>
    )   where Base:  SystemsInteger & UnsignedInteger {
        //=--------------------------------------=
        let result = dividend.division3212MSB(divisor)
        let expectation = Division(quotient: quotient, remainder: remainder)
        //=--------------------------------------=
        same(result, expectation)
        //=--------------------------------------=
        inverse: do {
            let inverse = divisor.multiplication(result.quotient).plus(result.remainder)
            same(Fallible(dividend), inverse, "dividend != divisor * quotient + remainder")
        }
    }
}
