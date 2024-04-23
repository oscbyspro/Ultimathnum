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
// MARK: * Text Int x Exponentiation
//*============================================================================*

extension TextIntTests {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testExponentiation() {
        //=--------------------------------------=
        self.continueAfterFailure = false
        let perfect256: [UX] = [2, 4, 16, 256]
        //=--------------------------------------=
        // test: the minimum radix is 2
        //=--------------------------------------=
        Test().failure({ try T.Exponentiation(0) }, E.invalid)
        Test().failure({ try T.Exponentiation(1) }, E.invalid)
        //=--------------------------------------=
        for radix: UX in 2 ... 256 {
            guard let solution = Test().success({ try T.Exponentiation(radix) }) else { break }
            //=----------------------------------=
            Test().more(solution.exponent, 1 as IX)
            //=----------------------------------=
            // test: perfect or imperfect
            //=----------------------------------=
            if  perfect256.contains(radix) {
                Test().same   (solution.power, UX.zero)
            }   else {
                Test().nonsame(solution.power, UX.zero)
            }
        }
    }
}
