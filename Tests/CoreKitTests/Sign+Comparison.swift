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
    
    @Test(.serialized, arguments: [
        
        Some(Sign.plus,  Sign.plus,  yields: true ),
        Some(Sign.plus,  Sign.minus, yields: false),
        Some(Sign.minus, Sign.plus,  yields: false),
        Some(Sign.minus, Sign.minus, yields: true ),
        
    ])  func compare(_ argument: Some<Sign, Sign, Bool>) {
        Ɣexpect(argument.0, equals: argument.1, is: argument.output)
    }
}
