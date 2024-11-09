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
// MARK: * Order x Comparison
//*============================================================================*

@Suite struct OrderTestsOnComparison {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Order/comparison: Order vs Order",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Order, Order, Bool)>([
        
        (Order.ascending,  Order.ascending,  true ),
        (Order.ascending,  Order.descending, false),
        (Order.descending, Order.ascending,  false),
        (Order.descending, Order.descending, true ),
        
    ])) func comparison(lhs: Order, rhs: Order, expectation: Bool) {
        Ɣexpect(lhs, equals: rhs, is: expectation)
    }
}
