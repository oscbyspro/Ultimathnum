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
import TestKit

//*============================================================================*
// MARK: * Swift x Binary Integer
//*============================================================================*

@Suite struct SwiftBinaryIntegerTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Swift.BinaryInteger: init(raw:)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreInteger, fuzzers
    )   func bitcasting(
        type: any CoreInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreInteger {
            for _ in 0 ..< 32 {
                try whereIs(T.random(using: &randomness))
            }
        }
        
        func whereIs<T>(_ instance: T) throws where T: CoreInteger {
            var instance    = instance
            let expectation = instance
            
            try #require(expectation == T(     instance.stdlib))
            try #require(expectation == T(raw: instance.stdlib))
            try #require(expectation == T(     instance.stdlib()))
            try #require(expectation == T(raw: instance.stdlib()))
            try #require(expectation == T(     T.Stdlib(     instance)))
            try #require(expectation == T(raw: T.Stdlib(raw: instance)))
        }
    }
}
