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
// MARK: * Strict Unsigned Integer x Sub Sequence x Multiplication
//*============================================================================*

final class StrictUnsignedIntegerSubSequenceTestsOnMultiplication: XCTestCase {
    
    private typealias X   = [UX]
    private typealias X64 = [U64]
    private typealias X32 = [U32]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSomeSome() {
        checkSomeSome([~0, ~0, ~0, ~0] as X,  0,  0, [ 0,  0,  0,  0] as X,  0)
        checkSomeSome([~0, ~0, ~0, ~0] as X,  0, ~0, [~0,  0,  0,  0] as X,  0)
        checkSomeSome([~0, ~0, ~0, ~0] as X, ~0,  0, [ 1, ~0, ~0, ~0] as X, ~1)
        checkSomeSome([~0, ~0, ~0, ~0] as X, ~0, ~0, [ 0,  0,  0,  0] as X, ~0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    private func checkSomeSome(
    _ base: [UX], _ multiplier: UX, _ increment: UX, _ product: [UX], _ high: UX,
    file: StaticString = #file, line: UInt = #line) {
        //=------------------------------------------=
        // multiplication: some + some
        //=------------------------------------------=
        brr: do {
            var lhs = base
            let top = SUISS.multiply(&lhs, by: multiplier, add: increment)
            XCTAssertEqual(lhs, product, file: file, line: line)
            XCTAssertEqual(top, high,    file: file, line: line)
        }
    }
}
