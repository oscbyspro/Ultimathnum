//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import Foundation
import TestKit

//*============================================================================*
// MARK: * Text Int x Metadata
//*============================================================================*

@Suite(.serialized) struct TextIntTestsOnMetadata {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "TextInt/metadata: magicLog2x32",
        Tag.List.tags(.documentation, .important, .unofficial)
    )   func magicLog2x32() throws {
        
        try #require(TextInt.magicLog2x32[0] == 32)
        try #require(TextInt.magicLog2x32[1] == 05)
        
        for radix: Swift.Int in 2 ... 36 {
            let expectation = Swift.Int(floor(32 * log2(Swift.Double(radix))))
            try #require(TextInt.magicLog2x32[radix] == U8(IX((expectation))))
        }
    }
    
    @Test(
        "TextInt/metadata: magicLog2x32 max length",
        Tag.List.tags(.documentation, .important, .unofficial),
        ConditionTrait.enabled(if: IX.size == Count(64)),
        arguments: IX(2)...IX(36), CollectionOfOne(IX(load: 288230376151711743 as I64))
    )   func magicLog2x32MaxLength(radix: IX, length: IX) {
        
        #expect(TextInt.capacity(radix, length: Natural(length + 0)) != nil)
        #expect(TextInt.capacity(radix, length: Natural(length + 1)) == nil)
    }
    
    @Test(
        "TextInt/metadata: magicLog2x32 decimals",
        Tag.List.tags(.documentation, .important, .unofficial),
        ConditionTrait.enabled(if: IX.size == Count(64)),
        arguments: Array<(U64, IX, IX)>.infer([
            
        (U64(00000000000000000000), IX( 1), IX( 1)),
        (U64(1                   ), IX( 1), IX( 1)),
        (U64(12                  ), IX( 2), IX( 2)),
        (U64(123                 ), IX( 3), IX( 3)),
        (U64(1234                ), IX( 4), IX( 4)),
        (U64(12345               ), IX( 5), IX( 5)),
        (U64(123456              ), IX( 6), IX( 6)),
        (U64(1234567             ), IX( 7), IX( 7)),
        (U64(12345678            ), IX( 8), IX( 8)),
        (U64(123456789           ), IX( 9), IX( 9)),
        (U64(1234567890          ), IX(10), IX(10)),
        (U64(12345678901         ), IX(11), IX(11)),
        (U64(123456789012        ), IX(12), IX(12)),
        (U64(1234567890123       ), IX(13), IX(13)),
        (U64(12345678901234      ), IX(14), IX(14)),
        (U64(123456789012345     ), IX(15), IX(15)),
        (U64(1234567890123456    ), IX(16), IX(16)),
        (U64(12345678901234567   ), IX(17), IX(17)),
        (U64(123456789012345678  ), IX(18), IX(18)),
        (U64(1234567890123456789 ), IX(19), IX(19)),
        (U64(12345678901234567890), IX(20), IX(20)),
        (U64(9                   ), IX( 1), IX( 2)), // 1
        (U64(99                  ), IX( 2), IX( 3)), // 1
        (U64(999                 ), IX( 3), IX( 4)), // 1
        (U64(9999                ), IX( 4), IX( 5)), // 1
        (U64(99999               ), IX( 5), IX( 6)), // 1
        (U64(999999              ), IX( 6), IX( 7)), // 1
        (U64(9999999             ), IX( 7), IX( 8)), // 1
        (U64(99999999            ), IX( 8), IX( 9)), // 1
        (U64(999999999           ), IX( 9), IX(10)), // 1
        (U64(9999999999          ), IX(10), IX(11)), // 1
        (U64(99999999999         ), IX(11), IX(12)), // 1
        (U64(999999999999        ), IX(12), IX(13)), // 1
        (U64(9999999999999       ), IX(13), IX(14)), // 1
        (U64(99999999999999      ), IX(14), IX(15)), // 1
        (U64(999999999999999     ), IX(15), IX(16)), // 1
        (U64(9999999999999999    ), IX(16), IX(17)), // 1
        (U64(99999999999999999   ), IX(17), IX(18)), // 1
        (U64(999999999999999999  ), IX(18), IX(19)), // 1
        (U64(9999999999999999999 ), IX(19), IX(20)), // 1
        
    ])) func magicLog2x32MaxLength(value: U64, count: IX, expectation: IX) {
        
        let length = IX(raw: value.nondescending(Bit.zero))
        let result = TextInt.capacity(10, length: Natural(length))
        
        #expect(result == expectation)
        #expect(IX(value.description.utf8.count) == count)
    }
}
