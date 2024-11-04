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
import TestKit2

//*============================================================================*
// MARK: * Triple Int
//*============================================================================*

@Suite struct TripleIntTests {
        
    typealias I8x3 = TripleInt<I8>
    typealias U8x3 = TripleInt<U8>
    
    typealias IXx3 = TripleInt<IX>
    typealias UXx3 = TripleInt<UX>
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let bases: [any SystemsInteger.Type] = {
        basesAsSigned +
        basesAsUnsigned
    }()
    
    static let basesAsSigned: [any SystemsIntegerAsSigned.Type] = {
        typesAsCoreIntegerAsSigned
    }()
    
    static let basesAsUnsigned: [any SystemsIntegerAsUnsigned.Type] = {
        typesAsCoreIntegerAsUnsigned
    }()
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("TripleInt: invariants", .tags(.generic), arguments: Self.bases)
    func invariants(base: any SystemsInteger.Type) throws {
        
        try  whereIs(base)
        func whereIs<B>(_ type: B.Type) throws where B: SystemsInteger {
            typealias T = TripleInt<B>
            
            #expect(T.mode == B.mode)
            #expect(T.size == Count(3 * IX(size: B.self)))
        }
    }
    
    @Test("TripleInt: layout", .tags(.generic), arguments: Self.bases)
    func layout(base: any SystemsInteger.Type) throws {
        
        try  whereIs(base)
        func whereIs<B>(_ base: B.Type) throws where B: SystemsInteger {
            typealias T = TripleInt<B>
            typealias U = (B, B, B)
            
            #expect(MemoryLayout<T>.size      == 3 * MemoryLayout<B>.size)
            #expect(MemoryLayout<T>.stride    == 3 * MemoryLayout<B>.stride)
            #expect(MemoryLayout<T>.alignment == 1 * MemoryLayout<B>.alignment)
            Ɣexpect(MemoryLayout<T>.self, equals:    MemoryLayout<U>.self)
        }
    }
    
    @Test("TripleInt: bitcasting", .tags(.generic, .random), arguments: Self.bases, fuzzers)
    func bitcasting(base: any SystemsInteger.Type, randomness: consuming FuzzerInt) throws {
        
        try  whereIs(base)
        func whereIs<B>(_ base: B.Type) throws where B: SystemsInteger {
            typealias T = TripleInt<B>
            
            for _ in 0 ..< 8 {
                let low  = T.Low .random(using: &randomness)
                let mid  = T.Mid .random(using: &randomness)
                let high = T.High.random(using: &randomness)
                let full = T(low: low, mid: mid, high: high)
                
                try #require(full == T(raw: T.Magnitude(raw: full)))
                try #require(full == T(raw: T.Signitude(raw: full)))
                
                try #require(full == T(raw: T.Magnitude(low: low, mid: mid, high: B.Magnitude(raw: high))))
                try #require(full == T(raw: T.Signitude(low: low, mid: mid, high: B.Signitude(raw: high))))
            }
        }
    }
    
    @Test("TripleInt: components", .tags(.generic, .random), arguments: Self.bases, fuzzers)
    func components(base: any SystemsInteger.Type, randomness: consuming FuzzerInt) throws {
        
        try  whereIs(base)
        func whereIs<B>(_ base: B.Type) throws where B: SystemsInteger {
            typealias T = TripleInt<B>
            
            for _ in 0 ..< 8 {
                let low  = T.Low .random(using: &randomness)
                let mid  = T.Mid .random(using: &randomness)
                let high = T.High.random(using: &randomness)
                
                always: do {
                    try #require(T().low .isZero)
                    try #require(T().mid .isZero)
                    try #require(T().high.isZero)
                }
                
                always: do {
                    try #require(T(low: low).low  == low)
                    try #require(T(low: low).mid .isZero)
                    try #require(T(low: low).high.isZero)
                }
                
                always: do {
                    try #require(T(low: low, mid: mid).low  == low)
                    try #require(T(low: low, mid: mid).mid  == mid)
                    try #require(T(low: low, mid: mid).high.isZero)
                }
                
                always: do {
                    try #require(T(low: low, mid: mid, high: high).low  == low )
                    try #require(T(low: low, mid: mid, high: high).mid  == mid )
                    try #require(T(low: low, mid: mid, high: high).high == high)
                }
                
                always: do {
                    try #require(T(low: Doublet(low: low, high: mid), high: high).low  == low )
                    try #require(T(low: Doublet(low: low, high: mid), high: high).mid  == mid )
                    try #require(T(low: Doublet(low: low, high: mid), high: high).high == high)
                }
                
                always: do {
                    try #require(T(low: low, high: Doublet(low: mid, high: high)).low  == low )
                    try #require(T(low: low, high: Doublet(low: mid, high: high)).mid  == mid )
                    try #require(T(low: low, high: Doublet(low: mid, high: high)).high == high)
                }
                
                getter: do {
                    try #require(T(low: low, mid: mid, high: high).components() == (low, mid, high))
                }
                
                setter: do {
                    var full  = T()
                    full.low  = low
                    full.mid  = mid
                    full.high = high
                    try #require(full.low  == low )
                    try #require(full.mid  == mid )
                    try #require(full.high == high)
                }
            }
        }
    }
}
