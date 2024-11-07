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
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Factorization
//*============================================================================*

@Suite struct BinaryIntegerTestsOnFactorization {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// - Note: This is just a fun fact.
    @Test("BinaryInteger/factorization: GCD(fib(x), fib(x+1)) == 1")
    func fibonacciSequencePairsAreCoprime() throws {
        var low  = U64(0)
        var high = U64(1)
        
        while let next = low.plus(high).optional() {
            try #require(low.euclidean(high) == 1)
            low  = high
            high = next
        }
        
        try #require(low  == 07540113804746346429)
        try #require(high == 12200160415121876738)
    }
    
    /// Checks that our small prime collection consists of primes.
    @Test("BinaryInteger/factorization: GCD(prime, 2 ..< prime) == 1")
    func greatestCommonDivisorForEachSmallPrimeFromZeroThroughItself() throws {
        try withOnlyOneCallToRequire { require in
            for prime in primes54 {
                require(prime.euclidean(00000) == prime)
                require(prime.euclidean(00001) == 00001)
                require(prime.euclidean(prime) == prime)
                
                for other in 2 ..< prime {
                    require(prime.euclidean(other) == 1)
                    require(prime.remainder(other) != 0)
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/factorization: find (x, y) in GCD(a, b) == a * x + b * y",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func bezout(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let lhs = T.entropic(through: Shift.max(or: 127), as: Domain.finite, using: &randomness)
                let rhs = T.entropic(through: Shift.max(or: 127), as: Domain.finite, using: &randomness)
                let bezout = try #require(lhs.bezout(rhs))
                
                try #require(bezout.divisor == lhs.euclidean(rhs), "GCD")
                
                always: do {
                    let a = IXL(lhs) * IXL(bezout.lhsCoefficient)
                    let b = IXL(rhs) * IXL(bezout.rhsCoefficient)
                    try #require(a + b == bezout.divisor, "bézout identity")
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/factorization: GCD(a, b) vs prime multiplication",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func greatestCommonDivisorVersusPrimeMultiplication(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let primes = primes54.compactMap{T.exactly($0).optional()}
            for _ in 0 ..< conditional(debug: 16, release: 64) {
                var lhs: T = 1
                var rhs: T = 1
                var divisor: T.Magnitude = 1
                var lhsCount = Array(repeating: UX.zero, count: primes.count)
                var rhsCount = Array(repeating: UX.zero, count: primes.count)
                
                for _ in 0 ..< Swift.Int(IX.random(in: 2...32, using: &randomness)) {
                    let index = (primes).indices.randomElement(using: &randomness.stdlib)!
                    let lhsInsert = Bool.random(using: &randomness.stdlib)
                    let rhsInsert = Bool.random(using: &randomness.stdlib)
                    
                    if (lhsInsert), let next = lhs.times(primes[index]).optional() {
                        lhs = next; lhsCount[index] += 1
                    }
                    
                    if (rhsInsert), let next = rhs.times(primes[index]).optional() {
                        rhs = next; rhsCount[index] += 1
                    }
                }
                
                if  T.isSigned, Bool.random(using: &randomness.stdlib) {
                    try #require(!lhs.negate().error)
                }
                
                if  T.isSigned, Bool.random(using: &randomness.stdlib) {
                    try #require(!rhs.negate().error)
                }
                
                for index in primes.indices {
                    let exponent = Swift.min(lhsCount[index], rhsCount[index])
                    if !exponent.isZero {
                        let base: T.Magnitude = primes[index].magnitude()
                        let power = base.power(exponent, coefficient: divisor)
                        divisor = try #require(power.optional())
                    }
                }
                
                try #require(divisor == lhs.euclidean(rhs))
                try #require(divisor == lhs.bezout(rhs)?.divisor)
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Factorization x Edge Cases
//*============================================================================*

@Suite struct BinaryIntegerTestsOnFactorizationEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/factorization/edge-cases: GCD(x, ∞) == nil",
        Tag.List.tags(.generic, .random),
        arguments: typesAsArbitraryIntegerAsUnsigned, fuzzers
    )   func greatestCommonDivisorOfInfiniteIsNil(type: any ArbitraryIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsUnsigned {
            for _ in 0 ..< 32 {
                let a = T.entropic(through: Shift.max(or: 127), as: Domain.finite, using: &randomness)
                let b = T.entropic(through: Shift.max(or: 127), as: Domain.finite, using: &randomness).toggled()
                
                try #require(a.isInfinite == false)
                try #require(b.isInfinite)
                
                try #require(a.bezout   (b) == nil)
                try #require(b.bezout   (a) == nil)
                try #require(b.bezout   (b) == nil)
                try #require(a.euclidean(b) == nil)
                try #require(b.euclidean(a) == nil)
                try #require(b.euclidean(b) == nil)
            }
        }
    }
    
    @Test(
        "BinaryInteger/factorization/edge-cases: GCD(x, x) == |x|",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func greatestCommonDivisorOfDuplicateIsMagnitude(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let random = T.entropic(through: Shift.max(or: 127), as: Domain.finite, using: &randomness)
                let expectation = random.magnitude()
                
                try #require(expectation == random.euclidean(random))
                try #require(expectation == random.bezout(T.zero)?.divisor)
            }
        }
    }
    
    @Test(
        "BinaryInteger/factorization/edge-cases: GCD(x, 0) == |x|",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func greatestCommonDivisorOfZeroAndOtherIsMagnitudeOfOther(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let random = T.entropic(through: Shift.max(or: 127), as: Domain.finite, using: &randomness)
                let expectation = random.magnitude()
                
                try #require(expectation == random.euclidean(T.zero))
                try #require(expectation == T.zero.euclidean(random))
                
                try #require(expectation == random.bezout(T.zero)?.divisor)
                try #require(expectation == T.zero.bezout(random)?.divisor)
            }
        }
    }
    
    @Test(
        "BinaryInteger/factorization/edge-cases: GCD(x, 1) == 1",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func greatestCommonDivisorOfOneAndOtherIsOne(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let random = T.entropic(through: Shift.max(or: 127), as: Domain.finite, using: &randomness)
                let expectation = T.Magnitude.lsb
                
                try #require(expectation == random.euclidean(T.lsb))
                try #require(expectation == T.lsb.euclidean(random))
                
                try #require(expectation == random.bezout(T.lsb)?.divisor)
                try #require(expectation == T.lsb.bezout(random)?.divisor)
            }
        }
    }
    
    @Test(
        "BinaryInteger/factorization/edge-cases: GCD(a, b) == GCD(b, a)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func greatestCommonDivisorIsCommutative(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let lhs = T.entropic(through: Shift.max(or: 127), as: Domain.finite, using: &randomness)
                let rhs = T.entropic(through: Shift.max(or: 127), as: Domain.finite, using: &randomness)
                
                try #require(lhs.euclidean(rhs) == rhs.euclidean(lhs))
                try #require(lhs.bezout(rhs)?.divisor == rhs.bezout(lhs)?.divisor)
            }
        }
    }
    
    @Test(
        "BinaryInteger/factorization/edge-cases: GCD(a, b) == GCD(±a, ±b)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryIntegerAsSigned, fuzzers
    )   func greatestCommonDivisorIsSignAgnostic(type: any SignedInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SignedInteger {
            for _ in 0 ..< 32 {
                let lhs = T.entropic(through: Shift.max(or: 127), using: &randomness)
                let rhs = T.entropic(through: Shift.max(or: 127), using: &randomness)
                let expectation: T.Magnitude? = lhs.magnitude().euclidean(rhs.magnitude())
                try #require(expectation == lhs.euclidean(rhs))
                try #require(expectation == lhs.bezout(rhs).divisor)
            }
        }
    }
    
    @Test(
        "BinaryInteger/factorization/edge-cases: GCD(a, b) == GCD(a, b % a)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func greatestCommonDivisorRemainderInvariant(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 8 {
                let lhs = T.entropic(through: Shift.max(or: 127), as: Domain.finite, using: &randomness)
                let rhs = T.entropic(through: Shift.max(or: 127), as: Domain.finite, using: &randomness)
                
                if  let remainder: T = rhs.remainder(lhs) {
                    let expectation: T.Magnitude? = lhs.euclidean(rhs)
                    try #require(expectation == lhs.euclidean(remainder))
                    try #require(expectation == lhs.bezout(remainder)?.divisor)
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Factorization x Conveniences
//*============================================================================*

@Suite(.tags(.forwarding)) struct BinaryIntegerTestsOnFactorizationConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Finite
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/factorization/edge-cases: bezout(_:) as Finite<T>",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func bezoutAsFinite(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 4 {
                let lhs = T.entropic(through: Shift.max(or: 127), as: Domain.finite, using: &randomness)
                let rhs = T.entropic(through: Shift.max(or: 127), as: Domain.finite, using: &randomness)
                let expectation: Optional<Bezout<T.Magnitude>> = lhs.bezout(rhs)
                try #require(expectation == Finite(lhs).bezout(Finite(rhs)) as Bezout<T.Magnitude>)
            }
        }
    }
    
    @Test(
        "BinaryInteger/factorization/edge-cases: bezout(_:) as FiniteInteger",
        Tag.List.tags(.generic, .random),
        arguments: typesAsFiniteInteger, fuzzers
    )   func bezoutAsFiniteInteger(type: any FiniteInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: FiniteInteger {
            for _ in 0 ..< 4 {
                let lhs = T.entropic(through: Shift.max(or: 127), using: &randomness)
                let rhs = T.entropic(through: Shift.max(or: 127), using: &randomness)
                let expectation: Optional<Bezout<T.Magnitude>> = lhs.bezout(rhs)
                try #require(expectation == lhs.bezout(rhs) as Bezout<T.Magnitude>)
            }
        }
    }
    
    @Test(
        "BinaryInteger/factorization/edge-cases: euclidean(_:) as Finite<T>",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func greatestCommonDivisorAsFinite(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 4 {
                let lhs = T.entropic(through: Shift.max(or: 127), as: Domain.finite, using: &randomness)
                let rhs = T.entropic(through: Shift.max(or: 127), as: Domain.finite, using: &randomness)
                let expectation: Optional<T.Magnitude> = lhs.euclidean(rhs)
                try #require(expectation == Finite(lhs).euclidean(Finite(rhs)) as T.Magnitude)
            }
        }
    }
    
    @Test(
        "BinaryInteger/factorization/edge-cases: euclidean(_:) as FiniteInteger",
        Tag.List.tags(.generic, .random),
        arguments: typesAsFiniteInteger, fuzzers
    )   func greatestCommonDivisorAsFiniteInteger(type: any FiniteInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: FiniteInteger {
            for _ in 0 ..< 4 {
                let lhs = T.entropic(through: Shift.max(or: 127), using: &randomness)
                let rhs = T.entropic(through: Shift.max(or: 127), using: &randomness)
                let expectation: Optional<T.Magnitude> = lhs.euclidean(rhs)
                try #require(expectation == lhs.euclidean(rhs) as T.Magnitude)
            }
        }
    }
}
