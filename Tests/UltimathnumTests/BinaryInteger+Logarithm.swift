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
// MARK: * Binary Integer x Logarithm
//*============================================================================*

@Suite struct BinaryIntegerTestsOnLogarithm {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/logarithm: ilog2() of examples",
        Tag.List.tags(.documentation, .generic),
        ParallelizationTrait.serialized,
        arguments: Array<(I8, Count?)>([
        
            (value: -1 as I8, ilog2: nil),
            (value:  0 as I8, ilog2: nil),
            (value:  1 as I8, ilog2: Count(0)),
            (value:  2 as I8, ilog2: Count(1)),
            (value:  3 as I8, ilog2: Count(1)),
            (value:  4 as I8, ilog2: Count(2)),
            (value:  5 as I8, ilog2: Count(2)),
            (value:  6 as I8, ilog2: Count(2)),
            (value:  7 as I8, ilog2: Count(2)),
            (value:  8 as I8, ilog2: Count(3)),
            (value:  9 as I8, ilog2: Count(3)),
            (value: 10 as I8, ilog2: Count(3)),
            (value: 11 as I8, ilog2: Count(3)),
            (value: 12 as I8, ilog2: Count(3)),
            (value: 13 as I8, ilog2: Count(3)),
            (value: 14 as I8, ilog2: Count(3)),
            (value: 15 as I8, ilog2: Count(3)),
            (value: 16 as I8, ilog2: Count(4)),
        
    ])) func ilog2OfExamples(value: I8, ilog2: Count?) throws {
        for type in typesAsBinaryInteger {
            try whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            if  let value = T.exactly(value).optional() {
                try #require(value.ilog2()  ==  ilog2)
                try Ɣrequire(validating: value, ilog2: ilog2)
            }
        }
    }
    
    @Test(
        "BinaryInteger/logarithm: ilog2() of random",
        Tag.List.tags(.random, .generic),
        arguments: typesAsBinaryInteger, fuzzers
    )   func ilog2OfRandom(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 32, release: 256) {
                let index = Shift<T.Magnitude>.max(or: 255)
                let value = T.entropic(through: index, using: &randomness)
                try Ɣrequire(validating: value, ilog2: value.ilog2())
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    private func Ɣrequire<T>(
        validating  value: T,
        ilog2 expectation: Optional<Count>,
        at location: SourceLocation = #_sourceLocation
    )   throws where T: BinaryInteger {
        
        try #require((expectation == nil) == !value.isPositive, sourceLocation: location)
        
        if  let expectation {
            try #require(expectation < T.size, sourceLocation: location)
            try #require(expectation.isInfinite == value.isInfinite, sourceLocation: location)
            
            if !expectation.isInfinite {
                let low = T.lsb.up(expectation)
                try #require(value >= low, sourceLocation: location)
                
                if  let high = low.times(2).optional() {
                    try #require(value < high, sourceLocation: location)
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Logarithm x Edge Cases
//*============================================================================*

@Suite struct BinaryIntegerTestsOnLogarithmEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/logarithm/edge-cases: ilog2 of zero is nil",
        Tag.List.tags(.documentation, .exhaustive, .generic),
        arguments: typesAsBinaryInteger
    )   func ilog2OfZeroIsNil(type: any BinaryInteger.Type) throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            #expect(T.zero.ilog2() == nil)
        }
    }
    
    @Test(
        "BinaryInteger/logarithm/edge-cases: ilog2 of negative is nil",
        Tag.List.tags(.documentation, .generic,.random),
        arguments: typesAsBinaryIntegerAsSigned, fuzzers
    )   func ilog2OfNegativeIsNil(
        type: any SignedInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SignedInteger {
            for _ in 0 ..< 32 {
                let index = Shift<T.Magnitude>.max(or: 255)
                let value = T.entropic(through: index, as: Domain.natural, using: &randomness).toggled()
                try #require(value.isNegative)
                try #require(value.ilog2() == nil)
            }
        }
    }
    
    @Test(
        "BinaryInteger/logarithm/edge-cases: log2() of infinite is size - 1",
        Tag.List.tags(.documentation, .generic, .random),
        arguments: typesAsArbitraryIntegerAsUnsigned, fuzzers
    )   func ilog2OfInfiniteIsOneLessThanSize(
        type: any ArbitraryIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsUnsigned {
            for _ in 0 ..< 32 {
                let index = Shift<T.Magnitude>.max(or: 255)
                let value = T.entropic(through: index, as: Domain.natural, using: &randomness).toggled()
                try #require(value.isInfinite)
                try #require(value.ilog2() == Count(raw: -2))
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Logarithm x Conveniences
//*============================================================================*

@Suite struct BinaryIntegerTestsOnLogarithmConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/logarithm/conveniences: ilog2() as Nonzero<Magnitude>",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryIntegerAsUnsigned, fuzzers
    )   func ilog2AsNonzeroMagnitude(
        type: any UnsignedInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: UnsignedInteger {
            for _ in 0 ..< 32 {
                let index = Shift<T.Magnitude>.max(or: 255)
                let value = T.entropic(through: index, as: Domain.natural, using: &randomness)
                if  let nonzero = Nonzero(exactly: value) {
                    try #require(value.isPositive)
                    let expectation = value.ilog2() as Count?
                    try #require(expectation == nonzero.ilog2() as Count)
                }
            }
        }
    }
}
