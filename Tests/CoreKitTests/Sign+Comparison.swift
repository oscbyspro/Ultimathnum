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
// MARK: * Sign x Comparison
//*============================================================================*

@Suite struct SignTestsOnComparison {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(arguments: [
        
        Some((lhs: Sign.plus,  rhs: Sign.plus ), yields: true ),
        Some((lhs: Sign.plus,  rhs: Sign.minus), yields: false),
        Some((lhs: Sign.minus, rhs: Sign.plus ), yields: false),
        Some((lhs: Sign.minus, rhs: Sign.minus), yields: true ),
        
    ]) func compare(_ expectation: Some<(lhs: Sign, rhs: Sign), Bool>) {
        Ɣexpect(expectation.input.lhs, equals: expectation.input.rhs, is: expectation.output)
    }
}
