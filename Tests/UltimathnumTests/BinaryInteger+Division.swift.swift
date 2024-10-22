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
// MARK: * Binary Integer x Division
//*============================================================================*

@Suite struct BinaryIntegerTestsOnDivision {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/division - signs",
        Tag.List.tags(.documentation, .generic),
        ParallelizationTrait.serialized,
        arguments: [
        
        (dividend:  7 as I8, divisor:  3 as I8, quotient:  2 as I8, remainder:  1 as I8),
        (dividend:  7 as I8, divisor: -3 as I8, quotient: -2 as I8, remainder:  1 as I8),
        (dividend: -7 as I8, divisor:  3 as I8, quotient: -2 as I8, remainder: -1 as I8),
        (dividend: -7 as I8, divisor: -3 as I8, quotient:  2 as I8, remainder: -1 as I8),
        
    ] as [(I8, I8, I8, I8)])
    func signs(dividend: I8, divisor: I8, quotient: I8, remainder: I8) {
        for type in typesAsBinaryIntegerAsSigned {
            whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) where T: SignedInteger {
            let dividend  = T(dividend )
            let divisor   = T(divisor  )
            let quotient  = T(quotient )
            let remainder = T(remainder)
            let division  = Fallible(Division(quotient: quotient, remainder: remainder))
            Ɣexpect(bidirectional: dividend, by: Nonzero(divisor), is: division)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/division: for each 8-bit integer pair [1-by-1]",
        Tag.List.tags(.exhaustive, .generic),
        arguments: typesAsCoreIntegerAsByte
    )   func division11ForEachEightBitIntegerPair(type: any SystemsInteger.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            var success = IX.zero
                        
            for dividend in T.all {
                for divisor in T.all {
                    guard let divisor = Nonzero(exactly: divisor) else { continue }
                    let division: Fallible<Division> = dividend.division(divisor)
                    let reconstitution = division.value.dividend(divisor)
                    success &+= IX(Bit(reconstitution.value == dividend))
                    success &+= IX(Bit(reconstitution.error == division.error))
                }
            }
            
            #expect(success == 2 &* IX(T.all.count) &* IX(T.all.count - 1))
        }
    }
    
    @Test(
        "BinaryInteger/division: 1-by-1 division of random by random",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func division11OfRandomByRandom(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 64,  release: 1024) {
                let dividend = T.entropic(through: Shift.max(or: 255), as: Domain.finite, using: &randomness)
                let divisor  = T.entropic(through: Shift.max(or: 255), as: Domain.binary, using: &randomness)
                Ɣexpect(bidirectional: dividend, by: divisor)
            }
        }
    }
    
    @Test(
        "BinaryInteger/division: random by power-of-2-esque [1-by-1]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func division11OfRandomByPowerOf2Esque(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let distance = Shift<T.Magnitude>.random(through: Shift.max(or: 255), using: &randomness)
                let dividend = T.entropic(through: Shift.max(or: 255), as: Domain.finite, using: &randomness)
                var divisor  = T.lsb.up(distance)
                //  magnitude is a power of 2
                if  T.isSigned, Bool.random(using: &randomness.stdlib) {
                    divisor.negate().discard()
                }
                
                if  let divisor = Nonzero(exactly: divisor) {
                    let sign = Sign(raw: dividend.isNegative != divisor.value.isNegative)
                    let quotient  = T.exactly(sign: sign, magnitude: dividend.magnitude().down(distance))
                    let remainder = dividend.minus(quotient.value.times(divisor.value).value).value
                    let division  = Fallible(Division(quotient: quotient.value, remainder: remainder), error: quotient.error)
                    Ɣexpect(bidirectional: dividend, by: divisor, is: division)
                }   else {
                    Ɣexpect(bidirectional: dividend, by: divisor, is: nil)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/division: ascending zeros by ascending zeros [1-by-1]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func division11OfAscendingZerosByAscendingZeros(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            func next(preshift domain: Domain) -> T {
                let next = T.entropic(through: Shift.max(or: 0000000000127), as: domain, using: &randomness)
                return next.drain(Bit.zero).up(Shift.random(through: Shift.max(or: 127), using: &randomness))
            }
            
            for _ in 0 ..< conditional(debug: 64,  release: 1024) {
                let dividend = next(preshift: Domain.finite)
                let divisor  = next(preshift: Domain.binary)
                Ɣexpect(bidirectional: dividend, by: divisor)
            }
        }
    }
    
    @Test(
        "BinaryInteger/division: contiguous ones by contiguous ones [1-by-1]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func division11OfContiguousOnesByContiguousOnes(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            func next() -> T {
                var next = T(repeating: Bit.one)
                next = next.up(Shift.random(through: Shift.max(or: 127), using: &randomness))
                next = next.toggled()
                return next.up(Shift.random(through: Shift.max(or: 127), using: &randomness))
            }
            
            for _ in 0 ..< conditional(debug:  64, release: 1024) {
                Ɣexpect(bidirectional: next(), by: next())
            }
        }
    }
    
    @Test(
        "BinaryInteger/division: silly big by silly big [1-by-1]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsArbitraryInteger, fuzzers
    )   func division11OfSillyBigBySillyBig(type: any ArbitraryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryInteger {
            let size: IX = conditional(debug: 1024, release: 8192)
            for _ in 0 ..< conditional(debug: 0016, release: 0064) {
                let dividend = T.entropic(size: size, as: Domain.finite, using: &randomness)
                let divisor  = T.entropic(size: size, as: Domain.finite, using: &randomness)
                //  one round-trip for performance
                if  let divisor  = Nonzero(exactly: divisor) {
                    let division = try #require(dividend.division(divisor)?.optional())
                    let reconstitution = try #require(division.dividend(divisor).optional())
                    #expect(dividend  == reconstitution)
                }   else {
                    Ɣexpect(bidirectional: dividend, by: divisor, is: nil)
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 2 by 1
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/division: random by random [2-by-1]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func division21OfRandomByRandom(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            for _ in 0 ..< conditional(debug: 128, release: 1024) {
                let low  = T.Magnitude.entropic(using: &randomness)
                let high = T.Magnitude.entropic(using: &randomness)
                let dividend = Doublet(low: low, high: T(raw: high))
                let divisor  = T.entropic(using: &randomness)
                Ɣexpect(bidirectional: dividend, by: divisor)
            }
        }
    }
    
    @Test(
        "BinaryInteger/division: random by power-of-2-esque [2-by-1]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func division21OfRandomByPowerOf2Esque(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            for _ in 0 ..< conditional(debug: 128, release: 1024) {
                let distance = Shift<T.Magnitude>.random(using: &randomness)
                let low  = T.Magnitude.entropic(using: &randomness)
                let high = T.Magnitude.entropic(using: &randomness)
                let dividend = Doublet(low: low, high: T(raw: high))
                var divisor  = T.lsb.up(distance)
                //  magnitude is a power of 2
                if  T.isSigned, Bool.random(using: &randomness.stdlib) {
                    divisor.negate().discard()
                }
                
                Ɣexpect(bidirectional: dividend, by: divisor)
            }
        }
    }
    
    @Test(
        "BinaryInteger/division: ascending zeros by ascending zeros [2-by-1]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func division21OfAscendingZerosByAscendingZeros(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)

        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            for _ in 0 ..< conditional(debug: 128, release: 1024) {
                var low     = T.Magnitude.entropic(using: &randomness)
                var high    = T.Magnitude.entropic(using: &randomness)
                var divisor = T.entropic(using: &randomness)
                
                low     = low    .drain(Bit.zero).up(Shift.random(using: &randomness))
                high    = high   .drain(Bit.zero).up(Shift.random(using: &randomness))
                divisor = divisor.drain(Bit.zero).up(Shift.random(using: &randomness))
                
                Ɣexpect(bidirectional: Doublet(low: low, high: T(raw: high)), by: divisor)
            }
        }
    }
    
    @Test(
        "BinaryInteger/division: one half by random [2-by-1]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func division21OfOneHalfByRandom(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            for _ in 0 ..< conditional(debug: 128, release: 1024) {
                let low  = T.entropic(using: &randomness)
                let high = T.init(repeating: low.appendix)
                let dividend = Doublet(low: T.Magnitude(raw: low), high: high)
                let divisor  = T.entropic(using: &randomness)
                let division = Nonzero(exactly:  divisor).flatMap {
                    low.division($0)
                }
                
                Ɣexpect(bidirectional: dividend, by: divisor, is: division)
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Division x Edge Cases
//*============================================================================*

@Suite(.tags(.documentation)) struct BinaryIntegerTestsOnDivisionEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 1 by 1
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/division: random by zero is nil [1-by-1]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func division11OfRandomByZeroIsNil(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 32, release: 256) {
                let dividend = T.entropic(through: Shift.max(or: 255), using: &randomness)
                Ɣexpect(bidirectional: dividend, by: T.zero, is: nil)
            }
        }
    }
    
    @Test(
        "BinaryInteger/division: T.min by -1 as signed systems integers is error [1-by-1]",
        Tag.List.tags(.exhaustive, .generic),
        arguments: typesAsSystemsIntegerAsSigned
    )   func division11OfMinByNegativeOneAsSignedSystemsIntegerIsError(type: any SystemsIntegerAsSigned.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerAsSigned {
            let division = Fallible(Division(quotient: T.min, remainder: T.zero), error: true)
            Ɣexpect(bidirectional: T.min, by: -1, is: division)
        }
    }
    
    @Test(
        "BinaryInteger/division: finite by infinite is trivial [1-by-1]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsArbitraryIntegerAsUnsigned, fuzzers
    )   func division11OfFiniteByInfiniteIsTrivial(type: any ArbitraryIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsUnsigned {
            let low  = T(repeating: Bit.one).up(Shift.max(or: 255))
            let high = T(repeating: Bit.one)
            let top  = low.toggled()
            
            for _ in 0 ..< conditional(debug: 32, release: 256) {
                let dividend = T.random(in: T(1)...top, using: &randomness)
                let divisor  = T.random(in: low...high, using: &randomness)
                let division = Fallible(Division(quotient: T.zero, remainder: dividend))
                Ɣexpect(bidirectional: dividend, by: divisor, is: division)
            }
        }
    }
    
    @Test(
        "BinaryInteger/division: infinite by random is nil [1-by-1]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsArbitraryIntegerAsUnsigned, fuzzers
    )   func division11OfInfiniteByRandomIsNil(type: any ArbitraryIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
                
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsUnsigned {
            let low  = T(repeating: Bit.one).up(Shift.max(or: 255))
            let high = T(repeating: Bit.one)
            
            for _ in 0 ..< conditional(debug: 32, release: 256) {
                let dividend = T.random(in: low...high, using: &randomness)
                let divisor  = T.entropic(through: Shift.max(or: 255), using: &randomness)
                #expect(dividend.isInfinite)
                Ɣexpect(bidirectional: dividend, by: divisor, is: nil)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 2 by 1
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/division: random by zero is nil [2-by-1]",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func division21OfRandomByZeroIsNil(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            for _ in 0 ..< conditional(debug: 32, release: 256) {
                let low  = T.Magnitude.entropic(using: &randomness)
                let high = T.Magnitude.entropic(using: &randomness)
                let dividend = Doublet(low: low, high: T(raw: high))
                Ɣexpect(bidirectional: dividend, by: T.zero, is: nil)
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Division x Conveniences
//*============================================================================*

@Suite(.tags(.forwarding)) struct BinaryIntegerTestsOnDivisionVersusConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/division/conveniences: as BinaryInteger",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func divisionOfRandomByRandomAsBinaryInteger(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let dividend  = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let divisor   = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let quotient  = dividend.quotient (divisor) as Optional<Fallible<T>>
                let remainder = dividend.remainder(divisor) as Optional<T>
                let division  = dividend.division (divisor) as Optional<Fallible<Division<T, T>>>
                
                try #require(division?.map(\.quotient) == quotient )
                try #require(division?.value.remainder == remainder)
                
                try #require(nil == dividend.quotient (T.zero) as Optional<Fallible<T>>)
                try #require(nil == dividend.remainder(T.zero) as Optional<T>)
                try #require(nil == dividend.division (T.zero) as Optional<Fallible<Division<T, T>>>)
                
                if  let divisor = Nonzero(exactly: divisor) {
                    try #require(quotient  == dividend.quotient (divisor) as Optional<Fallible<T>>)
                    try #require(remainder == dividend.remainder(divisor) as Optional<T>)
                    try #require(division  == dividend.division (divisor) as Optional<Fallible<Division<T, T>>>)
                }
                
                if  let division = division?.optional() {
                    try #require(division.quotient  == reduce(dividend, /,  divisor))
                    try #require(division.quotient  == reduce(dividend, /=, divisor))
                    try #require(division.remainder == reduce(dividend, %,  divisor))
                    try #require(division.remainder == reduce(dividend, %=, divisor))
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Finite
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/division/conveniences: as FiniteInteger",
        Tag.List.tags(.generic, .random),
        arguments: typesAsFiniteInteger, fuzzers
    )   func divisionOfRandomAsFiniteInteger(type: any FiniteInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: FiniteInteger {
            for _ in 0 ..< 32 {
                let dividend  = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let divisor   = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let quotient  = dividend.quotient (divisor) as Optional<Fallible<T>>
                let remainder = dividend.remainder(divisor) as Optional<T>
                let division  = dividend.division (divisor) as Optional<Fallible<Division<T, T>>>
                
                try #require(division?.map(\.quotient) == quotient )
                try #require(division?.value.remainder == remainder)
                
                if  let divisor = Nonzero(exactly: divisor) {
                    try #require(quotient  == dividend.quotient (divisor) as Fallible<T>)
                    try #require(remainder == dividend.remainder(divisor) as T)
                    try #require(division  == dividend.division (divisor) as Fallible<Division<T, T>>)
                }
                
                if  let division = division?.optional() {
                    try #require(division.quotient  == reduce(dividend, /,  divisor))
                    try #require(division.quotient  == reduce(dividend, /=, divisor))
                    try #require(division.remainder == reduce(dividend, %,  divisor))
                    try #require(division.remainder == reduce(dividend, %=, divisor))
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/division/conveniences: as Finite<Value>",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func divisionOfRandomAsFinite(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let dividend  = T.entropic(through: Shift.max(or: 255), as: .finite, using: &randomness)
                let divisor   = T.entropic(through: Shift.max(or: 255), as: .binary, using: &randomness)
                let quotient  = dividend.quotient (divisor) as Optional<Fallible<T>>
                let remainder = dividend.remainder(divisor) as Optional<T>
                let division  = dividend.division (divisor) as Optional<Fallible<Division<T, T>>>
                
                try #require(division?.map(\.quotient) == quotient )
                try #require(division?.value.remainder == remainder)
                
                if  let dividend = Finite(exactly: dividend), let divisor = Nonzero(exactly: divisor) {
                    try #require(quotient  == dividend.quotient (divisor) as Fallible<T>)
                    try #require(remainder == dividend.remainder(divisor) as T)
                    try #require(division  == dividend.division (divisor) as Fallible<Division<T, T>>)
                }
                
                if  let division = division?.optional() {
                    try #require(division.quotient  == reduce(dividend, /,  divisor))
                    try #require(division.quotient  == reduce(dividend, /=, divisor))
                    try #require(division.remainder == reduce(dividend, %,  divisor))
                    try #require(division.remainder == reduce(dividend, %=, divisor))
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Lenient
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/division/conveniences: as LenientInteger",
        Tag.List.tags(.generic, .random),
        arguments: typesAsArbitraryIntegerAsSigned, fuzzers
    )   func divisionOfRandomAsLenientInteger(type: any ArbitraryIntegerAsSigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsSigned {
            for _ in 0 ..< 32 {
                let dividend  = T.entropic(size: 256, using: &randomness)
                let divisor   = T.entropic(size: 256, using: &randomness)
                let quotient  = dividend.quotient (divisor) as Optional<Fallible<T>>
                let remainder = dividend.remainder(divisor) as Optional<T>
                let division  = dividend.division (divisor) as Optional<Fallible<Division<T, T>>>
                
                try #require(division?.map(\.quotient) == quotient )
                try #require(division?.value.remainder == remainder)
                
                try #require(nil == dividend.quotient (T.zero) as Optional<T>)
                try #require(nil == dividend.remainder(T.zero) as Optional<T>)
                try #require(nil == dividend.division (T.zero) as Optional<Division<T, T>>)
                
                try #require(quotient?.optional() == dividend.quotient (divisor) as Optional<T>)
                try #require(remainder            == dividend.remainder(divisor) as Optional<T>)
                try #require(division?.optional() == dividend.division (divisor) as Optional<Division<T, T>>)
                
                if  let divisor = Nonzero(exactly: divisor) {
                    try #require(quotient?.optional() == dividend.quotient (divisor) as T)
                    try #require(remainder            == dividend.remainder(divisor) as T)
                    try #require(division?.optional() == dividend.division (divisor) as Division<T, T>)
                }
                
                if  let division = division?.optional() {
                    try #require(division.quotient  == reduce(dividend, /,  divisor))
                    try #require(division.quotient  == reduce(dividend, /=, divisor))
                    try #require(division.remainder == reduce(dividend, %,  divisor))
                    try #require(division.remainder == reduce(dividend, %=, divisor))
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Natural
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/division/conveniences: as NaturalInteger",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsIntegerAsUnsigned, fuzzers
    )   func divisionOfRandomAsNaturalInteger(type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< 32 {
                let dividend  = T.entropic(using: &randomness)
                let divisor   = T.entropic(using: &randomness)
                let quotient  = dividend.quotient (divisor) as Optional<Fallible<T>>
                let remainder = dividend.remainder(divisor) as Optional<T>
                let division  = dividend.division (divisor) as Optional<Fallible<Division<T, T>>>
                
                try #require(division?.map(\.quotient) == quotient )
                try #require(division?.value.remainder == remainder)
                
                try #require(nil == dividend.quotient (T.zero) as Optional<T>)
                try #require(nil == dividend.remainder(T.zero) as Optional<T>)
                try #require(nil == dividend.division (T.zero) as Optional<Division<T, T>>)
                
                try #require(quotient?.optional() == dividend.quotient (divisor) as Optional<T>)
                try #require(remainder            == dividend.remainder(divisor) as Optional<T>)
                try #require(division?.optional() == dividend.division (divisor) as Optional<Division<T, T>>)
                
                if  let divisor = Nonzero(exactly: divisor) {
                    try #require(quotient?.optional() == dividend.quotient (divisor) as T)
                    try #require(remainder            == dividend.remainder(divisor) as T)
                    try #require(division?.optional() == dividend.division (divisor) as Division<T, T>)
                }
                
                if  let division = division?.optional() {
                    try #require(division.quotient  == reduce(dividend, /,  divisor))
                    try #require(division.quotient  == reduce(dividend, /=, divisor))
                    try #require(division.remainder == reduce(dividend, %,  divisor))
                    try #require(division.remainder == reduce(dividend, %=, divisor))
                }
            }
            
            for _ in 0 ..< 32 {
                let dividend = T.entropic(using: &randomness)
                let divisor  = T.entropic(using: &randomness)
                
                guard let divisor = Nonzero(exactly: divisor) else { continue }
                let divider = Divider(divisor) as Divider as Divider as Divider
                
                let baseline: Optional = dividend.division(divisor)
                let division: Division = dividend.division(divider)
                let quotient: T        = dividend.quotient(divider)
                
                try #require(baseline == Fallible(division))
                try #require(baseline?.map(\.quotient) == Fallible(quotient))
            }
        }
    }
    
    @Test(
        "BinaryInteger/division/conveniences: as Natural<Value>",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func divisionOfRandomAsNatural(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let dividend  = T.entropic(through: Shift.max(or: 255), as: .natural, using: &randomness)
                let divisor   = T.entropic(through: Shift.max(or: 255), as: .binary,  using: &randomness)
                let quotient  = dividend.quotient (divisor) as Optional<Fallible<T>>
                let remainder = dividend.remainder(divisor) as Optional<T>
                let division  = dividend.division (divisor) as Optional<Fallible<Division<T, T>>>
                
                try #require(division?.map(\.quotient) == quotient )
                try #require(division?.value.remainder == remainder)
                
                if  let dividend = Natural(exactly: dividend), let divisor = Nonzero(exactly: divisor) {
                    try #require(quotient?.optional() == dividend.quotient(divisor) as T)
                    try #require(division?.optional() == dividend.division(divisor) as Division<T, T>)
                }
                
                if  let division = division?.optional() {
                    try #require(division.quotient  == reduce(dividend, /,  divisor))
                    try #require(division.quotient  == reduce(dividend, /=, divisor))
                    try #require(division.remainder == reduce(dividend, %,  divisor))
                    try #require(division.remainder == reduce(dividend, %=, divisor))
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Division x Open Source Issues
//*============================================================================*

@Suite(.tags(.opensource)) struct BinaryIntegerTestsOnDivisionOpenSourceIssues {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// https://github.com/oscbyspro/Numberick/issues/101
    ///
    /// - Note: Checks whether the 3212-path knows when the quotient fits.
    ///
    @Test(arguments: typesAsBinaryInteger)
    func sourceIsGitHubOscbysproNumberickIssues101(_ type: any BinaryInteger.Type) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            if  T.size >= Count(256) {
                let dividend  = try #require(T("000000000000000000003360506852691063560493141264855294697309369118818719524903"))
                let divisor   = try #require(T("000000000000000000000000000000000000000038792928317726192474768301090870907748"))
                let quotient  = try #require(T("000000000000000000000000000000000000000000000000000000000086626789943967710436"))
                let remainder = try #require(T("000000000000000000000000000000000000000016136758413064865246015978698186666775"))
                Ɣexpect(bidirectional: dividend, by: divisor, is: Fallible(Division(quotient: quotient, remainder: remainder)))
            }
        }
    }
    
    /// https://github.com/apple/swift-numerics/issues/272
    ///
    /// - Note: Said to crash and/or return incorrect results.
    ///
    @Test(arguments: typesAsBinaryInteger)
    func sourceIsGitHubAppleSwiftNumericsIssues272(_ type: any BinaryInteger.Type) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            if  T.size >= Count(128) {
                let dividend  = T(3) << 96
                let divisor   = T(2) << 96
                let quotient  = T(1) << 00
                let remainder = T(1) << 96
                Ɣexpect(bidirectional: dividend, by: divisor, is: Fallible(Division(quotient: quotient, remainder: remainder)))
            }
            
            if  T.size > Count(128) || (!T.isSigned && T.size == Count(128)) {
                let dividend  = try #require(T("311758830729407788314878278112166161571"))
                let divisor   = try #require(T("259735543268722398904715765931073125012"))
                let quotient  = try #require(T("000000000000000000000000000000000000001"))
                let remainder = try #require(T("052023287460685389410162512181093036559"))
                Ɣexpect(bidirectional: dividend, by: divisor, is: Fallible(Division(quotient: quotient, remainder: remainder)))
            }
            
            if  T.size > Count(128) || (!T.isSigned && T.size == Count(128)) {
                let dividend  = try #require(T("213714108890282186096522258117935109183"))
                let divisor   = try #require(T("205716886996038887182342392781884393270"))
                let quotient  = try #require(T("000000000000000000000000000000000000001"))
                let remainder = try #require(T("007997221894243298914179865336050715913"))
                Ɣexpect(bidirectional: dividend, by: divisor, is: Fallible(Division(quotient: quotient, remainder: remainder)))
            }
            
            if  T.size > Count(256) || (!T.isSigned && T.size == Count(256)) {
                let dividend  = try #require(T("000000000000000000002369676578372158364766242369061213561181961479062237766620"))
                let divisor   = try #require(T("000000000000000000000000000000000000000102797312405202436815976773795958969482"))
                let quotient  = try #require(T("000000000000000000000000000000000000000000000000000000000023051931251193218442"))
                let remainder = try #require(T("000000000000000000000000000000000000000001953953567802622125048779101000179576"))
                Ɣexpect(bidirectional: dividend, by: divisor, is: Fallible(Division(quotient: quotient, remainder: remainder)))
            }
            
            if  T.size > Count(256) || (!T.isSigned && T.size == Count(256)) {
                let dividend  = try #require(T("096467201117289166187766181030232879447148862859323917044548749804018359008044"))
                let divisor   = try #require(T("000000000000000000004646260627574879223760172113656436161581617773435991717024"))
                let quotient  = try #require(T("000000000000000000000000000000000000000000000000000000000020762331011904583253"))
                let remainder = try #require(T("000000000000000000002933245778855346947389808606934720764144871598087733608972"))
                Ɣexpect(bidirectional: dividend, by: divisor, is: Fallible(Division(quotient: quotient, remainder: remainder)))
            }
        }
    }
}
