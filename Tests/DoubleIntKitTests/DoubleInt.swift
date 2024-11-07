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
    
    typealias I8x2 = DoubleInt<I8>
    typealias U8x2 = DoubleInt<U8>
    
    typealias I8x4 = DoubleInt<I8x2>
    typealias U8x4 = DoubleInt<U8x2>
    
    typealias IXx2 = DoubleInt<IX>
    typealias UXx2 = DoubleInt<UX>
    
    typealias IXx4 = DoubleInt<IXx2>
    typealias UXx4 = DoubleInt<UXx2>
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let bases: [any SystemsInteger.Type] = {
        basesAsSigned +
        basesAsUnsigned
    }()
    
    static let basesAsSigned: [any SystemsIntegerAsSigned.Type] = [
        I8x2.High.self,
        I8x4.High.self,
        IXx2.High.self,
        IXx4.High.self,
    ]
    
    static let basesAsUnsigned: [any SystemsIntegerAsUnsigned.Type] = [
        U8x2.High.self,
        U8x4.High.self,
        UXx2.High.self,
        UXx4.High.self,
    ]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("DoubleInt: layout", .tags(.generic), arguments: Self.bases)
    func layout(base: any SystemsInteger.Type) throws {
        
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
    
    @Test("DoubleInt: bitcasting", .tags(.generic, .random), arguments: Self.bases, fuzzers)
    func bitcasting(base: any SystemsInteger.Type, randomness: consuming FuzzerInt) throws {
        
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
    
    @Test("DoubleInt: components", .tags(.generic, .random), arguments: Self.bases, fuzzers)
    func components(base: any SystemsInteger.Type, randomness: consuming FuzzerInt) throws {

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
