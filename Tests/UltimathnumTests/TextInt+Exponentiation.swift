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

final class TextIntTestsOnExponentiation: XCTestCase {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testEachRadixThrough1024() throws {
        let perfect256: [UX] = [2, 4, 16, 256]
        //=--------------------------------------=
        // test: the minimum radix is 2
        //=--------------------------------------=
        Test().failure(try TextInt.Exponentiation(0), TextInt.Error.invalid)
        Test().failure(try TextInt.Exponentiation(1), TextInt.Error.invalid)
        //=--------------------------------------=
        for radix: UX in 2...1024 {
            let exponentiation = try TextInt.Exponentiation(radix)
            Test().more(exponentiation.exponent, 1 as IX)
            //=----------------------------------=
            // test: perfect or imperfect
            //=----------------------------------=
            if  let radixLog2Log2 = perfect256.firstIndex(of: radix) {
                Test().same(exponentiation.power,    UX.zero)
                Test().same(exponentiation.exponent, IX(size: UX.self) >> IX(radixLog2Log2))
            }   else {
                Test().nonsame(exponentiation.power, UX.zero)
            }
        }
    }
}
