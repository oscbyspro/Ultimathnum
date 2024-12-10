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
        "TextInt/metadata: magicLog2x32 radix 10",
        Tag.List.tags(.documentation, .important, .unofficial),
        ConditionTrait.enabled(if: IX.size == Count(64)),
        arguments: Array<(U64, IX, IX)>.infer([
            
        (U64(00000000000000000000), IX( 1), IX( 1)),
        (U64(1                   ), IX( 1), IX( 1)),
        (U64(10                  ), IX( 2), IX( 2)),
        (U64(100                 ), IX( 3), IX( 3)),
        (U64(1000                ), IX( 4), IX( 4)),
        (U64(10000               ), IX( 5), IX( 5)),
        (U64(100000              ), IX( 6), IX( 6)),
        (U64(1000000             ), IX( 7), IX( 7)),
        (U64(10000000            ), IX( 8), IX( 8)),
        (U64(100000000           ), IX( 9), IX( 9)),
        (U64(1000000000          ), IX(10), IX(10)),
        (U64(10000000000         ), IX(11), IX(11)),
        (U64(100000000000        ), IX(12), IX(12)),
        (U64(1000000000000       ), IX(13), IX(13)),
        (U64(10000000000000      ), IX(14), IX(14)),
        (U64(100000000000000     ), IX(15), IX(15)),
        (U64(1000000000000000    ), IX(16), IX(16)),
        (U64(10000000000000000   ), IX(17), IX(17)),
        (U64(100000000000000000  ), IX(18), IX(18)),
        (U64(1000000000000000000 ), IX(19), IX(19)),
        (U64(10000000000000000000), IX(20), IX(20)),
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
        
    ])) func magicLog2x32Radix10(value: U64, count: IX, capacity: IX) throws {
        
        let radix: IX = 10
        let coder: TextInt = try #require(TextInt.radix(radix))
        let length = IX(raw: value.nondescending(((Bit.zero))))
        #expect(count == IX( value.description(using: coder).utf8.count))
        #expect(capacity == TextInt.capacity(radix, length: Natural(length)))
    }
    
    @Test(
        "TextInt/metadata: magicLog2x32 radix 16",
        Tag.List.tags(.documentation, .important, .unofficial),
        ConditionTrait.enabled(if: IX.size == Count(64)),
        arguments: Array<(U64, IX, IX)>.infer([
            
        (U64(0x0000000000000000), IX( 1), IX( 1)),
        (U64(0x1               ), IX( 1), IX( 1)),
        (U64(0x10              ), IX( 2), IX( 2)),
        (U64(0x100             ), IX( 3), IX( 3)),
        (U64(0x1000            ), IX( 4), IX( 4)),
        (U64(0x10000           ), IX( 5), IX( 5)),
        (U64(0x100000          ), IX( 6), IX( 6)),
        (U64(0x1000000         ), IX( 7), IX( 7)),
        (U64(0x10000000        ), IX( 8), IX( 8)),
        (U64(0x100000000       ), IX( 9), IX( 9)),
        (U64(0x1000000000      ), IX(10), IX(10)),
        (U64(0x10000000000     ), IX(11), IX(11)),
        (U64(0x100000000000    ), IX(12), IX(12)),
        (U64(0x1000000000000   ), IX(13), IX(13)),
        (U64(0x10000000000000  ), IX(14), IX(14)),
        (U64(0x100000000000000 ), IX(15), IX(15)),
        (U64(0x1000000000000000), IX(16), IX(16)),
        (U64(0xf               ), IX( 1), IX( 1)),
        (U64(0xff              ), IX( 2), IX( 2)),
        (U64(0xfff             ), IX( 3), IX( 3)),
        (U64(0xffff            ), IX( 4), IX( 4)),
        (U64(0xfffff           ), IX( 5), IX( 5)),
        (U64(0xffffff          ), IX( 6), IX( 6)),
        (U64(0xfffffff         ), IX( 7), IX( 7)),
        (U64(0xffffffff        ), IX( 8), IX( 8)),
        (U64(0xfffffffff       ), IX( 9), IX( 9)),
        (U64(0xffffffffff      ), IX(10), IX(10)),
        (U64(0xfffffffffff     ), IX(11), IX(11)),
        (U64(0xffffffffffff    ), IX(12), IX(12)),
        (U64(0xfffffffffffff   ), IX(13), IX(13)),
        (U64(0xffffffffffffff  ), IX(14), IX(14)),
        (U64(0xfffffffffffffff ), IX(15), IX(15)),
        (U64(0xffffffffffffffff), IX(16), IX(16)),
        
    ])) func magicLog2x32Radix16(value: U64, count: IX, capacity: IX) throws {
        
        let radix: IX = 16
        let coder: TextInt = try #require(TextInt.radix(radix))
        let length = IX(raw: value.nondescending(((Bit.zero))))
        #expect(count == IX( value.description(using: coder).utf8.count))
        #expect(capacity == TextInt.capacity(radix, length: Natural(length)))
    }
}
