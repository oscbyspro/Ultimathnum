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
// MARK: * Optional
//*============================================================================*

final class OptionalTests: XCTestCase {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBitCast() {
        //=--------------------------------------=
        typealias S = Optional<IX>
        typealias M = Optional<UX>
        //=--------------------------------------=
        Test().same(S(raw: S.none),     S.none)
        Test().same(S(raw: M.none),     S.none)
        Test().same(M(raw: S.none),     M.none)
        Test().same(M(raw: M.none),     M.none)
        Test().same(S(raw: S.some(-1)), S.some(-1))
        Test().same(S(raw: M.some(~1)), S.some(-2))
        Test().same(M(raw: S.some(-3)), M.some(~2))
        Test().same(M(raw: M.some(~3)), M.some(~3))
    }
}
