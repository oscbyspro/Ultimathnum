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
// MARK: * Order x Comparison
//*============================================================================*

@Suite struct OrderTestsOnComparison {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(.serialized, arguments: [
        
        Some(Order.ascending,  Order.ascending,  yields: true ),
        Some(Order.ascending,  Order.descending, yields: false),
        Some(Order.descending, Order.ascending,  yields: false),
        Some(Order.descending, Order.descending, yields: true ),
        
    ])  func compare(_ argument: Some<Order, Order, Bool>) {
        Ɣexpect(argument.0, equals: argument.1, is: argument.output)
    }
}
