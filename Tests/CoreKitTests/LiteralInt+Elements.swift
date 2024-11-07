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
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let  ascending: LiteralInt = 0x0f0e0d0c0b0a09080706050403020100
    static let descending: LiteralInt = 0x0f1f2f3f4f5f6f7f8f9fafbfcfdfefff
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("LiteralInt/appendix", .serialized, arguments: [
        
        Some(-8 as LiteralInt, yields: Bit.one ), // 000....1
        Some(-7 as LiteralInt, yields: Bit.one ), // 100....1
        Some(-6 as LiteralInt, yields: Bit.one ), // 010....1
        Some(-5 as LiteralInt, yields: Bit.one ), // 110....1
        Some(-4 as LiteralInt, yields: Bit.one ), // 00.....1
        Some(-3 as LiteralInt, yields: Bit.one ), // 10.....1
        Some(-2 as LiteralInt, yields: Bit.one ), // 0......1
        Some(-1 as LiteralInt, yields: Bit.one ), // .......1
        Some( 0 as LiteralInt, yields: Bit.zero), // .......0
        Some( 1 as LiteralInt, yields: Bit.zero), // 1......0
        Some( 2 as LiteralInt, yields: Bit.zero), // 01.....0
        Some( 3 as LiteralInt, yields: Bit.zero), // 11.....0
        Some( 4 as LiteralInt, yields: Bit.zero), // 001....0
        Some( 5 as LiteralInt, yields: Bit.zero), // 101....0
        Some( 6 as LiteralInt, yields: Bit.zero), // 011....0
        Some( 7 as LiteralInt, yields: Bit.zero), // 111....0
        
        Some(-0x80000000000000000000000000000000 as LiteralInt, yields: Bit.one ),
        Some( 0x7fffffffffffffffffffffffffffffff as LiteralInt, yields: Bit.zero),
        
    ])  func appendix(_ argument: Some<LiteralInt, Bit>) {
        #expect(argument.input.appendix == argument.output)
    }
    
    @Test("LiteralInt/subscript(_:) byte prefix", .serialized, arguments: [
        
        Many(-0000000000000000000000000000000001 as LiteralInt, yields:                [U8](repeating: U8.max, count: 32)),
        Many( 0000000000000000000000000000000000 as LiteralInt, yields:                [U8](repeating: U8.min, count: 32)),
        Many(-0xf0f1f2f3f4f5f6f7f8f9fafbfcfdff00 as LiteralInt, yields: [U8](0...15) + [U8](repeating: U8.max, count: 16)),
        Many( 0x0f0e0d0c0b0a09080706050403020100 as LiteralInt, yields: [U8](0...15) + [U8](repeating: U8.min, count: 16)),
        
    ])  func elements(_ argument: Many<LiteralInt, U8>) {
        let ratio: IX =  IX(size: UX.self) / IX(size: U8.self)
        for index: IX in IX.zero ..< IX(argument.output.count) {
            let word: UX = argument.input[UX(index / ratio)]
            let byte: U8 = U8(load: word >> (index % ratio * 8))
            let expectation: U8 = argument.output[Swift.Int(index)]
            #expect(byte == expectation)
        }
    }
}
