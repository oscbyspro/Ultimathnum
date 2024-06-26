//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import StdlibIntKit
import TestKit

//*============================================================================*
// MARK: * Stdlib Int x Count
//*============================================================================*

extension StdlibIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
 
    func testUpshift() {
        self.upshift(-1 as T, Int( 1),  -2 as T)
        self.upshift(-1 as T, Int( 2),  -4 as T)
        self.upshift(-1 as T, Int( 3),  -8 as T)
        self.upshift(-1 as T, Int( 4), -16 as T)
        self.upshift( 0 as T, Int( 1),   0 as T)
        self.upshift( 0 as T, Int( 2),   0 as T)
        self.upshift( 0 as T, Int( 3),   0 as T)
        self.upshift( 0 as T, Int( 4),   0 as T)
        self.upshift( 1 as T, Int( 1),   2 as T)
        self.upshift( 1 as T, Int( 2),   4 as T)
        self.upshift( 1 as T, Int( 3),   8 as T)
        self.upshift( 1 as T, Int( 4),  16 as T)
    }
    
    func testUpshiftAnyByMinInt() {
        self.upshift( 2 as T, Int.min,  0 as T)
        self.upshift( 1 as T, Int.min,  0 as T)
        self.upshift( 0 as T, Int.min,  0 as T)
        self.upshift(-1 as T, Int.min, -1 as T)
        self.upshift(-2 as T, Int.min, -1 as T)
    }
    
    func testUpshiftZeroByMaxInt() {
        self.upshift( 0 as T, Int.max,  0 as T)
    }
    
    func testUpshiftAnyByZero() {
        for instance: T in [~2, ~1, ~0, 0, 1, 2] {
            self.upshift(instance, Int.zero, instance)
        }
    }
    
    func testDownshift() {
        self.downshift(-8 as T, Int( 1),  -4 as T)
        self.downshift(-8 as T, Int( 2),  -2 as T)
        self.downshift(-8 as T, Int( 3),  -1 as T)
        self.downshift(-8 as T, Int( 4),  -1 as T)
        self.downshift( 0 as T, Int( 1),   0 as T)
        self.downshift( 0 as T, Int( 2),   0 as T)
        self.downshift( 0 as T, Int( 3),   0 as T)
        self.downshift( 0 as T, Int( 4),   0 as T)
        self.downshift( 8 as T, Int( 1),   4 as T)
        self.downshift( 8 as T, Int( 2),   2 as T)
        self.downshift( 8 as T, Int( 3),   1 as T)
        self.downshift( 8 as T, Int( 4),   0 as T)
    }
    
    func testDownshiftAnyByMaxInt() {
        self.downshift( 2 as T, Int.max,  0 as T)
        self.downshift( 1 as T, Int.max,  0 as T)
        self.downshift( 0 as T, Int.max,  0 as T)
        self.downshift(-1 as T, Int.max, -1 as T)
        self.downshift(-2 as T, Int.max, -1 as T)
    }
    
    func testDownshiftZeroByMinInt() {
        self.downshift( 0 as T, Int.min,  0 as T)
    }
    
    func testDownshiftAnyByZero() {
        for instance: T in [~2, ~1, ~0, 0, 1, 2] {
            self.downshift(instance, Int.zero, instance)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

extension StdlibIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func upshift(_ lhs: T, _ rhs: Int, _ expectation: T, file: StaticString = #file, line: UInt = #line) {
        let test = Test(file: file, line: line)
        
        always: do {
            test.same(lhs << rhs, expectation)
            test.same({ var x = lhs; x <<= rhs; return x }(), expectation)
        }
        
        if  rhs != .min {
            test.same(lhs >> -rhs, expectation)
            test.same({ var x = lhs; x >>= -rhs; return x }(), expectation)
        }
    }
    
    
    func downshift(_ lhs: T, _ rhs: Int, _ expectation: T, file: StaticString = #file, line: UInt = #line) {
        let test = Test(file: file, line: line)
        
        always: do {
            test.same(lhs >> rhs, expectation)
            test.same({ var x = lhs; x >>= rhs; return x }(), expectation)
        }
        
        if  rhs != .min {
            test.same(lhs << -rhs, expectation)
            test.same({ var x = lhs; x <<= -rhs; return x }(), expectation)
        }
    }
}
