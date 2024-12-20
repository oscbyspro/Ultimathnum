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
// MARK: * Static Big Int x Comparison
//*============================================================================*

@Suite(.serialized) struct StaticBigIntTestsOnComparison {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "StaticBigInt/comparison: signum()",
        Tag.List.tags(.documentation),
        arguments: Array<(StaticBigInt, Int)>.infer([
        
        (StaticBigInt(-8), Int(-1)), // 000....1
        (StaticBigInt(-7), Int(-1)), // 100....1
        (StaticBigInt(-6), Int(-1)), // 010....1
        (StaticBigInt(-5), Int(-1)), // 110....1
        (StaticBigInt(-4), Int(-1)), // 00.....1
        (StaticBigInt(-3), Int(-1)), // 10.....1
        (StaticBigInt(-2), Int(-1)), // 0......1
        (StaticBigInt(-1), Int(-1)), // .......1
        (StaticBigInt( 0), Int( 0)), // .......0
        (StaticBigInt( 1), Int( 1)), // 1......0
        (StaticBigInt( 2), Int( 1)), // 01.....0
        (StaticBigInt( 3), Int( 1)), // 11.....0
        (StaticBigInt( 4), Int( 1)), // 001....0
        (StaticBigInt( 5), Int( 1)), // 101....0
        (StaticBigInt( 6), Int( 1)), // 011....0
        (StaticBigInt( 7), Int( 1)), // 111....0
        
        (StaticBigInt(-0x80000000000000000000000000000000), Int(-1)),
        (StaticBigInt( 0x7fffffffffffffffffffffffffffffff), Int( 1)),
        
    ])) func signum(instance: StaticBigInt, expectation: Int) {
        #expect(instance.signum() == expectation)
    }
}

//*============================================================================*
// MARK: * Static Big Int x Count
//*============================================================================*

@Suite(.serialized) struct StaticBigIntTestsOnCount {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "StaticBigInt/count: bitWidth",
        Tag.List.tags(.documentation),
        arguments: Array<(StaticBigInt, Int)>.infer([
        
        (StaticBigInt(-8), Int(4)), // 000....1
        (StaticBigInt(-7), Int(4)), // 100....1
        (StaticBigInt(-6), Int(4)), // 010....1
        (StaticBigInt(-5), Int(4)), // 110....1
        (StaticBigInt(-4), Int(3)), // 00.....1
        (StaticBigInt(-3), Int(3)), // 10.....1
        (StaticBigInt(-2), Int(2)), // 0......1
        (StaticBigInt(-1), Int(1)), // .......1
        (StaticBigInt( 0), Int(1)), // .......0
        (StaticBigInt( 1), Int(2)), // 1......0
        (StaticBigInt( 2), Int(3)), // 01.....0
        (StaticBigInt( 3), Int(3)), // 11.....0
        (StaticBigInt( 4), Int(4)), // 001....0
        (StaticBigInt( 5), Int(4)), // 101....0
        (StaticBigInt( 6), Int(4)), // 011....0
        (StaticBigInt( 7), Int(4)), // 111....0
        
        (StaticBigInt(-0x80000000000000000000000000000000), Int(128)),
        (StaticBigInt( 0x7fffffffffffffffffffffffffffffff), Int(128)),
        
    ])) func entropy(instance: StaticBigInt, expectation: Int) {
        #expect(instance.bitWidth == expectation)
    }
}

//*============================================================================*
// MARK: * Literal Int x Elements
//*============================================================================*

@Suite(.serialized) struct StaticBigIntTestsOnElements {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "StaticBigInt/elements: byte sequence prefix",
        Tag.List.tags(.documentation),
        arguments: Array<(StaticBigInt, [UInt8])>.infer([
        
        (StaticBigInt(-0000000000000000000000000000000001),                   [UInt8](repeating: UInt8.max, count: 32)),
        (StaticBigInt( 0000000000000000000000000000000000),                   [UInt8](repeating: UInt8.min, count: 32)),
        (StaticBigInt(-0xf0f1f2f3f4f5f6f7f8f9fafbfcfdff00), [UInt8](0...15) + [UInt8](repeating: UInt8.max, count: 16)),
        (StaticBigInt( 0x0f0e0d0c0b0a09080706050403020100), [UInt8](0...15) + [UInt8](repeating: UInt8.min, count: 16)),
        
    ])) func byteSequencePrefix(
        instance: StaticBigInt, expectation: [UInt8]
    )   throws {
        
        let ratio: Int =  UInt.bitWidth / 8
        for index: Int in expectation.indices {
            let word = instance[index / ratio]
            let base = word >> (index % ratio * 8)
            let byte = UInt8(truncatingIfNeeded: base)
            try #require(byte == expectation[index])
        }
    }
}

//*============================================================================*
// MARK: * Static Big Int x Text
//*============================================================================*

@Suite(.serialized) struct StaticBigIntTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "StaticBigInt/text: description",
        Tag.List.tags(.documentation, .unofficial),
        arguments: Array<(StaticBigInt, String)>.infer([
        
        (StaticBigInt(-8), "-0x8"), // 000....1
        (StaticBigInt(-7), "-0x7"), // 100....1
        (StaticBigInt(-6), "-0x6"), // 010....1
        (StaticBigInt(-5), "-0x5"), // 110....1
        (StaticBigInt(-4), "-0x4"), // 00.....1
        (StaticBigInt(-3), "-0x3"), // 10.....1
        (StaticBigInt(-2), "-0x2"), // 0......1
        (StaticBigInt(-1), "-0x1"), // .......1
        (StaticBigInt( 0), "+0x0"), // .......0
        (StaticBigInt( 1), "+0x1"), // 1......0
        (StaticBigInt( 2), "+0x2"), // 01.....0
        (StaticBigInt( 3), "+0x3"), // 11.....0
        (StaticBigInt( 4), "+0x4"), // 001....0
        (StaticBigInt( 5), "+0x5"), // 101....0
        (StaticBigInt( 6), "+0x6"), // 011....0
        (StaticBigInt( 7), "+0x7"), // 111....0
        
        (StaticBigInt(-0x80000000000000000000000000000000), "-0x80000000000000000000000000000000"),
        (StaticBigInt( 0x7fffffffffffffffffffffffffffffff), "+0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"),
        
    ])) func description(instance: StaticBigInt, expectation: String) {
        #expect(instance.debugDescription == expectation)
    }
}
