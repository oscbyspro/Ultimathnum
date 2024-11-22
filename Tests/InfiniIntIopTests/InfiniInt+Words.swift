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
import InfiniIntIop
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Infini Int x Stdlib x Words
//*============================================================================*

@Suite struct InfiniIntStdlibTestsOnWords {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "InfiniInt.Stdlib/words: description is an array",
        Tag.List.tags(.generic, .todo),
        arguments: Array<([UInt], String)>.infer([
        
        ([1            ] as [UInt], "[1]"            ),
        ([1, 3         ] as [UInt], "[1, 3]"         ),
        ([1, 3, 5      ] as [UInt], "[1, 3, 5]"      ),
        ([1, 3, 5, 7   ] as [UInt], "[1, 3, 5, 7]"   ),
        ([1, 3, 5, 7, 9] as [UInt], "[1, 3, 5, 7, 9]"),
        
    ])) func descriptionIsAnArray(
        words: [UInt], description: String
    )   throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: AdapterInteger {
            try #require(T.Base.isArbitrary)
            
            let instance: T = words.reversed().reduce(into: 0) {
                $0 <<= UInt.bitWidth
                $0  |= T.init($1)
            }
            
            try #require(Array(instance.words) == words)
            try #require(String(describing: instance.words) == description)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "InfiniInt.Stdlib/words: subscript is lenient",
        Tag.List.tags(.documentation, .generic, .random, .todo),
        arguments: fuzzers
    )   func subscriptIsLenient(
        randomness: consuming FuzzerInt
    )   throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: AdapterInteger {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0 ..< 8 {
                let value = T.Base.entropic(size: size, using: &randomness)
                let words = T(((value))).words
                let range = IX(words.count+1)...IX.max
                
                for _ in 0 ..< 8 {
                    let index = Swift.Int(IX.random(in: range, using: &randomness))
                    let element = UX(repeating: value.appendix)
                    try #require(words[index] == UInt(element))
                }
            }
        }
    }
    
    @Test(
        "StdlibInt/words: 64-bit",
        Tag.List.tags(.generic, .todo),
        ConditionTrait.disabled(if: UInt.bitWidth != 64),
        arguments: Array<(IXL, [UInt])>.infer([
        
        (IXL( 0x0000000000000080), [0x0000000000000080] as [UInt]),
        (IXL( 0x0000000000008000), [0x0000000000008000] as [UInt]),
        (IXL( 0x0000000080000000), [0x0000000080000000] as [UInt]),
        (IXL( 0x8000000000000000), [0x8000000000000000, 0x0000000000000000] as [UInt]),
        
        (IXL(-0x0000000000000081), [0xffffffffffffff7f] as [UInt]),
        (IXL(-0x0000000000008001), [0xffffffffffff7fff] as [UInt]),
        (IXL(-0x0000000080000001), [0xffffffff7fffffff] as [UInt]),
        (IXL(-0x8000000000000001), [0x7fffffffffffffff, 0xffffffffffffffff] as [UInt]),
        
        (IXL( 0x00000000000000000000000000000000), [0x0000000000000000] as [UInt]),
        (IXL( 0x00000000000000000000000000000001), [0x0000000000000001] as [UInt]),
        (IXL( 0x00000000000000000706050403020100), [0x0706050403020100] as [UInt]),
        (IXL( 0x0f0e0d0c0b0a09080706050403020100), [0x0706050403020100, 0x0f0e0d0c0b0a0908] as [UInt]),
        (IXL( 0x7fffffffffffffffffffffffffffffff), [0xffffffffffffffff, 0x7fffffffffffffff] as [UInt]),
        (IXL( 0x80000000000000000000000000000000), [0x0000000000000000, 0x8000000000000000, 0x0000000000000000] as [UInt]),
        (IXL( 0x80000000000000000000000000000001), [0x0000000000000001, 0x8000000000000000, 0x0000000000000000] as [UInt]),
        
        (IXL(-0x00000000000000000000000000000000), [0x0000000000000000] as [UInt]),
        (IXL(-0x00000000000000000000000000000001), [0xffffffffffffffff] as [UInt]),
        (IXL(-0x00000000000000000706050403020100), [0xf8f9fafbfcfdff00] as [UInt]),
        (IXL(-0x0f0e0d0c0b0a09080706050403020100), [0xf8f9fafbfcfdff00, 0xf0f1f2f3f4f5f6f7] as [UInt]),
        (IXL(-0x7fffffffffffffffffffffffffffffff), [0x0000000000000001, 0x8000000000000000] as [UInt]),
        (IXL(-0x80000000000000000000000000000000), [0x0000000000000000, 0x8000000000000000] as [UInt]),
        (IXL(-0x80000000000000000000000000000001), [0xffffffffffffffff, 0x7fffffffffffffff, 0xffffffffffffffff] as [UInt]),
        
    ])) func words64(value: IXL, words: [UInt]) throws {
        
        for type in typesAsInfiniIntStdlib {
            try whereIs(type) // TODO: await parameterized tests fix
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: AdapterInteger {
            try #require(T.Base.isArbitrary)
            let base = try #require(T.Base.exactly(value).optional())
            
            let stdlib = T(base)
            let result = stdlib.words
            try #require(Array(result) == words)
            
            let division = IX(stdlib.bitWidth).division(IX(size: UX.self))
            try #require(IX(result.count) == division!.unwrap().ceil().unwrap())
        }
    }
}
