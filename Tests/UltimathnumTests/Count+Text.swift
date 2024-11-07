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
// MARK: * Count x Text
//*============================================================================*

@Suite struct CountTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Count/description - natural", .serialized, arguments: [
        
        Some(Count(IX( 0)), yields: "0"),
        Some(Count(IX( 1)), yields: "1"),
        Some(Count(IX( 2)), yields: "2"),
        Some(Count(IX( 3)), yields: "3"),
        Some(Count(IX.max), yields: "\(IX.max)"),
        
    ])  func descriptionAsNatural(_ argument: Some<Count, String>) {
        Ɣexpect(argument.input, description: argument.output)
    }
    
    @Test("Count/description - infinite", .serialized, arguments: [
        
        Some(Count(raw: IX(~0)), yields: "log2(&0+1)"  ),
        Some(Count(raw: IX(~1)), yields: "log2(&0+1)-1"),
        Some(Count(raw: IX(~2)), yields: "log2(&0+1)-2"),
        Some(Count(raw: IX(~3)), yields: "log2(&0+1)-3"),
        Some(Count(raw: IX.min), yields: "log2(&0+1)-\(IX.max)"),
        
    ])  func descriptionAsInfinite(_ argument: Some<Count, String>) {
        Ɣexpect(argument.input, description: argument.output)
    }
}
