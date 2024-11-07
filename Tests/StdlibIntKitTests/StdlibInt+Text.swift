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
import TestKit

//*============================================================================*
// MARK: * Stdlib Int x Text
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
@Suite struct StdlibIntTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/text: vs StdlibInt.Base",
        Tag.List.tags(.forwarding, .random),
        arguments: fuzzers
    )   func forwarding(randomness: consuming FuzzerInt) throws {
        for _ in 0  ..< 128 {
            let value = IXL.entropic(size: 256, using: &randomness)
            let radix = IX .random(in: 02...36, using: &randomness)
            let coder = try TextInt(radix: radix)
            let lowercase = value.description(as: coder.lowercased())
            let uppercase = value.description(as: coder.uppercased())
            
            try #require(try StdlibInt(lowercase,  as: coder) == StdlibInt(value))
            try #require(try StdlibInt(uppercase,  as: coder) == StdlibInt(value))
            
            try #require(StdlibInt(value).description(as: coder.lowercased()) == lowercase)
            try #require(StdlibInt(value).description(as: coder.uppercased()) == uppercase)
            
            try #require(String(StdlibInt(value),  radix: Swift.Int(radix), uppercase: false) == lowercase)
            try #require(String(StdlibInt(value),  radix: Swift.Int(radix), uppercase: true ) == uppercase)
            
            if  radix == 10 {
                try #require(StdlibInt(lowercase)  == StdlibInt(value))
                try #require(StdlibInt(value).description == lowercase)
                try #require(String(StdlibInt(((value)))) == lowercase)
            }
        }
    }
}
