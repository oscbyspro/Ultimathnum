//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Random Int
//*============================================================================*

@Suite struct RandomIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "RandomInt: metadata",
        Tag.List.tags(.documentation)
    )   func metadata() {
        #expect(MemoryLayout<RandomInt>.size == 0)
        #expect(MemoryLayout<RandomInt.Element>.size == 8)
        #expect(RandomInt.self as Any is any Randomness.Type)
    }
    
    @Test(
        "RandomInt: prefix",
        Tag.List.tags(.documentation),
        TimeLimitTrait.timeLimit(.minutes(1)),
        arguments: CollectionOfOne(32)
    )   func prefix(count: Swift.Int) {
        
        var stdlib = RandomInt()
        var uniques: Set<U64> = []
        
        while uniques.count < 32 {
            uniques.insert(stdlib.next())
        }
    }
}
