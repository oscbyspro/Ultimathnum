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
// MARK: * Binary Integer x Geometry
//*============================================================================*

@Suite struct BinaryIntegerTestsOnGeometry {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/geometry: √(x) of examples",
        Tag.List.tags(.documentation, .generic),
        ParallelizationTrait.serialized,
        arguments: Array<(I8, I8?)>.infer([
        
        (I8(-1), I8?(nil)),
        (I8( 0), I8?(  0)),
        (I8( 1), I8?(  1)),
        (I8( 2), I8?(  1)),
        (I8( 3), I8?(  1)),
        (I8( 4), I8?(  2)),
        (I8( 5), I8?(  2)),
        (I8( 6), I8?(  2)),
        (I8( 7), I8?(  2)),
        (I8( 8), I8?(  2)),
        (I8( 9), I8?(  3)),
        (I8(10), I8?(  3)),
        (I8(11), I8?(  3)),
        (I8(12), I8?(  3)),
        (I8(13), I8?(  3)),
        (I8(14), I8?(  3)),
        (I8(15), I8?(  3)),
        (I8(16), I8?(  4)),
        
    ])) func integerSquareRootOfExampels(value: I8, isqrt: I8?) throws {
        for type in typesAsBinaryInteger {
            try whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            if  let value = T.exactly(value).optional() {
                let expectation = isqrt.flatMap{T.exactly($0).optional()}
                try #require(value.isqrt() == expectation)
                try Ɣrequire(validating: value, isqrt: expectation)
            }
        }
    }
    
    @Test(
        "BinaryInteger/geometry: √(x) of random",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func integerSquareRootOfNatural(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 32, release: 256) {
                let index = Shift<T.Magnitude>.max(or: 255)
                let value = T.entropic(through: index, using: &randomness)
                try Ɣrequire(validating: value, isqrt: value.isqrt())
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    private func Ɣrequire<T>(
        validating  value: T,
        isqrt expectation: Optional<T>,
        at location: SourceLocation = #_sourceLocation
    )   throws where T: BinaryInteger {
        
        try #require((expectation == nil) == !value.isNatural, sourceLocation: location)
        
        if  let expectation {
            try #require(expectation.isNatural)
            let low = try #require(expectation.squared().optional())
            try #require(value >= low, sourceLocation: location)
            
            let next = try #require(expectation.incremented().optional())
            if  let high = next.squared().optional() {
                try #require(value < high, sourceLocation: location)
            }
        }
    }
}
    
//*============================================================================*
// MARK: * Binary Integer x Geometry x Edge Cases
//*============================================================================*

@Suite struct BinaryIntegerTestsOnGeometryEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/geometry/edge-cases: √(x) of power-of-2 squares",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func integerSquareRootOfPowerOf2Squares(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? 256
            
            for index in 0 ..< size / 2 {
                let expectation = T.lsb << index
                let power = expectation << index
                try #require(power.isqrt() == expectation)
            }
        }
    }
    
    @Test(
        "BinaryInteger/geometry/edge-cases: √(x) of negative is nil",
        Tag.List.tags(.documentation, .generic, .random),
        arguments: typesAsBinaryIntegerAsSigned, fuzzers
    )   func integerSquareRootOfNegativeIsNil(
        type: any SignedInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SignedInteger {
            for _ in 0 ..< 32 {
                let index = Shift<T.Magnitude>.max(or: 255)
                let value = T.entropic(through: index, as: Domain.natural, using: &randomness).toggled()
                try #require(value.isNegative)
                try #require(value.isqrt() == nil)
            }
        }
    }
    
    @Test(
        "BinaryInteger/geometry/edge-cases: √(x) of infinite is nil",
        Tag.List.tags(.documentation, .generic, .random),
        arguments: typesAsArbitraryIntegerAsUnsigned, fuzzers
    )   func integerSquareRootOfInfiniteIsNil(
        type: any ArbitraryIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsUnsigned {
            for _ in 0 ..< 32 {
                let index = Shift<T.Magnitude>.max(or: 255)
                let value = T.entropic(through: index, as: Domain.natural, using: &randomness).toggled()
                try #require(value.isInfinite)
                try #require(value.isqrt() == nil)
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Geometry x Conveniences
//*============================================================================*

@Suite struct BinaryIntegerTestsOnGeometryConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/geometry/conveniences: √(x) as Natural<T>",
        Tag.List.tags(.forwarding, .generic,  .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func integerSquareRootAsNatural(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
     
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let index = Shift<T.Magnitude>.max(or: 255)
                let value = T.entropic(through: index, as: Domain.natural, using: &randomness)
                try #require(value.isNatural)
                let expectation = value.isqrt() as Optional<T>
                try #require(expectation == Natural(value).isqrt() as T)
            }
        }
    }
    
    @Test(
        "BinaryInteger/geometry/conveniences: √(x) as NaturalInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsSystemsIntegerAsUnsigned, fuzzers
    )   func integerSquareRootAsNaturalInteger(
        type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< 32 {
                let value = T.entropic(using: &randomness)
                try #require(value.isNatural)
                let expectation = value.isqrt() as Optional<T>
                try #require(expectation == value.isqrt() as T)
            }
        }
    }
}
