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
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Double Int x Stdlib x Text
//*============================================================================*

@Suite struct DoubleIntStdlibTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "DoubleInt.Stdlib/text: Self vs Base",
        Tag.List.tags(.forwarding, .generic, .random, .todo),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func forwarding(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
            let size = IX(size: T.Base.self) ?? 256
            
            for _ in 0  ..< 128 {
                let value = T.Base.entropic(size: size,  using: &randomness)
                let radix = ((IX)).random(in: 002...36,  using: &randomness)
                let coder = try #require(TextInt(radix:  radix))
                let lowercase = value.description(using: coder.lowercased())
                let uppercase = value.description(using: coder.uppercased())
                
                try #require(String(T(value), radix: Swift.Int(radix), uppercase: false) == lowercase)
                try #require(String(T(value), radix: Swift.Int(radix), uppercase: true ) == uppercase)
                
                if  radix == 10 {
                    try #require(T(lowercase)  == T(value))
                    try #require(T(value).description == lowercase)
                    try #require(String(T(((value)))) == lowercase)
                }
            }
        }
    }
    
    @Test(
        "DoubleInt.Stdlib/text: forwarding about edges",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsDoubleIntStdlibAsWorkaround, fuzzers
    )   func forwardingAboutEdges(
        type: AnyDoubleIntStdlibType, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type.base)
        func whereIs<T>(_ type: T.Type) throws where T: DoubleIntStdlib {
            for coder in TextInt.all {
                let radix = Swift.Int(IX(coder.radix))
                let uppercase = coder.letters == TextInt.Letters.uppercase
                let min = IXL(T.Base.min).description(using: coder)
                let max = IXL(T.Base.max).description(using: coder)
                try #require(String(T.min, radix: radix, uppercase: uppercase) == min)
                try #require(String(T.max, radix: radix, uppercase: uppercase) == max)
            }
            
            try #require(T.min.description == T.Base.min.description)
            try #require(T.max.description == T.Base.max.description)
            try #require(T(IXL(T.Base.min).decremented().description) ==   nil)
            try #require(T(   (T.Base.min)              .description) == T.min)
            try #require(T(   (T.Base.max)              .description) == T.max)
            try #require(T(IXL(T.Base.max).incremented().description) ==   nil)
        }
    }
}
