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
    
    func testInit() {
        Test().same(T(signed: false), T.unsigned)
        Test().same(T(signed:  true), T  .signed)
    }
    
    func testBitCast() {
        Test().same(Bit(raw: T.unsigned), 0 as Bit)
        Test().same(Bit(raw: T  .signed), 1 as Bit)
        Test().same(T  (raw: 0 as Bit), T.unsigned)
        Test().same(T  (raw: 1 as Bit), T  .signed)
    }
    
    func testComparison() {
        Test()   .same(T.unsigned, T.unsigned)
        Test().nonsame(T.unsigned, T  .signed)
        Test().nonsame(T  .signed, T.unsigned)
        Test()   .same(T  .signed, T  .signed)
    }
}
