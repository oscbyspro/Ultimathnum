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

@Suite struct OrderTests {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(.serialized, arguments: [
        
        Some(Order.ascending,  yields: false),
        Some(Order.descending, yields: true ),
        
    ])  func descending(_ argument: Some<Order, Bool>) {
        #expect(argument.input == Order(descending: argument.output))
    }
    
    #if _endian(little)
    @Test("Order.endianness (↑)", arguments: CollectionOfOne(Order.ascending ))
    #else
    @Test("Order.endianness (↓)", arguments: CollectionOfOne(Order.descending))
    #endif
    func endianness(_ argument: Order) {
        #expect(Order.endianess == argument)
    }
    
    @Test(.serialized, arguments: [
        
        Some(Order.ascending,  yields: Order.descending),
        Some(Order.descending, yields: Order.ascending ),
        
    ])  func reversed(_ argument: Some<Order, Order>) {
        #expect(argument.input.reversed() == argument.output)
    }
}
