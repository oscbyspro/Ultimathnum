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
    
    @Test(
        "Order: descending",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Order, Bool)>([
        
        (Order.ascending,  false),
        (Order.descending, true ),
        
    ])) func descending(instance: Order, expectation: Bool) {
        #expect(instance == Order(descending: expectation))
    }
    
    @Test(
        "Order: endianness",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: CollectionOfOne(Order.endianess)
    )   func endianness(instance: Order) {
        #if _endian(little)
        #expect(Order.endianess == Order.ascending)
        #else
        #expect(Order.endianess == Order.descending)
        #endif
    }
    
    @Test(
        "Order: reversed",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Order, Order)>([
        
        (Order.ascending,  Order.descending),
        (Order.descending, Order.ascending ),
        
    ])) func reversed(instance: Order, expectation: Order) {
        #expect(instance.reversed() == expectation)
    }
}
