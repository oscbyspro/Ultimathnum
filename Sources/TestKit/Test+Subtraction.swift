//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import XCTest

//*============================================================================*
// MARK: * Test x Subtraction
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func subtraction<T: BinaryInteger>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        self.subtractionAsSomeBinaryInteger(lhs, rhs, value, overflow, file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func subtractionAsSomeBinaryInteger<T: BinaryInteger>(
    _ lhs: T, _ rhs: T, _ value: T, _ overflow: Bool, file: StaticString, line: UInt) {
        //=--------------------------------------=
        brr: do {
            XCTAssertEqual(lhs &- rhs, value, file: file, line: line)
        };  if !overflow {
            XCTAssertEqual(lhs  - rhs, value, file: file, line: line)
        }
        
        brr: do {
            XCTAssertEqual({ var x = lhs; x &-= rhs; return x }(), value, file: file, line: line)
        };  if !overflow {
            XCTAssertEqual({ var x = lhs; x  -= rhs; return x }(), value, file: file, line: line)
        }
        //=--------------------------------------=
        if !overflow {
            let abc: T = Overflow.ignore({ try Overflow.ignore({ try rhs.minus(lhs) }).negated() })
            let xyz: T = Overflow.ignore({ try lhs.minus(rhs) })
            XCTAssertEqual(abc, xyz, "binary integer subtraction must be reversible", file: file, line: line)
        }   else {
            let abc: T = Overflow.ignore({ try rhs.minus(lhs) })
            let xyz: T = Overflow.ignore({ try Overflow.ignore({ try lhs.minus(rhs) }).negated() })
            XCTAssertEqual(abc, xyz, "binary integer subtraction must be reversible", file: file, line: line)
        }
        //=--------------------------------------=
        if  let one = try? T(literally: 1), rhs == one {
            Test.decrementation(lhs, value, overflow, file: file, line: line)
        }
        //=--------------------------------------=
        XCTAssertEqual(Overflow.capture({ try lhs.minus(rhs) }).value,    value,    file: file, line: line)
        XCTAssertEqual(Overflow.capture({ try lhs.minus(rhs) }).overflow, overflow, file: file, line: line)
        //=--------------------------------------=
        // same as rhs negation when lhs is zero
        //=--------------------------------------=
        if  lhs == 0 {
            XCTAssertEqual(Overflow.capture({ try rhs.negated() }).value,    value,    file: file, line: line)
            XCTAssertEqual(Overflow.capture({ try rhs.negated() }).overflow, overflow, file: file, line: line)
        }
        
        if  lhs == 0, !overflow {
            XCTAssertEqual(-rhs, value, file: file, line: line)
            XCTAssertEqual(-value, rhs, file: file, line: line)
        }
        
        
        if  lhs == 0, !overflow {
            XCTAssertEqual(Overflow.capture({ try value.negated() }).value,    rhs, file: file, line: line)
            XCTAssertEqual(Overflow.capture({ try value.negated() }).overflow, overflow, file: file, line: line)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Stride
//=----------------------------------------------------------------------------=

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func decrementation<T: BinaryInteger>(_ instance: T, _ expectation: T, _ overflow: Bool = false, file: StaticString = #file, line: UInt = #line) {
        let result = Overflow.capture {
            try instance.decremented()
        }
        
        XCTAssertEqual(result.value, expectation, file: file, line: line)
        XCTAssertEqual(result.overflow, overflow, file: file, line: line)
    }
}
