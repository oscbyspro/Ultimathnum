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
// MARK: * Fuzzer Int
//*============================================================================*

@Suite(.serialized) struct FuzzerIntTests {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "FuzzerInt: metadata",
        Tag.List.tags(.documentation)
    )   func metadata() {
        #expect(MemoryLayout<FuzzerInt>.size == 8)
        #expect(MemoryLayout<FuzzerInt.Element>.size == 8)
        #expect(FuzzerInt.self as Any is any Randomness.Type)
    }
    
    @Test(
        "FuzzerInt: prefix",
        Tag.List.tags(.documentation, .unofficial),
        arguments: Array<(I64, [U64])>.infer([
        
        ( 0 as I64, [0xe220a8397b1dcdaf, 0x6e789e6aa1b965f4, 0x06c45d188009454f, 0xf88bb8a8724c81ec] as [U64]),
        ( 1 as I64, [0x910a2dec89025cc1, 0xbeeb8da1658eec67, 0xf893a2eefb32555e, 0x71c18690ee42c90b] as [U64]),
        (~1 as I64, [0xf3203e9039f4a821, 0xba56949915dcf9e9, 0xd0d5127a96e8d90d, 0x1ef156bb76650c37] as [U64]),
        (~0 as I64, [0xe4d971771b652c20, 0xe99ff867dbf682c9, 0x382ff84cb27281e9, 0x6d1db36ccba982d2] as [U64]),
        
    ])) func prefix(
        seed: I64, expectation: [U64]
    )   throws {
        
        var randomness = FuzzerInt(seed: U64(raw: seed))
        for element in expectation {
            try #require(randomness.next() == element)
        }
    }
}
