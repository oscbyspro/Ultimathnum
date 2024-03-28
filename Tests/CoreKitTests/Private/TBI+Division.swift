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
// MARK: * Tuple Binary Integer x Division
//*============================================================================*

extension TupleBinaryIntegerTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivision3212MSB() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger & UnsignedInteger {
            typealias X2 = DoubleIntLayout<Base>
            typealias X3 = TripleIntLayout<Base>
            
            Test.division3212MSB(X3(low:  0, mid:  0, high: ~0), X2(low:  1, high: ~0), ~0 as Base, X2(low:  1, high: ~1))
            Test.division3212MSB(X3(low:  0, mid:  0, high: ~0), X2(low: ~1, high: ~0), ~0 as Base, X2(low: ~1, high:  1))
            Test.division3212MSB(X3(low: ~0, mid: ~0, high: ~1), X2(low:  0, high: ~0), ~0 as Base, X2(low: ~0, high: ~1))
            Test.division3212MSB(X3(low: ~0, mid: ~0, high: ~1), X2(low: ~0, high: ~0), ~0 as Base, X2(low: ~1, high:  0))
            
            Test.division3212MSB(X3(low:  0, mid:  0, high: Base.msb - 1), X2(low: ~0, high: Base.msb), ~3 as Base, X2(low: ~3, high: 4)) // 2
            Test.division3212MSB(X3(low: ~0, mid:  0, high: Base.msb - 1), X2(low: ~0, high: Base.msb), ~3 as Base, X2(low: ~4, high: 5)) // 2
            Test.division3212MSB(X3(low:  0, mid: ~0, high: Base.msb - 1), X2(low: ~0, high: Base.msb), ~1 as Base, X2(low: ~1, high: 1)) // 1
            Test.division3212MSB(X3(low: ~0, mid: ~0, high: Base.msb - 1), X2(low: ~0, high: Base.msb), ~1 as Base, X2(low: ~2, high: 2)) // 1
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
    
    static func division3212MSB<Base: SystemsInteger & UnsignedInteger>(
    _ dividend: TripleIntLayout<Base>, _ divisor: DoubleIntLayout<Base>, _ quotient: Base, _ remainder: DoubleIntLayout<Base>,
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        let result = TBI.division3212MSB(dividing: dividend, by: divisor)
        //=------------------------------------------=
        XCTAssertEqual(result.quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(result.remainder, remainder, file: file, line: line)
        //=------------------------------------------=
        reversed: do {
            var backtracked = TBI.multiplying213(divisor, by: result.quotient)
            let overflow = TBI.increment32B(&backtracked, by: result.remainder)
            XCTAssert(dividend == backtracked, "dividend != divisor * quotient + remainder", file: file, line: line)
            XCTAssertFalse(overflow, file: file, line: line)
        }
    }
}
