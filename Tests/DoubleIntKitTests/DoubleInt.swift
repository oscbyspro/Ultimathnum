//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Double Int
//*============================================================================*

@Suite struct DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let halves: [any SystemsInteger.Type] = {
        halvesAsSigned +
        halvesAsUnsigned
    }()
    
    static let halvesAsSigned: [any SystemsIntegerAsSigned.Type] = [
        I8.self, DoubleInt<I8>.self,
        IX.self, DoubleInt<IX>.self,
    ]
    
    static let halvesAsUnsigned: [any SystemsIntegerAsUnsigned.Type] = [
        U8.self, DoubleInt<U8>.self,
        UX.self, DoubleInt<UX>.self,
    ]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "DoubleInt: layout",
        Tag.List.tags(.generic),
        arguments: Self.halves
    )   func layout(
        half: any SystemsInteger.Type
    )   throws {
        
        try  whereIs(half)
        func whereIs<H>(_  half: H.Type) throws where H: SystemsInteger {
            typealias T = DoubleInt<H>
            typealias U = (H, H)
            
            #expect(MemoryLayout<T>.size      == 2 * MemoryLayout<H>.size)
            #expect(MemoryLayout<T>.stride    == 2 * MemoryLayout<H>.stride)
            #expect(MemoryLayout<T>.alignment == 1 * MemoryLayout<H>.alignment)
            Ɣexpect(MemoryLayout<T>.self, equals:    MemoryLayout<U>.self)
        }
    }
    
    @Test(
        "DoubleInt: bitcasting",
        Tag.List.tags(.generic, .random),
        arguments: Self.halves, fuzzers
    )   func bitcasting(
        half: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(half)
        func whereIs<H>(_  half: H.Type) throws where H: SystemsInteger {
            typealias T = DoubleInt<H>
            
            for _ in 0 ..< 8 {
                let low  = T.Low .random(using: &randomness)
                let high = T.High.random(using: &randomness)
                let full = T(low: low, high: high)
                
                try #require(full == T(raw: T.Magnitude(raw: full)))
                try #require(full == T(raw: T.Signitude(raw: full)))
                
                try #require(full == T(raw: T.Magnitude(low: low, high: H.Magnitude(raw: high))))
                try #require(full == T(raw: T.Signitude(low: low, high: H.Signitude(raw: high))))
            }
        }
    }
    
    @Test(
        "DoubleInt: components",
        Tag.List.tags(.generic, .random),
        arguments: Self.halves, fuzzers
    )   func components(
        half: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(half)
        func whereIs<H>(_  half: H.Type) throws where H: SystemsInteger {
            typealias T = DoubleInt<H>
            
            for _ in 0 ..< 8 {
                let low  = T.Low .random(using: &randomness)
                let high = T.High.random(using: &randomness)
                let base = Doublet(low: low, high: high)
                
                try #require(T().low .isZero)
                try #require(T().high.isZero)
            
                try #require(T(low: low).low  == low)
                try #require(T(low: low).high.isZero)
            
                try #require(T(low: low, high: high).low  == low )
                try #require(T(low: low, high: high).high == high)
                try #require(T(low: low, high: high).components() == (low, high))
            
                try #require(T(base).low  == low )
                try #require(T(base).high == high)
            
                try #require(Doublet(T(base)).low  == low )
                try #require(Doublet(T(base)).high == high)
                
                setter: do {
                    var full  = T()
                    full.low  = low
                    full.high = high
                    try #require(full.low  == low )
                    try #require(full.high == high)
                }
            }
        }
    }
}
