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
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInit() {
        Test().same(Order(descending: false), Order .ascending)
        Test().same(Order(descending:  true), Order.descending)
    }
    
    func testBitCast() {
        Test().same(Bit(raw: Order .ascending), Bit.zero)
        Test().same(Bit(raw: Order.descending), Bit.one )
        Test().same(Order(raw: Bit.zero), Order .ascending)
        Test().same(Order(raw: Bit.one ), Order.descending)
    }
    
    func testComparison() {
        Test()   .same(Order .ascending, Order .ascending)
        Test().nonsame(Order .ascending, Order.descending)
        Test().nonsame(Order.descending, Order .ascending)
        Test()   .same(Order.descending, Order.descending)
    }
    
    func testEndianess() {
        #if _endian(little)
        Test()   .same(Order.endianess, Order .ascending)
        Test().nonsame(Order.endianess, Order.descending)
        #elseif _endian(big)
        Test().nonsame(Order.endianess, Order .ascending)
        Test()   .same(Order.endianess, Order.descending)
        #endif
    }
    
    func testReversed() {
        Test().same(Order .ascending.reversed(), Order.descending)
        Test().same(Order.descending.reversed(), Order .ascending)
    }
}
