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
        base: any SystemsInteger.Type
    )   throws {
        
        try  whereIs(base)
        func whereIs<B>(_ base: B.Type) throws where B: SystemsInteger {
            typealias T = DoubleInt<B>
            typealias U = (B, B)
            
            #expect(MemoryLayout<T>.size      == 2 * MemoryLayout<B>.size)
            #expect(MemoryLayout<T>.stride    == 2 * MemoryLayout<B>.stride)
            #expect(MemoryLayout<T>.alignment == 1 * MemoryLayout<B>.alignment)
            Ɣexpect(MemoryLayout<T>.self, equals:    MemoryLayout<U>.self)
        }
    }
    
    @Test(
        "DoubleInt: bitcasting",
        Tag.List.tags(.generic, .random),
        arguments: Self.halves, fuzzers
    )   func bitcasting(
        base: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(base)
        func whereIs<B>(_ base: B.Type) throws where B: SystemsInteger {
            typealias T = DoubleInt<B>
            
            for _ in 0 ..< 8 {
                let low  = T.Low .random(using: &randomness)
                let high = T.High.random(using: &randomness)
                let full = T(low: low, high: high)
                
                try #require(full == T(raw: T.Magnitude(raw: full)))
                try #require(full == T(raw: T.Signitude(raw: full)))
                
                try #require(full == T(raw: T.Magnitude(low: low, high: B.Magnitude(raw: high))))
                try #require(full == T(raw: T.Signitude(low: low, high: B.Signitude(raw: high))))
            }
        }
    }
    
    @Test(
        "DoubleInt: components",
        Tag.List.tags(.generic, .random),
        arguments: Self.halves, fuzzers
    )   func components(
        base: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {

        try  whereIs(base)
        func whereIs<B>(_ base: B.Type) throws where B: SystemsInteger {
            typealias T = DoubleInt<B>
            
            for _ in 0 ..< 8 {
                let low  = T.Low .random(using: &randomness)
                let high = T.High.random(using: &randomness)
                
                always: do {
                    try #require(T().low .isZero)
                    try #require(T().high.isZero)
                }
                
                always: do {
                    try #require(T(low: low).low  == low)
                    try #require(T(low: low).high.isZero)
                }
                
                always: do {
                    try #require(T(low: low, high: high).low  == low )
                    try #require(T(low: low, high: high).high == high)
                }
                
                getter: do {
                    try #require(T(low: low, high: high).components() == (low, high))
                }
                
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
