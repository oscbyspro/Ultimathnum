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
// MARK: * Strict Unsigned Integer x Sub Sequence x Addition
//*============================================================================*

final class StrictUnsignedIntegerSubSequenceTestsOnAddition: XCTestCase {
    
    typealias X   = [UX]
    typealias X64 = [U64]
    typealias X32 = [U32]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLargeByLarge() {
        checkElementsBit([ 0,  0,  0,  0] as X, [ 0,  0,  0,  0] as X, false, [ 0,  0,  0,  0] as X)
        checkElementsBit([ 0,  0,  0,  0] as X, [ 0,  0,  0,  0] as X, true,  [ 1,  0,  0,  0] as X)
        checkElementsBit([ 0,  0,  0,  0] as X, [ 1,  0,  0,  0] as X, false, [ 1,  0,  0,  0] as X)
        checkElementsBit([ 0,  0,  0,  0] as X, [ 1,  0,  0,  0] as X, true,  [ 2,  0,  0,  0] as X)
        
        checkElementsBit([~0, ~0, ~0, ~0] as X, [ 0,  0,  0,  0] as X, false, [~0, ~0, ~0, ~0] as X)
        checkElementsBit([~0, ~0, ~0, ~0] as X, [ 0,  0,  0,  0] as X, true,  [ 0,  0,  0,  0] as X, true)
        checkElementsBit([~0, ~0, ~0, ~0] as X, [ 1,  0,  0,  0] as X, false, [ 0,  0,  0,  0] as X, true)
        checkElementsBit([~0, ~0, ~0, ~0] as X, [ 1,  0,  0,  0] as X, true,  [ 1,  0,  0,  0] as X, true)
        
        checkElementsBit([ 0,  1,  2,  3] as X, [ 4,  0,  0,  0] as X, false, [ 4,  1,  2,  3] as X)
        checkElementsBit([ 0,  1,  2,  3] as X, [ 0,  4,  0,  0] as X, false, [ 0,  5,  2,  3] as X)
        checkElementsBit([ 0,  1,  2,  3] as X, [ 0,  0,  4,  0] as X, false, [ 0,  1,  6,  3] as X)
        checkElementsBit([ 0,  1,  2,  3] as X, [ 0,  0,  0,  4] as X, false, [ 0,  1,  2,  7] as X)
        
        checkElementsBit([ 0,  1,  2,  3] as X, [ 4,  0,  0,  0] as X, true,  [ 5,  1,  2,  3] as X)
        checkElementsBit([ 0,  1,  2,  3] as X, [ 0,  4,  0,  0] as X, true,  [ 1,  5,  2,  3] as X)
        checkElementsBit([ 0,  1,  2,  3] as X, [ 0,  0,  4,  0] as X, true,  [ 1,  1,  6,  3] as X)
        checkElementsBit([ 0,  1,  2,  3] as X, [ 0,  0,  0,  4] as X, true,  [ 1,  1,  2,  7] as X)
        
        checkElementsBit([ 0,  1,  2,  3] as X, [~4, ~0, ~0, ~0] as X, false, [~4,  0,  2,  3] as X, true)
        checkElementsBit([ 0,  1,  2,  3] as X, [~0, ~4, ~0, ~0] as X, false, [~0, ~3,  1,  3] as X, true)
        checkElementsBit([ 0,  1,  2,  3] as X, [~0, ~0, ~4, ~0] as X, false, [~0,  0, ~1,  2] as X, true)
        checkElementsBit([ 0,  1,  2,  3] as X, [~0, ~0, ~0, ~4] as X, false, [~0,  0,  2, ~0] as X)

        checkElementsBit([ 0,  1,  2,  3] as X, [~4, ~0, ~0, ~0] as X, true,  [~3,  0,  2,  3] as X, true)
        checkElementsBit([ 0,  1,  2,  3] as X, [~0, ~4, ~0, ~0] as X, true,  [ 0, ~2,  1,  3] as X, true)
        checkElementsBit([ 0,  1,  2,  3] as X, [~0, ~0, ~4, ~0] as X, true,  [ 0,  1, ~1,  2] as X, true)
        checkElementsBit([ 0,  1,  2,  3] as X, [~0, ~0, ~0, ~4] as X, true,  [ 0,  1,  2, ~0] as X)
        
        checkElementsBit([~0, ~1, ~2, ~3] as X, [ 4,  0,  0,  0] as X, false, [ 3, ~0, ~2, ~3] as X)
        checkElementsBit([~0, ~1, ~2, ~3] as X, [ 0,  4,  0,  0] as X, false, [~0,  2, ~1, ~3] as X)
        checkElementsBit([~0, ~1, ~2, ~3] as X, [ 0,  0,  4,  0] as X, false, [~0, ~1,  1, ~2] as X)
        checkElementsBit([~0, ~1, ~2, ~3] as X, [ 0,  0,  0,  4] as X, false, [~0, ~1, ~2,  0] as X, true)

        checkElementsBit([~0, ~1, ~2, ~3] as X, [ 4,  0,  0,  0] as X, true,  [ 4, ~0, ~2, ~3] as X)
        checkElementsBit([~0, ~1, ~2, ~3] as X, [ 0,  4,  0,  0] as X, true,  [ 0,  3, ~1, ~3] as X)
        checkElementsBit([~0, ~1, ~2, ~3] as X, [ 0,  0,  4,  0] as X, true,  [ 0, ~0,  1, ~2] as X)
        checkElementsBit([~0, ~1, ~2, ~3] as X, [ 0,  0,  0,  4] as X, true,  [ 0, ~0, ~2,  0] as X, true)
        
        checkElementsBit([~0, ~1, ~2, ~3] as X, [~4, ~0, ~0, ~0] as X, false, [~5, ~1, ~2, ~3] as X, true)
        checkElementsBit([~0, ~1, ~2, ~3] as X, [~0, ~4, ~0, ~0] as X, false, [~1, ~5, ~2, ~3] as X, true)
        checkElementsBit([~0, ~1, ~2, ~3] as X, [~0, ~0, ~4, ~0] as X, false, [~1, ~1, ~6, ~3] as X, true)
        checkElementsBit([~0, ~1, ~2, ~3] as X, [~0, ~0, ~0, ~4] as X, false, [~1, ~1, ~2, ~7] as X, true)

        checkElementsBit([~0, ~1, ~2, ~3] as X, [~4, ~0, ~0, ~0] as X, true,  [~4, ~1, ~2, ~3] as X, true)
        checkElementsBit([~0, ~1, ~2, ~3] as X, [~0, ~4, ~0, ~0] as X, true,  [~0, ~5, ~2, ~3] as X, true)
        checkElementsBit([~0, ~1, ~2, ~3] as X, [~0, ~0, ~4, ~0] as X, true,  [~0, ~1, ~6, ~3] as X, true)
        checkElementsBit([~0, ~1, ~2, ~3] as X, [~0, ~0, ~0, ~4] as X, true,  [~0, ~1, ~2, ~7] as X, true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Small (and Large)
    //=------------------------------------------------------------------------=
    
    func testLargeBySmall() {
        checkIncrementBit([ 0,  0,  0,  0] as X, UX.min, false, [ 0,  0,  0,  0] as X)
        checkIncrementBit([~0,  0,  0,  0] as X, UX.min, false, [~0,  0,  0,  0] as X)
        checkIncrementBit([~0, ~0,  0,  0] as X, UX.min, false, [~0, ~0,  0,  0] as X)
        checkIncrementBit([~0, ~0, ~0,  0] as X, UX.min, false, [~0, ~0, ~0,  0] as X)
        checkIncrementBit([~0, ~0, ~0, ~0] as X, UX.min, false, [~0, ~0, ~0, ~0] as X)
        
        checkIncrementBit([ 0,  0,  0,  0] as X, UX.min, true,  [ 1,  0,  0,  0] as X)
        checkIncrementBit([~0,  0,  0,  0] as X, UX.min, true,  [ 0,  1,  0,  0] as X)
        checkIncrementBit([~0, ~0,  0,  0] as X, UX.min, true,  [ 0,  0,  1,  0] as X)
        checkIncrementBit([~0, ~0, ~0,  0] as X, UX.min, true,  [ 0,  0,  0,  1] as X)
        checkIncrementBit([~0, ~0, ~0, ~0] as X, UX.min, true,  [ 0,  0,  0,  0] as X, true)
        
        checkIncrementBit([ 0,  0,  0,  0] as X, UX.max, false, [~0,  0,  0,  0] as X)
        checkIncrementBit([~0,  0,  0,  0] as X, UX.max, false, [~1,  1,  0,  0] as X)
        checkIncrementBit([~0, ~0,  0,  0] as X, UX.max, false, [~1,  0,  1,  0] as X)
        checkIncrementBit([~0, ~0, ~0,  0] as X, UX.max, false, [~1,  0,  0,  1] as X)
        checkIncrementBit([~0, ~0, ~0, ~0] as X, UX.max, false, [~1,  0,  0,  0] as X, true)
        
        checkIncrementBit([ 0,  0,  0,  0] as X, UX.max, true,  [ 0,  1,  0,  0] as X)
        checkIncrementBit([~0,  0,  0,  0] as X, UX.max, true,  [~0,  1,  0,  0] as X)
        checkIncrementBit([~0, ~0,  0,  0] as X, UX.max, true,  [~0,  0,  1,  0] as X)
        checkIncrementBit([~0, ~0, ~0,  0] as X, UX.max, true,  [~0,  0,  0,  1] as X)
        checkIncrementBit([~0, ~0, ~0, ~0] as X, UX.max, true,  [~0,  0,  0,  0] as X, true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Product
    //=------------------------------------------------------------------------=
    
    func testLargeByProduct() {
        checkProductIncrement([ 0    ] as X, ([ ] as X, UX( )), UX(0), [ 0    ] as X)
        checkProductIncrement([ 0    ] as X, ([ ] as X, UX( )), UX(1), [ 1    ] as X)
        checkProductIncrement([~0    ] as X, ([ ] as X, UX( )), UX(0), [~0    ] as X)
        checkProductIncrement([~0    ] as X, ([ ] as X, UX( )), UX(1), [ 0    ] as X, true)
        
        checkProductIncrement([ 0,  0] as X, ([0] as X, UX( )), UX(0), [ 0,  0] as X)
        checkProductIncrement([ 0,  0] as X, ([0] as X, UX( )), UX(1), [ 1,  0] as X)
        checkProductIncrement([~0, ~0] as X, ([0] as X, UX( )), UX(0), [~0, ~0] as X)
        checkProductIncrement([~0, ~0] as X, ([0] as X, UX( )), UX(1), [ 0,  0] as X, true)
        
        checkProductIncrement([ 0,  0] as X, ([2] as X, UX(0)), UX(0), [ 0,  0] as X)
        checkProductIncrement([ 0,  0] as X, ([2] as X, UX(0)), UX(1), [ 1,  0] as X)
        checkProductIncrement([~0, ~0] as X, ([2] as X, UX(0)), UX(0), [~0, ~0] as X)
        checkProductIncrement([~0, ~0] as X, ([2] as X, UX(0)), UX(1), [ 0,  0] as X, true)
        
        checkProductIncrement([ 0,  0] as X, ([0] as X, UX(3)), UX(0), [ 0,  0] as X)
        checkProductIncrement([ 0,  0] as X, ([0] as X, UX(3)), UX(1), [ 1,  0] as X)
        checkProductIncrement([~0, ~0] as X, ([0] as X, UX(3)), UX(0), [~0, ~0] as X)
        checkProductIncrement([~0, ~0] as X, ([0] as X, UX(3)), UX(1), [ 0,  0] as X, true)
        
        checkProductIncrement([ 0,  0] as X, ([2] as X, UX(3)), UX(0), [ 6,  0] as X)
        checkProductIncrement([ 0,  0] as X, ([2] as X, UX(3)), UX(1), [ 7,  0] as X)
        checkProductIncrement([~0, ~0] as X, ([2] as X, UX(3)), UX(0), [ 5,  0] as X, true)
        checkProductIncrement([~0, ~0] as X, ([2] as X, UX(3)), UX(1), [ 6,  0] as X, true)
    }
    
    func testLargeByProductReportingOverflow() {
        var base: X
        var product: (X, UX); product.1 = 2 as UX
        //=--------------------------------------=
        base = [ 0,  0,  0,  0,  0,  0,  0,  0] as X; product.0 = [ 1,  2,  3,  4]  as X
        checkProductIncrement(base, product, UX(  ),  [ 2,  4,  6,  8,  0,  0,  0,  0] as X)
        checkProductIncrement(base, product, UX.max,  [ 1,  5,  6,  8,  0,  0,  0,  0] as X)
        //=--------------------------------------=
        base = [ 0,  0,  0,  0,  0,  0,  0,  0] as X; product.0 = [~1, ~2, ~3, ~4]  as X
        checkProductIncrement(base, product, UX(  ),  [~3, ~4, ~6, ~8,  1,  0,  0,  0] as X)
        checkProductIncrement(base, product, UX.max,  [~4, ~3, ~6, ~8,  1,  0,  0,  0] as X)
        //=--------------------------------------=
        base = [~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as X; product.0 = [ 1,  2,  3,  4]  as X
        checkProductIncrement(base, product, UX(  ),  [ 1,  4,  6,  8,  0,  0,  0,  0] as X, true)
        checkProductIncrement(base, product, UX.max,  [ 0,  5,  6,  8,  0,  0,  0,  0] as X, true)
        //=--------------------------------------=
        base = [~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as X; product.0 = [~1, ~2, ~3, ~4]  as X
        checkProductIncrement(base, product, UX(  ),  [~4, ~4, ~6, ~8,  1,  0,  0,  0] as X, true)
        checkProductIncrement(base, product, UX.max,  [~5, ~3, ~6, ~8,  1,  0,  0,  0] as X, true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    private func checkElementsBit(
    _ base: [UX], _ elements: [UX], _ bit: Bool, _ result: [UX], _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        // increment: elements + bit
        //=--------------------------------------=
        brr: do {
            var lhs = base
            let max = SUISS.increment(&lhs, by: elements, plus: bit)
            XCTAssertEqual(lhs,          result,   file: file, line: line)
            XCTAssertEqual(max.overflow, overflow, file: file, line: line)
        }
        
        brr: do {
            var lhs = base
            let min = SUISS.incrementInIntersection(&lhs, by: elements, plus: bit)
            let max = SUISS.increment(&lhs[min.index...], by: min.overflow)
            XCTAssertEqual(lhs,          result,   file: file, line: line)
            XCTAssertEqual(max.overflow, overflow, file: file, line: line)
        }
        
        brr: do {
            var lhs = base, elements = elements
            let min = SUISS.incrementInIntersection(&lhs, by: elements, plus: bit)
            let sfx = Array(repeating: 0 as UX, count: lhs[min.index... ].count)
            let max = SUISS.increment(&lhs[min.index...], by: sfx,  plus: min.overflow)
            XCTAssertEqual(lhs,          result,   file: file, line: line)
            XCTAssertEqual(max.overflow, overflow, file: file, line: line)
        }
    }

    func checkIncrementBit(
    _ base: [UX], _ increment: UX, _ bit: Bool, _ result: [UX], _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        checkElementsBit(base, [increment], bit, result, overflow, file: file, line: line)
        //=--------------------------------------=
        // increment: some
        //=--------------------------------------=
        if !bit {
            var lhs = base
            let max = SUISS.increment(&lhs, by: increment)
            XCTAssertEqual(lhs,          result,   file: file, line: line)
            XCTAssertEqual(max.overflow, overflow, file: file, line: line)
        }
        
        if !bit {
            var lhs = base
            let min = SUISS.incrementInIntersection(&lhs, by: increment)
            let max = SUISS.increment(&lhs[min.index...], by: min.overflow)
            XCTAssertEqual(lhs,          result,   file: file, line: line)
            XCTAssertEqual(max.overflow, overflow, file: file, line: line)
        }
        //=--------------------------------------=
        // increment: some + bit
        //=--------------------------------------=
        brr: do {
            var lhs = base
            let max = SUISS.increment(&lhs, by: increment, plus: bit)
            XCTAssertEqual(lhs,          result,   file: file, line: line)
            XCTAssertEqual(max.overflow, overflow, file: file, line: line)
        }
        
        brr: do {
            var lhs = base
            let min = SUISS.incrementInIntersection(&lhs, by: increment, plus: bit)
            let max = SUISS.increment(&lhs[min.index...], by: min.overflow)
            XCTAssertEqual(lhs,          result,   file: file, line: line)
            XCTAssertEqual(max.overflow, overflow, file: file, line: line)
        }
        
        brr: do {
            var lhs = base, increment = increment
            let min = SUISS.incrementInIntersection(&lhs, by: increment,  plus: bit)
            let sfx = Array(repeating: 0 as UX, count: lhs[min.index... ].count)
            let max = SUISS.increment(&lhs[min.index...], by: sfx,  plus: min.overflow)
            XCTAssertEqual(lhs,          result,   file: file, line: line)
            XCTAssertEqual(max.overflow, overflow, file: file, line: line)
        }
    }

    func checkProductIncrement(
    _ base: [UX], _ product: ([UX], UX), _ increment: UX, _ result: [UX], _ overflow: Bool = false,
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        // increment: elements × digit + digit
        //=--------------------------------------=
        brr: do {
            var lhs = base
            let max = SUISS.increment(&lhs, by: product.0, times: product.1, plus: increment)
            XCTAssertEqual(lhs,          result,   file: file, line: line)
            XCTAssertEqual(max.overflow, overflow, file: file, line: line)
        }
        
        brr: do {
            var lhs = base
            let min = SUISS.incrementInIntersection(&lhs, by: product.0, times: product.1, plus: increment)
            let max = SUISS.increment(&lhs[min.index...], by: min.overflow)
            XCTAssertEqual(lhs,          result,   file: file, line: line)
            XCTAssertEqual(max.overflow, overflow, file: file, line: line)
        }
    }
}
