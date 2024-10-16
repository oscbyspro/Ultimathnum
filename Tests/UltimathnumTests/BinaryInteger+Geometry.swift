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
import TestKit2

//*============================================================================*
// MARK: * Binary Integer x Geometry
//*============================================================================*

@Suite struct BinaryIntegerTestsOnGeometry {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/geometry: √(x)",
        Tag.List.tags(.random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func integerSquareRoot(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 32, release: 256) {
                let index = Shift<T.Magnitude>.max(or: 255)
                let value = T.entropic(through: index, as: Domain.natural, using: &randomness)
                try Ɣexpect(value, isqrt: #require(value.isqrt()))
            }
        }
    }
    
    @Test(
        "BinaryInteger/geometry: √(x) as natural",
        Tag.List.tags(.random),
        arguments: typesAsSystemsIntegerAsUnsigned, fuzzers
    )   func integerSquareRootAsNatural(type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 512) {
                let value = T.entropic(as: Domain.natural, using: &randomness)
                try Ɣexpect(value, isqrt: value.isqrt())
            }
        }
    }
}
    
//*============================================================================*
// MARK: * Binary Integer x Geometry x Edge Cases
//*============================================================================*

@Suite(.tags(.documentation)) struct BinaryIntegerTestsOnGeometryEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("BinaryInteger/geometry: √(x) of small natural", .serialized, arguments: [
        
        Some( 0 as U8, yields: 0 as U8),
        Some( 1 as U8, yields: 1 as U8),
        Some( 2 as U8, yields: 1 as U8),
        Some( 3 as U8, yields: 1 as U8),
        Some( 4 as U8, yields: 2 as U8),
        Some( 5 as U8, yields: 2 as U8),
        Some( 6 as U8, yields: 2 as U8),
        Some( 7 as U8, yields: 2 as U8),
        Some( 8 as U8, yields: 2 as U8),
        Some( 9 as U8, yields: 3 as U8),
        Some(10 as U8, yields: 3 as U8),
        Some(11 as U8, yields: 3 as U8),
        Some(12 as U8, yields: 3 as U8),
        Some(13 as U8, yields: 3 as U8),
        Some(14 as U8, yields: 3 as U8),
        Some(15 as U8, yields: 3 as U8),
        Some(16 as U8, yields: 4 as U8),
        
    ] as [Some<U8, U8>])
    func integerSquareRootOfSmallNatural(expectation: Some<U8, U8>) throws {
        for type in typesAsBinaryInteger {
            try whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try Ɣexpect(T(expectation.input), isqrt: T(expectation.output))
        }
    }
    
    /// - Note: A binary algorithm may make a correct initial guess here.
    @Test(
        "BinaryInteger/geometry: √(x) of power-of-2 squares",
        arguments: typesAsBinaryInteger, fuzzers
    )   func integerSquareRootOfPowerOf2Squares(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for index in 0 ..< ((IX(size: T.self) ?? 256) / 2) {
                let expectation = T.lsb << index
                let power = expectation << index
                try #require(power.isqrt() == expectation)
            }
        }
    }
    
    @Test(
        "BinaryInteger/geometry: √(x) of negative is nil",
        Tag.List.tags(.random),
        arguments: typesAsBinaryIntegerAsSigned, fuzzers
    )   func integerSquareRootOfNegativeIsNil(type: any SignedInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SignedInteger {
            let low  = T(repeating: Bit.one).up(Shift.max(or: 255))
            let high = T(repeating: Bit.one)
            
            #expect(low .isqrt() == nil)
            #expect(high.isqrt() == nil)
            
            for _ in 0 ..< 32 {
                let random = T.random(in: low...high, using: &randomness)
                try #require(random.isNegative)
                try #require(random.isqrt() == nil)
            }
        }
    }
    
    @Test(
        "BinaryInteger/geometry: √(x) of infinite is nil",
        Tag.List.tags(.random),
        arguments: typesAsArbitraryIntegerAsUnsigned, fuzzers
    )   func integerSquareRootOfInfiniteIsNil(type: any ArbitraryIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsUnsigned {
            let low  = T(repeating: Bit.one).up(Shift.max(or: 255))
            let high = T(repeating: Bit.one)
            
            #expect(low .isqrt() == nil)
            #expect(high.isqrt() == nil)
            
            for _ in 0 ..< 32 {
                let random = T.random(in: low...high, using: &randomness)
                try #require(random.isInfinite)
                try #require(random.isqrt() == nil)
            }
        }
    }
}
