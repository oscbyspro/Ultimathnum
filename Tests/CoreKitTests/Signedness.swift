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
// MARK: * Signedness
//*============================================================================*

final class SignednessTests: XCTestCase {
    
    typealias T = Signedness
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsSigned() {
        Test().same(T  .signed   .isSigned,  true)
        Test().same(T  .signed, T(isSigned:  true))
        Test().same(T.unsigned   .isSigned, false)
        Test().same(T.unsigned, T(isSigned: false))
    }
    
    func testBitCast() {
        Test().same(Bit(raw: T  .signed), 1 as Bit)
        Test().same(Bit(raw: T.unsigned), 0 as Bit)
    }
}
