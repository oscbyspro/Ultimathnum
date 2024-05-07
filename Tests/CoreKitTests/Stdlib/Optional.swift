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
        func whereIs<B>(_ type: B.Type) where B: BinaryInteger {
            typealias T = Optional<B>
            typealias S = Optional<B.Signitude>
            typealias M = Optional<B.Magnitude>
            
            Test().same(T(raw: S.none),     T.none)
            Test().same(T(raw: M.none),     T.none)
            Test().same(T(raw: S.some(~3)), T.some(~3))
            Test().same(T(raw: M.some(~5)), T.some(~5))
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
}
