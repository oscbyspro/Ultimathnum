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
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Stdlib x Text
//*============================================================================*

@Suite struct BinaryIntegerStdlibTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger.Stdlib/text: as Swift.BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsFiniteIntegerInteroperable, fuzzers
    )   func asSwiftBinaryInteger(
        type: any FiniteIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: FiniteIntegerInteroperable {
            let size = IX(size: T.self) ?? 256
            
            for _ in 0 ..< 32 {
                let value = T.entropic(size: size, using: &randomness)
                let description = value.description
                
                try #require(description == String(T.Stdlib(value)), "LosslessStringConvertible")
                try #require(description == String(T.Stdlib(value), radix: 10, uppercase: false))
                try #require(description == String(T.Stdlib(value), radix: 10, uppercase: true ))
                
                try #require(T.Stdlib(value) == T.Stdlib(description))
            }
            
            for _ in 0  ..< 32 {
                let value = T.entropic(size: size, using: &randomness)
                let coder = TextInt.all.randomElement(using: &randomness.stdlib)!
                let radix = Swift.Int(IX(coder.radix))
                
                let lowercased = value.description(using: coder.lowercased())
                let uppercased = value.description(using: coder.uppercased())
                
                try #require(lowercased == String(T.Stdlib(value), radix: radix, uppercase: false))
                try #require(uppercased == String(T.Stdlib(value), radix: radix, uppercase: true ))
            }
        }
    }
    
    @Test(
        "BinaryInteger.Stdlib/text: as Swift.FixedWidthInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsSystemsIntegerInteroperable, fuzzers
    )   func asSwiftFixedWidthInteger(
        type: any SystemsIntegerInteroperable.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerInteroperable {
            for coder in TextInt.all {
                let radix = Swift.Int(IX(coder.radix))
                let uppercase = (coder.letters == TextInt.Letters.uppercase)
                
                let min = T.min.description(using: coder)
                let max = T.max.description(using: coder)
                
                try #require(min == String(T.Stdlib.min, radix: radix, uppercase: uppercase))
                try #require(max == String(T.Stdlib.max, radix: radix, uppercase: uppercase))
            }
            
            try #require(T.Stdlib.min.description == T.min.description)
            try #require(T.Stdlib.max.description == T.max.description)
            try #require(T.Stdlib(IXL(T.min).decremented().description) == nil)
            try #require(T.Stdlib(   (T.min)              .description) == T.Stdlib.min)
            try #require(T.Stdlib(   (T.max)              .description) == T.Stdlib.max)
            try #require(T.Stdlib(IXL(T.max).incremented().description) == nil)
        }
    }
}
