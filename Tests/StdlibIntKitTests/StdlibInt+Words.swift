//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import StdlibIntKit
import TestKit2

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
    
    @Test("StdlibInt.Words/subscript - is lenient")
    func wordsSubscriptIsLenient() {
        let x0 = StdlibInt( 1).words
        let x1 = StdlibInt(-2).words
        
        always: do {
            #expect(x0[0] ==  1 as UInt)
            #expect(x1[0] == ~1 as UInt)
        }
        
        for i: Swift.Int  in  1 ... 12 {
            #expect(x0[i] ==  0 as UInt)
            #expect(x1[i] == ~0 as UInt)
        }
        
        always: do {
            #expect(x0[Int.max] ==  0 as UInt)
            #expect(x1[Int.max] == ~0 as UInt)
        }
    }
    
    @Test("StdlibInt.Words/subscript - traps negative indices", .disabled("req. exit tests"))
    func wordsSubscriptTrapsNegativeIndices() {
        
    }
    
    @Test("StdlibInt.Words/description", arguments: [
        
        ([1            ] as [UInt], "[1]"            ),
        ([1, 3         ] as [UInt], "[1, 3]"         ),
        ([1, 3, 5      ] as [UInt], "[1, 3, 5]"      ),
        ([1, 3, 5, 7   ] as [UInt], "[1, 3, 5, 7]"   ),
        ([1, 3, 5, 7, 9] as [UInt], "[1, 3, 5, 7, 9]"),
        
    ]   as [(words: [UInt], description: String)]) func wordsTextIsArray(words: [UInt], description: String) {
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
    
    @Test("StdlibInt/words [64-bit]", .disabled(if: UInt.bitWidth != 64), arguments: [
        
        ( 0x00000000000000000000000000000000 as StdlibInt, [0x0000000000000000] as [UInt]),
        ( 0x00000000000000000000000000000001 as StdlibInt, [0x0000000000000001] as [UInt]),
        ( 0x00000000000000000706050403020100 as StdlibInt, [0x0706050403020100] as [UInt]),
        ( 0x0f0e0d0c0b0a09080706050403020100 as StdlibInt, [0x0706050403020100, 0x0f0e0d0c0b0a0908] as [UInt]),
        ( 0x7fffffffffffffffffffffffffffffff as StdlibInt, [0xffffffffffffffff, 0x7fffffffffffffff] as [UInt]),
        ( 0x80000000000000000000000000000000 as StdlibInt, [0x0000000000000000, 0x8000000000000000, 0x0000000000000000] as [UInt]),
        ( 0x80000000000000000000000000000001 as StdlibInt, [0x0000000000000001, 0x8000000000000000, 0x0000000000000000] as [UInt]),
        
        (-0x00000000000000000000000000000000 as StdlibInt, [0x0000000000000000] as [UInt]),
        (-0x00000000000000000000000000000001 as StdlibInt, [0xffffffffffffffff] as [UInt]),
        (-0x00000000000000000706050403020100 as StdlibInt, [0xf8f9fafbfcfdff00] as [UInt]),
        (-0x0f0e0d0c0b0a09080706050403020100 as StdlibInt, [0xf8f9fafbfcfdff00, 0xf0f1f2f3f4f5f6f7] as [UInt]),
        (-0x7fffffffffffffffffffffffffffffff as StdlibInt, [0x0000000000000001, 0x8000000000000000] as [UInt]),
        (-0x80000000000000000000000000000000 as StdlibInt, [0x0000000000000000, 0x8000000000000000] as [UInt]),
        (-0x80000000000000000000000000000001 as StdlibInt, [0xffffffffffffffff, 0x7fffffffffffffff, 0xffffffffffffffff] as [UInt]),
        
    ]   as [(StdlibInt, [UInt])]) func words64(instance: StdlibInt, words: [UInt]) {
        #expect(Array(instance.words) == words)
    }
}
