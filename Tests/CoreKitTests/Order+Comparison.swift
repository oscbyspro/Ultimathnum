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
    
    @Test(arguments: [
        
        Some((lhs: Order.ascending,  rhs: Order.ascending ), yields: true ),
        Some((lhs: Order.ascending,  rhs: Order.descending), yields: false),
        Some((lhs: Order.descending, rhs: Order.ascending ), yields: false),
        Some((lhs: Order.descending, rhs: Order.descending), yields: true ),
        
    ]) func compare(_ expectation: Some<(lhs: Order, rhs: Order), Bool>) {
        expect(expectation.input.lhs, equals: expectation.input.rhs, is: expectation.output)
    }
}
