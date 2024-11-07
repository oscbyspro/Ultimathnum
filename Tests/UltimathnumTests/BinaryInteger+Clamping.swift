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
// MARK: * Binary Integer x Clamping
//*============================================================================*

@Suite struct BinaryIntegerTestsOnClamping {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/clamping: comparisons as EdgyInteger",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func comparisonsAsEdgyInteger(randomness: consuming FuzzerInt) throws {
        
        for source in typesAsBinaryInteger {
            for destination in typesAsEdgyInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: BinaryInteger, B: EdgyInteger {
            try withOnlyOneCallToRequire((source, destination)) { require in
                for _ in 0 ..< 32 {
                    let random = A.entropic(through: Shift.max(or: 255), using: &randomness)
                    if  random < B.min {
                        require(B(clamping: random) == B.min)
                    }   else if random > B.max {
                        require(B(clamping: random) == B.max)
                    }   else {
                        require(B(clamping: random) == random)
                    }
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Clamping x Edge Cases
//*============================================================================*

@Suite struct BinaryIntegerTestsOnClampingEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Finite
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/clamping/edge-cases: finite value as LenientInteger is argument",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func finiteValueAsLenientIntegerIsArgument(randomness: consuming FuzzerInt) throws {
        
        for source in typesAsBinaryInteger {
            for destination in typesAsArbitraryIntegerAsSigned {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: BinaryInteger, B: ArbitraryIntegerAsSigned {
            for _ in 0 ..< 32 {
                let random = A.entropic(through: Shift.max(or: 255), as: Domain.finite, using: &randomness)
                try #require(!random.isInfinite)
                let result = try #require(B(clamping: random))
                try #require(result == random)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Negative
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/clamping/edge-cases: negative value as UnsignedInteger is zero",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func negativeValueAsUnsignedIntegerIsZero(randomness: consuming FuzzerInt) throws {
        
        for source in typesAsBinaryIntegerAsSigned {
            for destination in typesAsBinaryIntegerAsUnsigned {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: SignedInteger, B: UnsignedInteger {
            for _ in 0 ..< 32 {
                let random = A.entropic(through: Shift.max(or: 255), as: Domain.natural, using: &randomness).toggled()
                try #require(random.isNegative)
                try #require(B(clamping: random).isZero)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Infinite
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/clamping/edge-cases: infinite value as SystemsInteger is max",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func infiniteValueAsSystemsIntegerIsMaxValue(randomness: consuming FuzzerInt) throws {
        
        for source in typesAsArbitraryIntegerAsUnsigned {
            for destination in typesAsSystemsInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: ArbitraryIntegerAsUnsigned, B: SystemsInteger {
            for _ in 0 ..< 32 {
                let random = A.entropic(size: 256, as: Domain.natural, using: &randomness).toggled()
                try #require(random.isInfinite)
                try #require(B(clamping: random) == B.max)
            }
        }
    }
    
    @Test(
        "BinaryInteger/clamping/edge-cases: infinite value as LenientInteger is nil",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func infiniteValueAsLenientIntegerIsNil(randomness: consuming FuzzerInt) throws {
        
        for source in typesAsArbitraryIntegerAsUnsigned {
            for destination in typesAsArbitraryIntegerAsSigned {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: ArbitraryIntegerAsUnsigned, B: ArbitraryIntegerAsSigned {
            for _ in 0 ..< 32 {
                let random = A.entropic(size: 256, as: Domain.natural, using: &randomness).toggled()
                try #require(random.isInfinite)
                try #require(B(clamping: random) == nil)
            }
        }
    }
    
    @Test(
        "BinaryInteger/clamping/edge-cases: infinite value as MaximumInteger is argument",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func infiniteValueAsMaximumIntegerIsArgument(randomness: consuming FuzzerInt) throws {
        
        for source in typesAsArbitraryIntegerAsUnsigned {
            for destination in typesAsArbitraryIntegerAsUnsigned {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws
        where A: ArbitraryIntegerAsUnsigned, B: ArbitraryIntegerAsUnsigned {
            for _ in 0 ..< 32 {
                let random = A.entropic(size: 256, as: Domain.natural, using: &randomness).toggled()
                try #require(random.isInfinite)
                try #require(B(clamping: random) == random)
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Clamping x Conveniences
//*============================================================================*

@Suite(.tags(.forwarding)) struct BinaryIntegerTestsOnClampingConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/clamping/conveniences: random FiniteInteger as BinaryInteger",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func randomFiniteIntegerAsBinaryInteger(randomness: consuming FuzzerInt) throws {
        
        for source in typesAsFiniteInteger {
            for destination in typesAsBinaryInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws where A: FiniteInteger, B: BinaryInteger {
            try withOnlyOneCallToRequire((source, destination)) { require in
                for _ in 0 ..< 32 {
                    let finite = A.entropic(through: Shift.max(or: 255), using: &randomness)
                    let binary: some BinaryInteger = finite
                    require(B(clamping: binary) == B(clamping: finite) as B)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/clamping/conveniences: random FiniteInteger as EdgyInteger",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func randomBinaryIntegerAsEdgyInteger(randomness: consuming FuzzerInt) throws {
        
        for source in typesAsBinaryInteger {
            for destination in typesAsEdgyInteger {
                try whereIs(source: source, destination: destination)
            }
        }
        
        func whereIs<A, B>(source: A.Type, destination: B.Type) throws where A: BinaryInteger, B: EdgyInteger {
            try withOnlyOneCallToRequire((source, destination)) { require in
                for _ in 0 ..< 32 {
                    let binary = A.entropic(through: Shift.max(or: 255), using: &randomness)
                    require(B(clamping: binary) == B(clamping: binary) as B)
                }
            }
        }
    }
}
