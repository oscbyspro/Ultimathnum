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
// MARK: * Strict Binary Integer x Shifts
//*============================================================================*

final class StrictBinaryIntegerTestsOnShifts: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testShiftLeftMinor() {
        checkShiftLeft([ 1,  2,  3,  4] as [U8],  0 as U8,  0 as Int, [ 1,  2,  3,  4] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8],  0 as U8,  1 as Int, [ 2,  4,  6,  8] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8],  0 as U8,  2 as Int, [ 4,  8, 12, 16] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8],  0 as U8,  3 as Int, [ 8, 16, 24, 32] as [U8])
        
        checkShiftLeft([ 1,  2,  3,  4] as [U8], ~0 as U8,  0 as Int, [ 1,  2,  3,  4] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8], ~0 as U8,  1 as Int, [ 3,  4,  6,  8] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8], ~0 as U8,  2 as Int, [ 7,  8, 12, 16] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8], ~0 as U8,  3 as Int, [15, 16, 24, 32] as [U8])
    }
    
    func testShiftLeftMajor() {
        checkShiftLeft([ 1,  2,  3,  4] as [U8],  0 as U8,  0 as Int, [ 1,  2,  3,  4] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8],  0 as U8,  8 as Int, [ 0,  1,  2,  3] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8],  0 as U8, 16 as Int, [ 0,  0,  1,  2] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8],  0 as U8, 24 as Int, [ 0,  0,  0,  1] as [U8])
        
        checkShiftLeft([ 1,  2,  3,  4] as [U8], ~0 as U8,  0 as Int, [ 1,  2,  3,  4] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8], ~0 as U8,  8 as Int, [~0,  1,  2,  3] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8], ~0 as U8, 16 as Int, [~0, ~0,  1,  2] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8], ~0 as U8, 24 as Int, [~0, ~0, ~0,  1] as [U8])
    }
    
    func testShiftLeftMajorMinor() {
        checkShiftLeft([ 1,  2,  3,  4] as [U8],  0 as U8,  3 as Int, [ 8, 16, 24, 32] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8],  0 as U8, 11 as Int, [ 0,  8, 16, 24] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8],  0 as U8, 19 as Int, [ 0,  0,  8, 16] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8],  0 as U8, 27 as Int, [ 0,  0,  0,  8] as [U8])
        
        checkShiftLeft([ 1,  2,  3,  4] as [U8], ~0 as U8,  3 as Int, [15, 16, 24, 32] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8], ~0 as U8, 11 as Int, [~0, 15, 16, 24] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8], ~0 as U8, 19 as Int, [~0, ~0, 15, 16] as [U8])
        checkShiftLeft([ 1,  2,  3,  4] as [U8], ~0 as U8, 27 as Int, [~0, ~0, ~0, 15] as [U8])
    }
    
    func testShiftLeftSuchThatElementsSplit() {
        checkShiftLeft([~0,  0,  0,  0] as [U8],  0 as U8,  1 as Int, [~1,  1,  0,  0] as [U8])
        checkShiftLeft([ 0, ~0,  0,  0] as [U8],  0 as U8,  1 as Int, [ 0, ~1,  1,  0] as [U8])
        checkShiftLeft([ 0,  0, ~0,  0] as [U8],  0 as U8,  1 as Int, [ 0,  0, ~1,  1] as [U8])
        checkShiftLeft([ 0,  0,  0, ~0] as [U8],  0 as U8,  1 as Int, [ 0,  0,  0, ~1] as [U8])
        
        checkShiftLeft([~0,  0,  0,  0] as [U8], ~0 as U8,  1 as Int, [~0,  1,  0,  0] as [U8])
        checkShiftLeft([ 0, ~0,  0,  0] as [U8], ~0 as U8,  1 as Int, [ 1, ~1,  1,  0] as [U8])
        checkShiftLeft([ 0,  0, ~0,  0] as [U8], ~0 as U8,  1 as Int, [ 1,  0, ~1,  1] as [U8])
        checkShiftLeft([ 0,  0,  0, ~0] as [U8], ~0 as U8,  1 as Int, [ 1,  0,  0, ~1] as [U8])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testShiftRightMinor() {
        checkShiftRight([8, 16, 24, 32] as [U8],  0 as U8,  0 as Int, [ 8, 16, 24, 32] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8],  0 as U8,  1 as Int, [ 4,  8, 12, 16] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8],  0 as U8,  2 as Int, [ 2,  4,  6,  8] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8],  0 as U8,  3 as Int, [ 1,  2,  3,  4] as [U8])
        
        checkShiftRight([8, 16, 24, 32] as [U8], ~0 as U8,  0 as Int, [ 8, 16, 24, 32 + ~0 << 8] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8], ~0 as U8,  1 as Int, [ 4,  8, 12, 16 + ~0 << 7] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8], ~0 as U8,  2 as Int, [ 2,  4,  6,  8 + ~0 << 6] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8], ~0 as U8,  3 as Int, [ 1,  2,  3,  4 + ~0 << 5] as [U8])
    }

    func testShiftRightMajor() {
        checkShiftRight([8, 16, 24, 32] as [U8],  0 as U8,  0 as Int, [ 8, 16, 24, 32] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8],  0 as U8,  8 as Int, [16, 24, 32,  0] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8],  0 as U8, 16 as Int, [24, 32,  0,  0] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8],  0 as U8, 24 as Int, [32,  0,  0,  0] as [U8])
        
        checkShiftRight([8, 16, 24, 32] as [U8], ~0 as U8,  0 as Int, [ 8, 16, 24, 32] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8], ~0 as U8,  8 as Int, [16, 24, 32, ~0] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8], ~0 as U8, 16 as Int, [24, 32, ~0, ~0] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8], ~0 as U8, 24 as Int, [32, ~0, ~0, ~0] as [U8])
    }

    func testShiftRightMajorMinor() {
        checkShiftRight([8, 16, 24, 32] as [U8],  0 as U8,  3 as Int, [ 1,  2,  3,  4] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8],  0 as U8, 11 as Int, [ 2,  3,  4,  0] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8],  0 as U8, 19 as Int, [ 3,  4,  0,  0] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8],  0 as U8, 27 as Int, [ 4,  0,  0,  0] as [U8])
        
        checkShiftRight([8, 16, 24, 32] as [U8], ~0 as U8,  3 as Int, [ 1,   2,   3,   4 + ~0 << 5] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8], ~0 as U8, 11 as Int, [ 2,   3,   4 + ~0 << 5,  ~0] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8], ~0 as U8, 19 as Int, [ 3,   4 + ~0 << 5,  ~0,  ~0] as [U8])
        checkShiftRight([8, 16, 24, 32] as [U8], ~0 as U8, 27 as Int, [ 4 + ~0 << 5,  ~0,  ~0,  ~0] as [U8])
    }
    
    func testShiftRightSuchThatElementsSplit() {
        checkShiftRight([0,  0,  0,  7] as [U8],  0 as U8,  1 as Int, [ 0,   0,   1 << 7, 3] as [U8])
        checkShiftRight([0,  0,  7,  0] as [U8],  0 as U8,  1 as Int, [ 0,   1 << 7,   3, 0] as [U8])
        checkShiftRight([0,  7,  0,  0] as [U8],  0 as U8,  1 as Int, [ 1 << 7,   3,   0, 0] as [U8])
        checkShiftRight([7,  0,  0,  0] as [U8],  0 as U8,  1 as Int, [ 3,        0,   0, 0] as [U8])
        
        checkShiftRight([0,  0,  0,  7] as [U8], ~0 as U8,  1 as Int, [ 0,   0,   1 << 7, 3 + ~0 << 7] as [U8])
        checkShiftRight([0,  0,  7,  0] as [U8], ~0 as U8,  1 as Int, [ 0,   1 << 7,   3, 0 + ~0 << 7] as [U8])
        checkShiftRight([0,  7,  0,  0] as [U8], ~0 as U8,  1 as Int, [ 1 << 7,   3,   0, 0 + ~0 << 7] as [U8])
        checkShiftRight([7,  0,  0,  0] as [U8], ~0 as U8,  1 as Int, [ 3,        0,   0, 0 + ~0 << 7] as [U8])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    private func checkShiftLeft<T: SystemsInteger & UnsignedInteger>(
    _ base: [T], _ environment: T, _ distance: Int, _ result: [T],
    file: StaticString = #file, line: UInt  = #line) {
        //=------------------------------------------=
        let (major, minor) = distance.quotientAndRemainder(dividingBy: IX(bitWidth: T.self).base)
        //=------------------------------------------=
        if  major >= 1, minor == 0 {
            var base = base
            SBI.bitShiftLeft(&base, environment: environment, majorAtLeastOne: major)
            XCTAssertEqual(base, result, file: file, line: line)
        }
        
        if  major >= 0, minor >= 1 {
            var base = base
            SBI.bitShiftLeft(&base, environment: environment, major: major, minorAtLeastOne: minor)
            XCTAssertEqual(base, result, file: file, line: line)
        }
    }

    private func checkShiftRight<T: SystemsInteger & UnsignedInteger>(
    _ base: [T], _ environment: T, _ distance: Int, _ result: [T],
    file: StaticString = #file, line: UInt  = #line) {
        //=------------------------------------------=
        let (major, minor) = distance.quotientAndRemainder(dividingBy: IX(bitWidth: T.self).base)
        //=------------------------------------------=
        if  major >= 1, minor == 0 {
            var base = base
            SBI.bitShiftRight(&base, environment: environment, majorAtLeastOne: major)
            XCTAssertEqual(base, result, file: file, line: line)
        }
        
        if  major >= 0, minor >= 1 {
            var base = base
            SBI.bitShiftRight(&base, environment: environment, major: major, minorAtLeastOne: minor)
            XCTAssertEqual(base, result, file: file, line: line)
        }
    }
}
