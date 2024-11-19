//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit
import RandomIntKit
import StdlibIntKit
import TestKit

//*============================================================================*
// MARK: * Stdlib Int x Words
//*============================================================================*

/// An `StdlibInt` test suite.
///
/// ### Wrapper
///
/// `StdlibInt` should forward most function calls to its underlying model.
///
/// ### Development
///
/// - TODO: Test `StdlibInt` forwarding in generic `BinaryInteger` tests.
///
@Suite struct StdlibIntTestsOnWords {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "StdlibInt/words: subscript is lenient",
        Tag.List.tags(.documentation, .random),
        arguments: fuzzers
    )   func subscriptIsLenient(
        randomness: consuming FuzzerInt
    )   throws {
        
        for _ in 0 ..< 8 {
            let value = IXL.random(through: Shift.max(or: 255), using: &randomness)
            let words = StdlibInt(((value))).words
            let range = IX(words.count+1)...IX.max
            
            for _ in 0 ..< 8 {
                let index = Swift.Int(IX.random(in: range, using: &randomness))
                let element = UX(repeating: value.appendix)
                try #require(words[index] == UInt(element))
            }
        }
    }
    
    @Test(
        "StdlibInt/words: subscript traps negative indices",
        ConditionTrait.disabled("req. exit tests")
    )   func wordsSubscriptTrapsNegativeIndices() {
        
    }
    
    @Test(
        "StdlibInt.words: description is an array",
        arguments: Array<(words: [UInt], description: String)>.infer([
        
        ([1            ] as [UInt], "[1]"            ),
        ([1, 3         ] as [UInt], "[1, 3]"         ),
        ([1, 3, 5      ] as [UInt], "[1, 3, 5]"      ),
        ([1, 3, 5, 7   ] as [UInt], "[1, 3, 5, 7]"   ),
        ([1, 3, 5, 7, 9] as [UInt], "[1, 3, 5, 7, 9]"),
        
    ])) func descriptionIsAnArray(words: [UInt], description: String) {
        let instance: StdlibInt = words.reversed().reduce(into: 0) {
            $0 <<= UInt.bitWidth
            $0  |= StdlibInt($1)
        }
        
        #expect(Array(instance.words) == words)
        #expect(String(describing: instance.words) == description)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "StdlibInt/words: 64-bit",
        ConditionTrait.disabled(if: UInt.bitWidth != 64),
        arguments: Array<(StdlibInt, [UInt])>.infer([
        
        (StdlibInt( 0x00000000000000000000000000000000), [0x0000000000000000] as [UInt]),
        (StdlibInt( 0x00000000000000000000000000000001), [0x0000000000000001] as [UInt]),
        (StdlibInt( 0x00000000000000000706050403020100), [0x0706050403020100] as [UInt]),
        (StdlibInt( 0x0f0e0d0c0b0a09080706050403020100), [0x0706050403020100, 0x0f0e0d0c0b0a0908] as [UInt]),
        (StdlibInt( 0x7fffffffffffffffffffffffffffffff), [0xffffffffffffffff, 0x7fffffffffffffff] as [UInt]),
        (StdlibInt( 0x80000000000000000000000000000000), [0x0000000000000000, 0x8000000000000000, 0x0000000000000000] as [UInt]),
        (StdlibInt( 0x80000000000000000000000000000001), [0x0000000000000001, 0x8000000000000000, 0x0000000000000000] as [UInt]),
        
        (StdlibInt(-0x00000000000000000000000000000000), [0x0000000000000000] as [UInt]),
        (StdlibInt(-0x00000000000000000000000000000001), [0xffffffffffffffff] as [UInt]),
        (StdlibInt(-0x00000000000000000706050403020100), [0xf8f9fafbfcfdff00] as [UInt]),
        (StdlibInt(-0x0f0e0d0c0b0a09080706050403020100), [0xf8f9fafbfcfdff00, 0xf0f1f2f3f4f5f6f7] as [UInt]),
        (StdlibInt(-0x7fffffffffffffffffffffffffffffff), [0x0000000000000001, 0x8000000000000000] as [UInt]),
        (StdlibInt(-0x80000000000000000000000000000000), [0x0000000000000000, 0x8000000000000000] as [UInt]),
        (StdlibInt(-0x80000000000000000000000000000001), [0xffffffffffffffff, 0x7fffffffffffffff, 0xffffffffffffffff] as [UInt]),
        
    ])) func words64(instance: StdlibInt, words: [UInt]) {
        #expect(Array(instance.words) == words)
    }
}
