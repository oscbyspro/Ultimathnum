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
// MARK: * Tuple Binary Integer x Addition
//*============================================================================*

extension TupleBinaryIntegerTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddition32B() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger & UnsignedInteger {
            typealias X2 = DoubleIntLayout<Base>
            typealias X3 = TripleIntLayout<Base>
            
            Test.addition32B(X3(low:  0, mid:  0, high:  0), X2(low: ~4, high: ~5), X3(low: ~4, mid: ~5, high:  0))
            Test.addition32B(X3(low:  1, mid:  2, high:  3), X2(low: ~4, high: ~5), X3(low: ~3, mid: ~3, high:  3))
            Test.addition32B(X3(low: ~1, mid: ~2, high: ~3), X2(low:  4, high:  5), X3(low:  2, mid:  3, high: ~2))
            Test.addition32B(X3(low: ~0, mid: ~0, high: ~0), X2(low:  4, high:  5), X3(low:  3, mid:  5, high:  0), true)
        }
        
        for base in Self.basesWhereIsUnsigned {
            whereTheBaseIs(base)
        }
    }
    
    func testAddition33B() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger & UnsignedInteger {
            typealias X2 = DoubleIntLayout<Base>
            typealias X3 = TripleIntLayout<Base>
            
            Test.addition33B(X3(low:  0, mid:  0, high:  0), X3(low: ~4, mid: ~5, high: ~6), X3(low: ~4, mid: ~5, high: ~6))
            Test.addition33B(X3(low:  1, mid:  2, high:  3), X3(low: ~4, mid: ~5, high: ~6), X3(low: ~3, mid: ~3, high: ~3))
            Test.addition33B(X3(low: ~1, mid: ~2, high: ~3), X3(low:  4, mid:  5, high:  6), X3(low:  2, mid:  3, high:  3), true)
            Test.addition33B(X3(low: ~0, mid: ~0, high: ~0), X3(low:  4, mid:  5, high:  6), X3(low:  3, mid:  5, high:  6), true)
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
    
    static func addition32B<Base: SystemsInteger & UnsignedInteger>(
    _ lhs: TripleIntLayout<Base>, _ rhs: DoubleIntLayout<Base>, _ expectation: TripleIntLayout<Base>, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        var x = lhs
        let o = TBI.increment32B(&x, by: rhs)
        //=--------------------------------------=
        XCTAssertEqual(x, expectation, file: file, line: line)
        XCTAssertEqual(o, overflow,    file: file, line: line)
    }

    static func addition33B<Base: SystemsInteger & UnsignedInteger>(
    _ lhs: TripleIntLayout<Base>, _ rhs: TripleIntLayout<Base>, _ expectation: TripleIntLayout<Base>, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        var x = lhs
        let o = TBI.increment33B(&x, by: rhs)
        //=--------------------------------------=
        XCTAssertEqual(x, expectation, file: file, line: line)
        XCTAssertEqual(o, overflow,    file: file, line: line)
    }
}
