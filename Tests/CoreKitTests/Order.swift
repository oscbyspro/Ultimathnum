//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit2

//*============================================================================*
// MARK: * Order
//*============================================================================*

@Suite struct OrderTests {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(arguments: [
        
        Some(Order.ascending,  yields: false),
        Some(Order.descending, yields: true ),
        
    ]) func descending(_ expectation: Some<Order, Bool>) {
        #expect(Order(descending: expectation.output) == expectation.input)
    }
    
    #if _endian(little)
    @Test("Order.endianness (↑)", arguments: CollectionOfOne(Order.ascending ))
    #else
    @Test("Order.endianness (↓)", arguments: CollectionOfOne(Order.descending))
    #endif
    func endianness(_ expectation: Order) {
        #expect(Order.endianess == expectation)
    }
    
    @Test(arguments: [
        
        Some(Order.ascending,  yields: Order.descending),
        Some(Order.descending, yields: Order.ascending ),
        
    ]) func reversed(_ expectation: Some<Order, Order>) {
        #expect(expectation.input.reversed() == expectation.output)
    }
}
