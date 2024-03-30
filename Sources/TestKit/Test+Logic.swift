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
// MARK: * Test x Logic
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func not<T>(
        _ instance: T, 
        _ expectation: T,
        file: StaticString = #file,
        line: UInt = #line
    )   where T: BitOperable & Equatable {
        
        XCTAssertEqual(~instance, expectation, file: file, line: line)
        XCTAssertEqual(~expectation, instance, file: file, line: line)
    }
    
    public static func and<T>(
        _ lhs: T, 
        _ rhs: T,
        _ expectation: T,
        file: StaticString = #file,
        line: UInt = #line
    )   where T: BitOperable & Equatable {
        
        XCTAssertEqual(lhs & rhs, expectation, file: file, line: line)
        XCTAssertEqual(rhs & lhs, expectation, file: file, line: line)
        
        XCTAssertEqual({ var x = lhs; x &= rhs; return x }(), expectation, file: file, line: line)
        XCTAssertEqual({ var x = rhs; x &= lhs; return x }(), expectation, file: file, line: line)
    }
    
    public static func or<T>(
        _ lhs: T,
        _ rhs: T,
        _ expectation: T,
        file: StaticString = #file,
        line: UInt = #line
    )   where T: BitOperable & Equatable {
        
        XCTAssertEqual(lhs | rhs, expectation, file: file, line: line)
        XCTAssertEqual(rhs | lhs, expectation, file: file, line: line)
        
        XCTAssertEqual({ var x = lhs; x |= rhs; return x }(), expectation, file: file, line: line)
        XCTAssertEqual({ var x = rhs; x |= lhs; return x }(), expectation, file: file, line: line)
    }
    
    public static func xor<T>(
        _ lhs: T,
        _ rhs: T,
        _ expectation: T,
        file: StaticString = #file,
        line: UInt = #line
    )   where T: BitOperable & Equatable {
        
        XCTAssertEqual(lhs ^ rhs, expectation, file: file, line: line)
        XCTAssertEqual(rhs ^ lhs, expectation, file: file, line: line)
        
        XCTAssertEqual({ var x = lhs; x ^= rhs; return x }(), expectation, file: file, line: line)
        XCTAssertEqual({ var x = rhs; x ^= lhs; return x }(), expectation, file: file, line: line)
    }
}
