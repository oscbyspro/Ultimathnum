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
// MARK: * Text Int x Letters
//*============================================================================*

final class TextIntTestsOnLetters: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
 
    func testInitBool() {
        Test().same(TextInt.Letters(uppercase: false), TextInt.Letters.lowercase)
        Test().same(TextInt.Letters(uppercase: true ), TextInt.Letters.uppercase)
    }
    
    func testGetStart() {
        Test().same(TextInt.Letters.lowercase.start, U8(UInt8(ascii: "a")))
        Test().same(TextInt.Letters.uppercase.start, U8(UInt8(ascii: "A")))
    }
}
