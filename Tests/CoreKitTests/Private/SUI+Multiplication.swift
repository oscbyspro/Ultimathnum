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
        checkSomeSome([~0, ~0, ~0, ~0] as X,  0 as UX,  0 as UX, [ 0,  0,  0,  0] as X,  0 as UX)
        checkSomeSome([~0, ~0, ~0, ~0] as X,  0 as UX, ~0 as UX, [~0,  0,  0,  0] as X,  0 as UX)
        checkSomeSome([~0, ~0, ~0, ~0] as X, ~0 as UX,  0 as UX, [ 1, ~0, ~0, ~0] as X, ~1 as UX)
        checkSomeSome([~0, ~0, ~0, ~0] as X, ~0 as UX, ~0 as UX, [ 0,  0,  0,  0] as X, ~0 as UX)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    private func checkSomeSome(
        _ base: [UX], 
        _ multiplier: UX,
        _ increment: UX, 
        _ product: [UX],
        _ high: UX,
        _ test: Test = .init()
    ) {
        //=------------------------------------------=
        // multiplication: some + some
        //=------------------------------------------=
        brr: do {
            var i = base
            let o = SUISS.multiply(&i, by: multiplier, add: increment)
            test.same(i, product)
            test.same(o, high)
        }
    }
}
