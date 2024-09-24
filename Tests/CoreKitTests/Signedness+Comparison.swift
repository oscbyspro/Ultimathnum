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
        
        Some(Signedness.unsigned, Signedness.unsigned, yields: true ),
        Some(Signedness.unsigned, Signedness  .signed, yields: false),
        Some(Signedness  .signed, Signedness.unsigned, yields: false),
        Some(Signedness  .signed, Signedness  .signed, yields: true ),
        
    ]) func compare(_ argument: Some<Signedness, Signedness, Bool>) {
        Ɣexpect(argument.0, equals: argument.1, is: argument.output)
    }
}
