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
// MARK: * Count x Comparison
//*============================================================================*

final class CountTestsOnComparison: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let patterns = CountTests.patterns
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsZeroIsLikeBinaryIntegerIsZero() {
        for x in Self.patterns {
            Test().same(Count(raw: x).isZero, x.isZero)
        }
    }
    
    func testIsInfiniteIsLikeSignedIntegerIsNegative() {
        for x in Self.patterns {
            Test().same(Count(raw: x).isInfinite, x.isNegative)
        }
    }
    
    func testComparisonIsLikeUnsignedIntegerComparison() {
        for lhs in Self.patterns {
            for rhs in Self.patterns {
                let expectation: Signum = UX(load: lhs).compared(to: UX(load: rhs))
                Test().comparison(Count(raw: lhs), Count(raw: rhs), expectation, id: ComparableID())
            }
        }
    }
}
