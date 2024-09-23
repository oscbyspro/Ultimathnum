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
// MARK: * Signedness x Comparison
//*============================================================================*

@Suite struct SignednessTestsOnComparison {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(arguments: [
        
        Some((lhs: Signedness.unsigned, rhs: Signedness.unsigned), yields: true ),
        Some((lhs: Signedness.unsigned, rhs: Signedness  .signed), yields: false),
        Some((lhs: Signedness  .signed, rhs: Signedness.unsigned), yields: false),
        Some((lhs: Signedness  .signed, rhs: Signedness  .signed), yields: true ),
        
    ]) func compare(_ expectation: Some<(lhs: Signedness, rhs: Signedness), Bool>) {
        Ɣexpect(expectation.input.lhs, equals: expectation.input.rhs, is: expectation.output)
    }
}
