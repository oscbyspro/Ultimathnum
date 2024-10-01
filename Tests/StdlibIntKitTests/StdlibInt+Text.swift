//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit
import InfiniIntKit
import StdlibIntKit
import TestKit2

//*============================================================================*
// MARK: * Stdlib Int x Text
//*============================================================================*

@Suite struct StdlibIntTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// Here we check that `StdlibInt/description` matches `IXL/description`.
    @Test("BinaryInteger/description [bidirectional][entropic][comparison]", arguments: fuzzers)
    func description(_ randomness: consuming FuzzerInt) throws {
        for _ in 0  ..< 128 {
            let radix = IX.random(in: 2...36, using: &randomness)
            let coder = try TextInt(radix: radix)
            let value = IXL.entropic(size: 256, mode: .signed, using: &randomness)
            let lowercase = value.description(as: coder.lowercased())
            let uppercase = value.description(as: coder.uppercased())
            
            #expect(try StdlibInt(lowercase,  as: coder) == StdlibInt(value))
            #expect(try StdlibInt(uppercase,  as: coder) == StdlibInt(value))
            #expect(StdlibInt(value).description(as: coder.lowercased()) == lowercase)
            #expect(StdlibInt(value).description(as: coder.uppercased()) == uppercase)
            #expect(String(StdlibInt(value),  radix: Swift.Int(radix), uppercase: false) == lowercase)
            #expect(String(StdlibInt(value),  radix: Swift.Int(radix), uppercase: true ) == uppercase)
            
            if  radix == 10 {
                #expect(StdlibInt(lowercase)  == StdlibInt(value))
                #expect(StdlibInt(value).description == lowercase)
                #expect(String(StdlibInt(((value)))) == lowercase)
            }
        }
    }
}
