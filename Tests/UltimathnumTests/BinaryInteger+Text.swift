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
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Text
//*============================================================================*

@Suite struct BinaryIntegerTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/text: description is TextInt.decimal",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func descriptionIsTextIntDecimal(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? 256
            
            for _ in 0 ..< conditional(debug: 32, release: 64) {
                let value = T.entropic(size: size, using: &randomness)
                let description = TextInt.decimal.encode(value)
                
                let decoded = T(description)
                let encoded = value.description
                
                try #require(decoded == value)
                try #require(encoded == description)
            }
        }
    }
    
    @Test(
        "BinaryInteger/text: description using TexInt is TextInt",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func descriptionUsingTextIntIsTextInt(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? 256
            
            for _ in 0 ..< conditional(debug: 32, release: 64) {
                let value = T.entropic(size: size, using: &randomness)
                let coder = TextInt.all.randomElement(using: &randomness.stdlib)!
                let description = coder.encode(value)
                
                let decoded = T(description,    using: coder)
                let encoded = value.description(using: coder)
                
                try #require(decoded == value)
                try #require(encoded == description)
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Text x Validation
//*============================================================================*

@Suite struct BinaryIntegerTestsOnTextValidation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/text: lossy is nil",
        Tag.List.tags(.generic, .important, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func lossyIsNil(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(source: IXL.self, destination: type)
        try  whereIs(source: UXL.self, destination: type)
        func whereIs<A, B>(source: A.Type, destination: B.Type)
        throws where A: ArbitraryInteger, B: BinaryInteger {
            
            for _ in 0 ..<  conditional(debug: 32, release: 64) {
                let value = A.entropic(size: 256, using: &randomness)
                let coder = TextInt.all.randomElement(using: &randomness.stdlib)!
                
                always: do {
                    let description = value.description
                    let lhs = B(description)
                    let rhs = B.exactly(value).optional()
                    try #require(lhs == rhs)
                }
                
                always: do {
                    let description = value.description(using: coder)
                    let lhs = B(description, using:coder)
                    let rhs = B.exactly(value).optional()
                    try #require(lhs == rhs)
                }
            }
        }
    }
}
