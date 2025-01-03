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

@Suite(.serialized) struct OrderTestsOnComparison {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Order/comparison: Self vs Self",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Order, Order, Bool)>.infer([
        
        (Order.ascending,  Order.ascending,  true ),
        (Order.ascending,  Order.descending, false),
        (Order.descending, Order.ascending,  false),
        (Order.descending, Order.descending, true ),
        
    ])) func comparison(lhs: Order, rhs: Order, expectation: Bool) {
        Ɣexpect(lhs, equals: rhs, is: expectation)
    }
}
