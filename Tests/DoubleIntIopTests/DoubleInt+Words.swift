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
import DoubleIntIop
import DoubleIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Double Int x Stdlib x Words
//*============================================================================*

@Suite struct DoubleIntStdlibTestsOnWords {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "DoubleInt.Stdlib/words: Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func forwarding(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
            for _ in 0 ..< conditional(debug: 64, release: 128) {
                let value = T.Base.entropic(using: &randomness)
                var expectation: [UInt] = []
                
                always: do {
                    var copy = value
                    var bits = UX.zero
                    
                    while bits < UX(size: T.Base.self) {
                        expectation.append(UInt(UX(load: copy)))
                        bits += UX(size:  UX.self)
                        copy  = copy.down(UX.size)
                    }
                }
                
                let result = T(value).words
                try #require(result.elementsEqual(expectation))
                try #require(result[Swift.Int.zero] == T(value)._lowWord)
            }
        }
    }
    
    @Test(
        "DoubleInt.Stdlib/words: subscript is lenient",
        Tag.List.tags(.documentation, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func subscriptIsLenient(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
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
}
