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
        "Count/text: description of natural",
        Tag.List.tags(.documentation),
        ParallelizationTrait.serialized,
        arguments: Array<(Count, String)>([
        
        (Count(IX( 0)), "0"),
        (Count(IX( 1)), "1"),
        (Count(IX( 2)), "2"),
        (Count(IX( 3)), "3"),
        (Count(IX.max), "\(IX.max)"),
        
    ])) func descriptionOfNatural(instance: Count, expectation: String) {
        Ɣexpect(instance, description: expectation)
    }
    
    @Test(
        "Count/text: description of infinite",
        Tag.List.tags(.documentation),
        ParallelizationTrait.serialized,
        arguments: Array<(Count, String)>([
        
        (Count(raw: IX(~0)), "log2(&0+1)"  ),
        (Count(raw: IX(~1)), "log2(&0+1)-1"),
        (Count(raw: IX(~2)), "log2(&0+1)-2"),
        (Count(raw: IX(~3)), "log2(&0+1)-3"),
        (Count(raw: IX.min), "log2(&0+1)-\(IX.max)"),
        
    ])) func descriptionOfInfinite(instance: Count, expectation: String) {
        Ɣexpect(instance, description: expectation)
    }
}
