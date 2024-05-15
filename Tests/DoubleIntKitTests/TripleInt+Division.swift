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
// MARK: * Triple Int x Division
//*============================================================================*

extension TripleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivision3212MSB() {
        func whereTheBaseIs<B>(_ type: B.Type) where B: SystemsInteger & UnsignedInteger {
            typealias X = DoubleInt<B>
            typealias Y = TripleInt<B>
            typealias D = Division<B, DoubleInt<B>>
            
            Test().division3212MSB(Y(low:  0, mid:  0, high: ~0), X(low:  1, high: ~0), D(quotient: ~0 as B, remainder: X(low:  1, high: ~1)))
            Test().division3212MSB(Y(low:  0, mid:  0, high: ~0), X(low: ~1, high: ~0), D(quotient: ~0 as B, remainder: X(low: ~1, high:  1)))
            Test().division3212MSB(Y(low: ~0, mid: ~0, high: ~1), X(low:  0, high: ~0), D(quotient: ~0 as B, remainder: X(low: ~0, high: ~1)))
            Test().division3212MSB(Y(low: ~0, mid: ~0, high: ~1), X(low: ~0, high: ~0), D(quotient: ~0 as B, remainder: X(low: ~1, high:  0)))
            
            Test().division3212MSB(Y(low:  0, mid:  0, high: B.msb - 1), X(low: ~0, high: B.msb), D(quotient: ~3 as B, remainder: X(low: ~3, high: 4))) // 2
            Test().division3212MSB(Y(low: ~0, mid:  0, high: B.msb - 1), X(low: ~0, high: B.msb), D(quotient: ~3 as B, remainder: X(low: ~4, high: 5))) // 2
            Test().division3212MSB(Y(low:  0, mid: ~0, high: B.msb - 1), X(low: ~0, high: B.msb), D(quotient: ~1 as B, remainder: X(low: ~1, high: 1))) // 1
            Test().division3212MSB(Y(low: ~0, mid: ~0, high: B.msb - 1), X(low: ~0, high: B.msb), D(quotient: ~1 as B, remainder: X(low: ~2, high: 2))) // 1
        }
        
        for base in coreSystemsIntegersWhereIsUnsigned {
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
    
    func division3212MSB<B>(
        _ dividend: TripleInt<B>,
        _ divisor:  DoubleInt<B>,
        _ expectation: Division<B, DoubleInt<B>>?
    )   where B: SystemsInteger & UnsignedInteger {
        //=--------------------------------------=
        guard let expectation else {
            return same(divisor, 0,  "division by zero is undefined [0]")
        }
        
        guard let divisor = Divisor(exactly: divisor) else {
            return none(expectation, "division by zero is undefined [1]")
        }
        //=--------------------------------------=
        let result: Division<B, DoubleInt<B>> = dividend.division3212(normalized: divisor)
        //=--------------------------------------=
        recover: do {
            let remainder = TripleInt(low: result.remainder.low, mid: result.remainder.high, high: B.zero)
            let recovered = divisor.value.multiplication(result.quotient).plus(remainder)
            same(Fallible(dividend), recovered, "dividend != divisor * quotient + remainder")
        }
        //=--------------------------------------=
        same(result, expectation, "3 by 2 division")
    }
}
