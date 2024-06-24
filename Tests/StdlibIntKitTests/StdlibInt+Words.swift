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
import TestKit

//*============================================================================*
// MARK: * Stdlib Int x Words
//*============================================================================*

extension StdlibIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testWords() throws {
        if  MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size {
            Test().same(Array(( 0x00000000000000000000000000000000 as T).words), [0x0000000000000000] as [UInt])
            Test().same(Array(( 0x00000000000000000000000000000001 as T).words), [0x0000000000000001] as [UInt])
            Test().same(Array(( 0x00000000000000000706050403020100 as T).words), [0x0706050403020100] as [UInt])
            Test().same(Array(( 0x0f0e0d0c0b0a09080706050403020100 as T).words), [0x0706050403020100, 0x0f0e0d0c0b0a0908] as [UInt])
            Test().same(Array(( 0x7fffffffffffffffffffffffffffffff as T).words), [0xffffffffffffffff, 0x7fffffffffffffff] as [UInt])
            Test().same(Array(( 0x80000000000000000000000000000000 as T).words), [0x0000000000000000, 0x8000000000000000, 0x0000000000000000] as [UInt])
            Test().same(Array(( 0x80000000000000000000000000000001 as T).words), [0x0000000000000001, 0x8000000000000000, 0x0000000000000000] as [UInt])
            
            Test().same(Array((-0x00000000000000000000000000000000 as T).words), [0x0000000000000000] as [UInt])
            Test().same(Array((-0x00000000000000000000000000000001 as T).words), [0xffffffffffffffff] as [UInt])
            Test().same(Array((-0x00000000000000000706050403020100 as T).words), [0xf8f9fafbfcfdff00] as [UInt])
            Test().same(Array((-0x0f0e0d0c0b0a09080706050403020100 as T).words), [0xf8f9fafbfcfdff00, 0xf0f1f2f3f4f5f6f7] as [UInt])
            Test().same(Array((-0x7fffffffffffffffffffffffffffffff as T).words), [0x0000000000000001, 0x8000000000000000] as [UInt])
            Test().same(Array((-0x80000000000000000000000000000000 as T).words), [0x0000000000000000, 0x8000000000000000] as [UInt])
            Test().same(Array((-0x80000000000000000000000000000001 as T).words), [0xffffffffffffffff, 0x7fffffffffffffff, 0xffffffffffffffff] as [UInt])
        }   else {
            throw XCTSkip()
        }
    }
    
    func testWordsSubscriptIsLenient() {
        let x0 = T( 1).words
        let x1 = T(-2).words
            
        always: do {
            Test().same(x0[0],  1 as UInt)
            Test().same(x1[0], ~1 as UInt)
        }
        
        for i: Swift.Int in 1 ... 12 {
            Test().same(x0[i],  0 as UInt)
            Test().same(x1[i], ~0 as UInt)
        }
        
        always: do {
            let i = Int.max
            Test().same(x0[i],  0 as UInt)
            Test().same(x1[i], ~0 as UInt)
        }
    }
    
    func testWordsSubscriptTrapsNegativeIndices() throws {
        throw XCTSkip("req. crash tests")
    }
    
    func testWordsTextIsArray() {
        let arguments: [(words: [UInt], description: String)] = [
            ([1            ], "[1]"            ),
            ([1, 3         ], "[1, 3]"         ),
            ([1, 3, 5      ], "[1, 3, 5]"      ),
            ([1, 3, 5, 7   ], "[1, 3, 5, 7]"   ),
            ([1, 3, 5, 7, 9], "[1, 3, 5, 7, 9]"),
        ]
        
        for (words, description) in arguments {
            var value = T.zero
            
            for word in words.reversed() {
                value <<= UInt.bitWidth
                value  |= T(word)
            }
            
            Test().same(Array(value.words), Array(words))
            Test().same(String(describing:  value.words), description)
        }
    }
}
