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
// MARK: * Division x Validation
//*============================================================================*

final class DivisionTestsOnValidation: XCTestCase {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
 
    func testExactly() {
        func whereIs<Q, R>(_ quotient: Q.Type, _ remainder: R.Type) where Q: SystemsInteger, R: SystemsInteger {
            let patterns =  I8(-2)...I8(2)
            for quotient in patterns.lazy.map(Q.init(load:)) {
                for remainder in patterns.lazy.map(R.init(load:)) {
                    let error = !remainder.isZero
                    let division = Division(quotient: quotient, remainder: remainder)
                    Test().same(division            .exactly(), Fallible(quotient, error: error))
                    Test().same(division.veto(false).exactly(), Fallible(quotient, error: error))
                    Test().same(division.veto(true ).exactly(), Fallible(quotient, error: true ))
                }
            }
        }
        
        for quotient in coreSystemsIntegers {
            for remainder in coreSystemsIntegers {
                whereIs(quotient, remainder)
            }
        }
    }
}
