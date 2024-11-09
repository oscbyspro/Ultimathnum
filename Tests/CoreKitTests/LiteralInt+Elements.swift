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
// MARK: * Literal Int x Elements
//*============================================================================*

@Suite struct LiteralIntTestsOnElements {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "LiteralInt/elements: appendix",
        Tag.List.tags(.documentation),
        ParallelizationTrait.serialized,
        arguments: Array<(LiteralInt, Bit)>([
        
        (LiteralInt(-8), Bit.one ), // 000....1
        (LiteralInt(-7), Bit.one ), // 100....1
        (LiteralInt(-6), Bit.one ), // 010....1
        (LiteralInt(-5), Bit.one ), // 110....1
        (LiteralInt(-4), Bit.one ), // 00.....1
        (LiteralInt(-3), Bit.one ), // 10.....1
        (LiteralInt(-2), Bit.one ), // 0......1
        (LiteralInt(-1), Bit.one ), // .......1
        (LiteralInt( 0), Bit.zero), // .......0
        (LiteralInt( 1), Bit.zero), // 1......0
        (LiteralInt( 2), Bit.zero), // 01.....0
        (LiteralInt( 3), Bit.zero), // 11.....0
        (LiteralInt( 4), Bit.zero), // 001....0
        (LiteralInt( 5), Bit.zero), // 101....0
        (LiteralInt( 6), Bit.zero), // 011....0
        (LiteralInt( 7), Bit.zero), // 111....0
        
        (LiteralInt(-0x80000000000000000000000000000000), Bit.one ),
        (LiteralInt( 0x7fffffffffffffffffffffffffffffff), Bit.zero),
        
    ])) func appendix(instance: LiteralInt, expectation: Bit) {
        #expect(instance.appendix == expectation)
    }
    
    @Test(
        "LiteralInt/elements: subscript(_:) byte prefix",
        Tag.List.tags(.documentation),
        ParallelizationTrait.serialized,
        arguments: Array<Many<LiteralInt, U8>>([
        
        Many(LiteralInt(-0000000000000000000000000000000001), yields:                [U8](repeating: U8.max, count: 32)),
        Many(LiteralInt( 0000000000000000000000000000000000), yields:                [U8](repeating: U8.min, count: 32)),
        Many(LiteralInt(-0xf0f1f2f3f4f5f6f7f8f9fafbfcfdff00), yields: [U8](0...15) + [U8](repeating: U8.max, count: 16)),
        Many(LiteralInt( 0x0f0e0d0c0b0a09080706050403020100), yields: [U8](0...15) + [U8](repeating: U8.min, count: 16)),
        
    ])) func elements(argument: Many<LiteralInt, U8>) {
        let ratio: IX =  IX(size: UX.self) / IX(size: U8.self)
        for index: IX in IX.zero ..< IX(argument.output.count) {
            let word: UX = argument.input[UX(index / ratio)]
            let byte: U8 = U8(load: word >> (index % ratio * 8))
            let expectation: U8 = argument.output[Swift.Int(index)]
            #expect(byte == expectation)
        }
    }
}
