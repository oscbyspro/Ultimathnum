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

@Suite(.serialized) struct CountTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Count/text: finite",
        Tag.List.tags(.documentation),
        arguments: Array<(IX, String)>.infer([
        
        (IX( 0), String("0")),
        (IX( 1), String("1")),
        (IX( 2), String("2")),
        (IX( 3), String("3")),
        (IX.max, String("\(IX.max)")),
        
    ])) func finite(pattern: IX, expectation: String) {
        Ɣexpect(Count(raw: pattern), description: expectation)
    }
    
    @Test(
        "Count/text: infinite",
        Tag.List.tags(.documentation),
        arguments: Array<(IX, String)>.infer([
        
        (IX(~0), String("log2(&0+1)"  )),
        (IX(~1), String("log2(&0+1)-1")),
        (IX(~2), String("log2(&0+1)-2")),
        (IX(~3), String("log2(&0+1)-3")),
        (IX.min, String("log2(&0+1)-\(IX.max)")),
        
    ])) func infinite(pattern: IX, expectation: String) {
        Ɣexpect(Count(raw: pattern), description: expectation)
    }
}
