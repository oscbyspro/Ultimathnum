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
// MARK: * Order
//*============================================================================*

final class OrderTests: XCTestCase {
    
    typealias T = Order
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInit() {
        Test().same(T(descending: false), T .ascending)
        Test().same(T(descending:  true), T.descending)
    }
    
    func testBitCast() {
        Test().same(Bit(raw: T .ascending), 0 as Bit)
        Test().same(Bit(raw: T.descending), 1 as Bit)
        Test().same(T  (raw: 0 as Bit), T .ascending)
        Test().same(T  (raw: 1 as Bit), T.descending)
    }
    
    func testComparison() {
        Test()   .same(T .ascending, T .ascending)
        Test().nonsame(T .ascending, T.descending)
        Test().nonsame(T.descending, T .ascending)
        Test()   .same(T.descending, T.descending)
    }
    
    func testEndianess() {
        #if _endian(little)
        Test()   .same(T.endianess, T .ascending)
        Test().nonsame(T.endianess, T.descending)
        #elseif _endian(big)
        Test().nonsame(T.endianess, T .ascending)
        Test()   .same(T.endianess, T.descending)
        #endif
    }
    
    func testReversed() {
        Test().same(T .ascending.reversed(), T.descending)
        Test().same(T.descending.reversed(), T .ascending)
    }
}
