//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreIop
import CoreKit
import RandomIntIop
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Random Int x Stdlib
//*============================================================================*

@Suite struct RandomIntStdlibTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "RandomInt.Stdlib: metadata",
        Tag.List.tags(.documentation)
    )   func metadata() {
        #expect(MemoryLayout<RandomInt.Stdlib>.size == 0)
        #expect(RandomInt.Stdlib.self as Any is any Swift.RandomNumberGenerator.Type)
    }
    
    @Test(
        "RandomInt.Stdlib: prefix",
        Tag.List.tags(.documentation),
        TimeLimitTrait.timeLimit(.minutes(1)),
        arguments: CollectionOfOne(32)
    )   func prefix(count: Swift.Int) {
        
        var stdlib = RandomInt().stdlib()
        var uniques: Set<Swift.UInt64> = []
        
        while uniques.count < count {
            uniques.insert(stdlib.next())
        }
    }
}
