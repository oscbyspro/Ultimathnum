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
        typealias F = Fallible<[UX]>
        
        checkElementsBit([ 0,  0,  0,  0] as X, [ 0,  0,  0,  0] as X, false, F([ 0,  0,  0,  0] as X))
        checkElementsBit([ 0,  0,  0,  0] as X, [ 0,  0,  0,  0] as X, true,  F([ 1,  0,  0,  0] as X))
        checkElementsBit([ 0,  0,  0,  0] as X, [ 1,  0,  0,  0] as X, false, F([ 1,  0,  0,  0] as X))
        checkElementsBit([ 0,  0,  0,  0] as X, [ 1,  0,  0,  0] as X, true,  F([ 2,  0,  0,  0] as X))
        
        checkElementsBit([~0, ~0, ~0, ~0] as X, [ 0,  0,  0,  0] as X, false, F([~0, ~0, ~0, ~0] as X))
        checkElementsBit([~0, ~0, ~0, ~0] as X, [ 0,  0,  0,  0] as X, true,  F([ 0,  0,  0,  0] as X, error: true))
        checkElementsBit([~0, ~0, ~0, ~0] as X, [ 1,  0,  0,  0] as X, false, F([ 0,  0,  0,  0] as X, error: true))
        checkElementsBit([~0, ~0, ~0, ~0] as X, [ 1,  0,  0,  0] as X, true,  F([ 1,  0,  0,  0] as X, error: true))
        
        checkElementsBit([ 0,  1,  2,  3] as X, [ 4,  0,  0,  0] as X, false, F([ 4,  1,  2,  3] as X))
        checkElementsBit([ 0,  1,  2,  3] as X, [ 0,  4,  0,  0] as X, false, F([ 0,  5,  2,  3] as X))
        checkElementsBit([ 0,  1,  2,  3] as X, [ 0,  0,  4,  0] as X, false, F([ 0,  1,  6,  3] as X))
        checkElementsBit([ 0,  1,  2,  3] as X, [ 0,  0,  0,  4] as X, false, F([ 0,  1,  2,  7] as X))
        
        checkElementsBit([ 0,  1,  2,  3] as X, [ 4,  0,  0,  0] as X, true,  F([ 5,  1,  2,  3] as X))
        checkElementsBit([ 0,  1,  2,  3] as X, [ 0,  4,  0,  0] as X, true,  F([ 1,  5,  2,  3] as X))
        checkElementsBit([ 0,  1,  2,  3] as X, [ 0,  0,  4,  0] as X, true,  F([ 1,  1,  6,  3] as X))
        checkElementsBit([ 0,  1,  2,  3] as X, [ 0,  0,  0,  4] as X, true,  F([ 1,  1,  2,  7] as X))
        
        checkElementsBit([ 0,  1,  2,  3] as X, [~4, ~0, ~0, ~0] as X, false, F([~4,  0,  2,  3] as X, error: true))
        checkElementsBit([ 0,  1,  2,  3] as X, [~0, ~4, ~0, ~0] as X, false, F([~0, ~3,  1,  3] as X, error: true))
        checkElementsBit([ 0,  1,  2,  3] as X, [~0, ~0, ~4, ~0] as X, false, F([~0,  0, ~1,  2] as X, error: true))
        checkElementsBit([ 0,  1,  2,  3] as X, [~0, ~0, ~0, ~4] as X, false, F([~0,  0,  2, ~0] as X))

        checkElementsBit([ 0,  1,  2,  3] as X, [~4, ~0, ~0, ~0] as X, true,  F([~3,  0,  2,  3] as X, error: true))
        checkElementsBit([ 0,  1,  2,  3] as X, [~0, ~4, ~0, ~0] as X, true,  F([ 0, ~2,  1,  3] as X, error: true))
        checkElementsBit([ 0,  1,  2,  3] as X, [~0, ~0, ~4, ~0] as X, true,  F([ 0,  1, ~1,  2] as X, error: true))
        checkElementsBit([ 0,  1,  2,  3] as X, [~0, ~0, ~0, ~4] as X, true,  F([ 0,  1,  2, ~0] as X))
        
        checkElementsBit([~0, ~1, ~2, ~3] as X, [ 4,  0,  0,  0] as X, false, F([ 3, ~0, ~2, ~3] as X))
        checkElementsBit([~0, ~1, ~2, ~3] as X, [ 0,  4,  0,  0] as X, false, F([~0,  2, ~1, ~3] as X))
        checkElementsBit([~0, ~1, ~2, ~3] as X, [ 0,  0,  4,  0] as X, false, F([~0, ~1,  1, ~2] as X))
        checkElementsBit([~0, ~1, ~2, ~3] as X, [ 0,  0,  0,  4] as X, false, F([~0, ~1, ~2,  0] as X, error: true))

        checkElementsBit([~0, ~1, ~2, ~3] as X, [ 4,  0,  0,  0] as X, true,  F([ 4, ~0, ~2, ~3] as X))
        checkElementsBit([~0, ~1, ~2, ~3] as X, [ 0,  4,  0,  0] as X, true,  F([ 0,  3, ~1, ~3] as X))
        checkElementsBit([~0, ~1, ~2, ~3] as X, [ 0,  0,  4,  0] as X, true,  F([ 0, ~0,  1, ~2] as X))
        checkElementsBit([~0, ~1, ~2, ~3] as X, [ 0,  0,  0,  4] as X, true,  F([ 0, ~0, ~2,  0] as X, error: true))
        
        checkElementsBit([~0, ~1, ~2, ~3] as X, [~4, ~0, ~0, ~0] as X, false, F([~5, ~1, ~2, ~3] as X, error: true))
        checkElementsBit([~0, ~1, ~2, ~3] as X, [~0, ~4, ~0, ~0] as X, false, F([~1, ~5, ~2, ~3] as X, error: true))
        checkElementsBit([~0, ~1, ~2, ~3] as X, [~0, ~0, ~4, ~0] as X, false, F([~1, ~1, ~6, ~3] as X, error: true))
        checkElementsBit([~0, ~1, ~2, ~3] as X, [~0, ~0, ~0, ~4] as X, false, F([~1, ~1, ~2, ~7] as X, error: true))

        checkElementsBit([~0, ~1, ~2, ~3] as X, [~4, ~0, ~0, ~0] as X, true,  F([~4, ~1, ~2, ~3] as X, error: true))
        checkElementsBit([~0, ~1, ~2, ~3] as X, [~0, ~4, ~0, ~0] as X, true,  F([~0, ~5, ~2, ~3] as X, error: true))
        checkElementsBit([~0, ~1, ~2, ~3] as X, [~0, ~0, ~4, ~0] as X, true,  F([~0, ~1, ~6, ~3] as X, error: true))
        checkElementsBit([~0, ~1, ~2, ~3] as X, [~0, ~0, ~0, ~4] as X, true,  F([~0, ~1, ~2, ~7] as X, error: true))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Small (and Large)
    //=------------------------------------------------------------------------=
    
    func testLargeBySmall() {
        typealias F = Fallible<[UX]>
        
        checkIncrementBit([ 0,  0,  0,  0] as X, UX.min, false, F([ 0,  0,  0,  0] as X))
        checkIncrementBit([~0,  0,  0,  0] as X, UX.min, false, F([~0,  0,  0,  0] as X))
        checkIncrementBit([~0, ~0,  0,  0] as X, UX.min, false, F([~0, ~0,  0,  0] as X))
        checkIncrementBit([~0, ~0, ~0,  0] as X, UX.min, false, F([~0, ~0, ~0,  0] as X))
        checkIncrementBit([~0, ~0, ~0, ~0] as X, UX.min, false, F([~0, ~0, ~0, ~0] as X))
        
        checkIncrementBit([ 0,  0,  0,  0] as X, UX.min, true,  F([ 1,  0,  0,  0] as X))
        checkIncrementBit([~0,  0,  0,  0] as X, UX.min, true,  F([ 0,  1,  0,  0] as X))
        checkIncrementBit([~0, ~0,  0,  0] as X, UX.min, true,  F([ 0,  0,  1,  0] as X))
        checkIncrementBit([~0, ~0, ~0,  0] as X, UX.min, true,  F([ 0,  0,  0,  1] as X))
        checkIncrementBit([~0, ~0, ~0, ~0] as X, UX.min, true,  F([ 0,  0,  0,  0] as X, error: true))
        
        checkIncrementBit([ 0,  0,  0,  0] as X, UX.max, false, F([~0,  0,  0,  0] as X))
        checkIncrementBit([~0,  0,  0,  0] as X, UX.max, false, F([~1,  1,  0,  0] as X))
        checkIncrementBit([~0, ~0,  0,  0] as X, UX.max, false, F([~1,  0,  1,  0] as X))
        checkIncrementBit([~0, ~0, ~0,  0] as X, UX.max, false, F([~1,  0,  0,  1] as X))
        checkIncrementBit([~0, ~0, ~0, ~0] as X, UX.max, false, F([~1,  0,  0,  0] as X, error: true))
        
        checkIncrementBit([ 0,  0,  0,  0] as X, UX.max, true,  F([ 0,  1,  0,  0] as X))
        checkIncrementBit([~0,  0,  0,  0] as X, UX.max, true,  F([~0,  1,  0,  0] as X))
        checkIncrementBit([~0, ~0,  0,  0] as X, UX.max, true,  F([~0,  0,  1,  0] as X))
        checkIncrementBit([~0, ~0, ~0,  0] as X, UX.max, true,  F([~0,  0,  0,  1] as X))
        checkIncrementBit([~0, ~0, ~0, ~0] as X, UX.max, true,  F([~0,  0,  0,  0] as X, error: true))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Product
    //=------------------------------------------------------------------------=
    
    func testLargeByProduct() {
        typealias F = Fallible<[UX]>
        
        checkProductIncrement([ 0    ] as X, ([ ] as X, UX( )), UX(0), F([ 0    ] as X))
        checkProductIncrement([ 0    ] as X, ([ ] as X, UX( )), UX(1), F([ 1    ] as X))
        checkProductIncrement([~0    ] as X, ([ ] as X, UX( )), UX(0), F([~0    ] as X))
        checkProductIncrement([~0    ] as X, ([ ] as X, UX( )), UX(1), F([ 0    ] as X, error: true))
        
        checkProductIncrement([ 0,  0] as X, ([0] as X, UX( )), UX(0), F([ 0,  0] as X))
        checkProductIncrement([ 0,  0] as X, ([0] as X, UX( )), UX(1), F([ 1,  0] as X))
        checkProductIncrement([~0, ~0] as X, ([0] as X, UX( )), UX(0), F([~0, ~0] as X))
        checkProductIncrement([~0, ~0] as X, ([0] as X, UX( )), UX(1), F([ 0,  0] as X, error: true))
        
        checkProductIncrement([ 0,  0] as X, ([2] as X, UX(0)), UX(0), F([ 0,  0] as X))
        checkProductIncrement([ 0,  0] as X, ([2] as X, UX(0)), UX(1), F([ 1,  0] as X))
        checkProductIncrement([~0, ~0] as X, ([2] as X, UX(0)), UX(0), F([~0, ~0] as X))
        checkProductIncrement([~0, ~0] as X, ([2] as X, UX(0)), UX(1), F([ 0,  0] as X, error: true))
        
        checkProductIncrement([ 0,  0] as X, ([0] as X, UX(3)), UX(0), F([ 0,  0] as X))
        checkProductIncrement([ 0,  0] as X, ([0] as X, UX(3)), UX(1), F([ 1,  0] as X))
        checkProductIncrement([~0, ~0] as X, ([0] as X, UX(3)), UX(0), F([~0, ~0] as X))
        checkProductIncrement([~0, ~0] as X, ([0] as X, UX(3)), UX(1), F([ 0,  0] as X, error: true))
        
        checkProductIncrement([ 0,  0] as X, ([2] as X, UX(3)), UX(0), F([ 6,  0] as X))
        checkProductIncrement([ 0,  0] as X, ([2] as X, UX(3)), UX(1), F([ 7,  0] as X))
        checkProductIncrement([~0, ~0] as X, ([2] as X, UX(3)), UX(0), F([ 5,  0] as X, error: true))
        checkProductIncrement([~0, ~0] as X, ([2] as X, UX(3)), UX(1), F([ 6,  0] as X, error: true))
    }
    
    func testLargeByProductReportingOverflow() {
        typealias F = Fallible<[UX]>
        //=--------------------------------------=
        var base: X
        var product: (X, UX); product.1 = 2 as UX
        //=--------------------------------------=
        base = [ 0,  0,  0,  0,  0,  0,  0,  0] as X; product.0 = [ 1,  2,  3,  4]  as X
        checkProductIncrement(base, product, UX(  ),  F([ 2,  4,  6,  8,  0,  0,  0,  0] as X))
        checkProductIncrement(base, product, UX.max,  F([ 1,  5,  6,  8,  0,  0,  0,  0] as X))
        //=--------------------------------------=
        base = [ 0,  0,  0,  0,  0,  0,  0,  0] as X; product.0 = [~1, ~2, ~3, ~4]  as X
        checkProductIncrement(base, product, UX(  ),  F([~3, ~4, ~6, ~8,  1,  0,  0,  0] as X))
        checkProductIncrement(base, product, UX.max,  F([~4, ~3, ~6, ~8,  1,  0,  0,  0] as X))
        //=--------------------------------------=
        base = [~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as X; product.0 = [ 1,  2,  3,  4]  as X
        checkProductIncrement(base, product, UX(  ),  F([ 1,  4,  6,  8,  0,  0,  0,  0] as X, error: true))
        checkProductIncrement(base, product, UX.max,  F([ 0,  5,  6,  8,  0,  0,  0,  0] as X, error: true))
        //=--------------------------------------=
        base = [~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as X; product.0 = [~1, ~2, ~3, ~4]  as X
        checkProductIncrement(base, product, UX(  ),  F([~4, ~4, ~6, ~8,  1,  0,  0,  0] as X, error: true))
        checkProductIncrement(base, product, UX.max,  F([~5, ~3, ~6, ~8,  1,  0,  0,  0] as X, error: true))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    private func checkElementsBit(
        _ base: [UX], 
        _ elements: [UX],
        _ bit: Bool,
        _ expectation: Fallible<[UX]>,
        _ test: Test = .init()
    ) {
        //=--------------------------------------=
        // increment: elements + bit
        //=--------------------------------------=
        brr: do {
            var lhs = base
            let max = SUISS.increment(&lhs, by: elements, plus: bit)
            test.same(Fallible(lhs, error: max.overflow), expectation)
        }
        
        brr: do {
            var lhs = base
            let min = SUISS.incrementInIntersection(&lhs, by: elements, plus: bit)
            let max = SUISS.increment(&lhs[min.index...], by: min.overflow)
            test.same(Fallible(lhs, error: max.overflow), expectation)
        }
        
        brr: do {
            var lhs = base, elements = elements
            let min = SUISS.incrementInIntersection(&lhs, by: elements, plus: bit)
            let sfx = Array(repeating: 0 as UX, count: lhs[min.index... ].count)
            let max = SUISS.increment(&lhs[min.index...], by: sfx,  plus: min.overflow)
            test.same(Fallible(lhs, error: max.overflow), expectation)
        }
    }

    func checkIncrementBit(
        _ base: [UX], 
        _ increment: UX,
        _ bit: Bool, 
        _ expectation: Fallible<[UX]>,
        _ test: Test = .init()
    ) {
        //=--------------------------------------=
        checkElementsBit(base, [increment], bit, expectation, test)
        //=--------------------------------------=
        // increment: some
        //=--------------------------------------=
        if !bit {
            var lhs = base
            let max = SUISS.increment(&lhs, by: increment)
            test.same(Fallible(lhs, error: max.overflow), expectation)
        }
        
        if !bit {
            var lhs = base
            let min = SUISS.incrementInIntersection(&lhs, by: increment)
            let max = SUISS.increment(&lhs[min.index...], by: min.overflow)
            test.same(Fallible(lhs, error: max.overflow), expectation)
        }
        //=--------------------------------------=
        // increment: some + bit
        //=--------------------------------------=
        brr: do {
            var lhs = base
            let max = SUISS.increment(&lhs, by: increment, plus: bit)
            test.same(Fallible(lhs, error: max.overflow), expectation)
        }
        
        brr: do {
            var lhs = base
            let min = SUISS.incrementInIntersection(&lhs, by: increment, plus: bit)
            let max = SUISS.increment(&lhs[min.index...], by: min.overflow)
            test.same(Fallible(lhs, error: max.overflow), expectation)
        }
        
        brr: do {
            var lhs = base, increment = increment
            let min = SUISS.incrementInIntersection(&lhs, by: increment,  plus: bit)
            let sfx = Array(repeating: 0 as UX, count: lhs[min.index... ].count)
            let max = SUISS.increment(&lhs[min.index...], by: sfx,  plus: min.overflow)
            test.same(Fallible(lhs, error: max.overflow), expectation)
        }
    }

    func checkProductIncrement(
        _ base: [UX], 
        _ product: ([UX], UX),
        _ increment: UX,
        _ expectation: Fallible<[UX]>,
        _ test: Test = .init()
    ) {
        //=--------------------------------------=
        // increment: elements × digit + digit
        //=--------------------------------------=
        brr: do {
            var lhs = base
            let max = SUISS.increment(&lhs, by: product.0, times: product.1, plus: increment)
            test.same(Fallible(lhs, error: max.overflow), expectation)
        }
        
        brr: do {
            var lhs = base
            let min = SUISS.incrementInIntersection(&lhs, by: product.0, times: product.1, plus: increment)
            let max = SUISS.increment(&lhs[min.index...], by: min.overflow)
            test.same(Fallible(lhs, error: max.overflow), expectation)
        }
    }
}
