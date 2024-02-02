//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Tuple Binary Integer x Subtraction
//*============================================================================*

extension TupleBinaryIntegerTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtraction32B() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger & UnsignedInteger {
            typealias X2 = Doublet<Base>
            typealias X3 = Triplet<Base>
            
            Test.subtraction32B(X3(low:  0, mid:  0, high:  0), X2(low: ~4, high: ~5), X3(low:  5, mid:  5, high: ~0), true)
            Test.subtraction32B(X3(low:  1, mid:  2, high:  3), X2(low: ~4, high: ~5), X3(low:  6, mid:  7, high:  2))
            Test.subtraction32B(X3(low: ~1, mid: ~2, high: ~3), X2(low:  4, high:  5), X3(low: ~5, mid: ~7, high: ~3))
            Test.subtraction32B(X3(low: ~0, mid: ~0, high: ~0), X2(low:  4, high:  5), X3(low: ~4, mid: ~5, high: ~0))
        }
        
        for base in Self.basesWhereIsUnsigned {
            whereTheBaseIs(base)
        }
    }
    
    func testSubtraction33B() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger & UnsignedInteger {
            typealias X2 = Doublet<Base>
            typealias X3 = Triplet<Base>
            
            Test.subtraction33B(X3(low:  0, mid:  0, high:  0), X3(low: ~4, mid: ~5, high: ~6), X3(low:  5, mid:  5, high:  6), true)
            Test.subtraction33B(X3(low:  1, mid:  2, high:  3), X3(low: ~4, mid: ~5, high: ~6), X3(low:  6, mid:  7, high:  9), true)
            Test.subtraction33B(X3(low: ~1, mid: ~2, high: ~3), X3(low:  4, mid:  5, high:  6), X3(low: ~5, mid: ~7, high: ~9))
            Test.subtraction33B(X3(low: ~0, mid: ~0, high: ~0), X3(low:  4, mid:  5, high:  6), X3(low: ~4, mid: ~5, high: ~6))
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
    
    static func subtraction32B<Base: SystemsInteger & UnsignedInteger>(
    _ lhs: Triplet<Base>, _ rhs: Doublet<Base>, _ expectation: Triplet<Base>, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        var x = lhs
        let o = TBI.decrement32B(&x, by: rhs)
        //=--------------------------------------=
        XCTAssertEqual(x, expectation, file: file, line: line)
        XCTAssertEqual(o, overflow,    file: file, line: line)
    }

    static func subtraction33B<Base: SystemsInteger & UnsignedInteger>(
    _ lhs: Triplet<Base>, _ rhs: Triplet<Base>, _ expectation: Triplet<Base>, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        var x = lhs
        let o = TBI.decrement33B(&x, by: rhs)
        //=--------------------------------------=
        XCTAssertEqual(x, expectation, file: file, line: line)
        XCTAssertEqual(o, overflow,    file: file, line: line)
    }
}
