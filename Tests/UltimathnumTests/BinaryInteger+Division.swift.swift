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
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Division
//*============================================================================*

@Suite struct BinaryIntegerTestsOnDivision {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/division: signs",
        Tag.List.tags(.documentation, .generic),
        ParallelizationTrait.serialized,
        arguments: Array<(I8, I8, I8, I8)>([
        
        (dividend:  7 as I8, divisor:  3 as I8, quotient:  2 as I8, remainder:  1 as I8),
        (dividend:  7 as I8, divisor: -3 as I8, quotient: -2 as I8, remainder:  1 as I8),
        (dividend: -7 as I8, divisor:  3 as I8, quotient: -2 as I8, remainder: -1 as I8),
        (dividend: -7 as I8, divisor: -3 as I8, quotient:  2 as I8, remainder: -1 as I8),
        
    ])) func signs(
        dividend: I8, divisor: I8, quotient: I8, remainder: I8
    )   throws {
        
        for type in typesAsBinaryIntegerAsSigned {
            try whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: SignedInteger {
            let dividend  = try #require(T.exactly(dividend ).optional())
            let divisor   = try #require(T.exactly(divisor  ).optional())
            let quotient  = try #require(T.exactly(quotient ).optional())
            let remainder = try #require(T.exactly(remainder).optional())
            let division  = Fallible(Division(quotient: quotient, remainder: remainder))
            try Ɣrequire(validating: dividend, by: divisor, is: division)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/division: for each 8-bit integer pair",
        Tag.List.tags(.exhaustive, .generic),
        arguments: typesAsCoreIntegerAsByte
    )   func forEachEightBitIntegerPair(type: any SystemsInteger.Type) throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            try withOnlyOneCallToRequire { require in
                for dividend in T.all {
                    for divisor in T.all {
                        if  let divisor  = Nonzero(exactly:  divisor) {
                            let division = dividend.division(divisor) as Fallible
                            let product1 = division.value.quotient.times(divisor.value)
                            let product2 = product1.value.plus(division.value.remainder)
                            require(product2.value == dividend)
                            require(product1.error == division.error)
                            require(product2.error == false)
                        }   else {
                            require(dividend.division(divisor) == nil)
                        }
                    }
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/division: finite by random",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func finiteByRandom(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 64,  release: 1024) {
                let dividend = T.entropic(through: Shift.max(or: 255), as: Domain.finite, using: &randomness)
                let divisor  = T.entropic(through: Shift.max(or: 255), as: Domain.binary, using: &randomness)
                let division = dividend.division(divisor) as Optional<Fallible<Division<T,T>>>
                try Ɣrequire(validating: dividend, by: divisor, is: division)
            }
        }
    }
    
    @Test(
        "BinaryInteger/division: random by power-of-2-esque",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func randomByPowerOf2Esque(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let distance = Shift<T.Magnitude>.random(through: Shift.max(or: 255), using: &randomness)
                let dividend = T.entropic(through: Shift.max(or: 255), as: Domain.finite, using: &randomness)
                var divisor  = T.lsb.up(distance)
                
                if  T.isSigned, Bool.random(using: &randomness.stdlib) {
                    divisor.negate().discard()
                }
                
                let division = dividend.division(divisor) as Optional<Fallible<Division<T,T>>>
                try Ɣrequire(validating: dividend, by: divisor, is: division)
                
                if  let divisor = Nonzero(exactly: divisor) {
                    let sign      = Sign(raw: dividend.isNegative != divisor.value.isNegative)
                    let quotient  = T.exactly(sign: sign, magnitude: dividend.magnitude().down(distance))
                    let remainder = dividend.minus(quotient.value.times(divisor.value).value).value
                    try #require(division?.map(\.quotient) == quotient )
                    try #require(division?.value.remainder == remainder)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/division: ascending zeros by ascending zeros",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func ascendingZerosByAscendingZeros(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
    
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            func next(preshift: Domain) -> T {
                let next = T.entropic(through: Shift.max(or: 00000000127), as: preshift, using: &randomness)
                return next.drain(Bit.zero).up(Shift.random(through: Shift.max(or: 127), using: &randomness))
            }
            
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let dividend = next(preshift: Domain.finite)
                let divisor  = next(preshift: Domain.binary)
                let division = dividend.division(divisor) as Optional<Fallible<Division<T,T>>>
                try Ɣrequire(validating: dividend, by: divisor, is: division)
            }
        }
    }
    
    @Test(
        "BinaryInteger/division: contiguous ones by contiguous ones",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func contiguousOnesByContiguousOnes(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            func next() -> T {
                var next = T(repeating: Bit.one)
                next = next.up(Shift.random(through: Shift.max(or: 127), using: &randomness))
                next = next.toggled()
                return next.up(Shift.random(through: Shift.max(or: 127), using: &randomness))
            }
            
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let dividend = next()
                let divisor  = next()
                let division = dividend.division(divisor) as Optional<Fallible<Division<T,T>>>
                try Ɣrequire(validating: dividend, by: divisor, is: division)
            }
        }
    }
    
    @Test(
        "BinaryInteger/division: silly big by silly big",
        Tag.List.tags(.generic, .random),
        arguments: typesAsArbitraryInteger, fuzzers
    )   func sillyBigBySillyBig(
        type: any ArbitraryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryInteger {
            let size: IX = conditional(debug: 1024, release: 8192)
            for _ in 0 ..< conditional(debug: 0016, release: 0064) {
                let dividend = T.entropic(size: size, as: Domain.finite, using: &randomness)
                let divisor  = T.entropic(size: size, as: Domain.finite, using: &randomness)
                let division = dividend.division(divisor) as Optional<Fallible<Division<T,T>>>
                try Ɣrequire(validating: dividend, by: divisor, is: division)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    private func Ɣrequire<T>(
        validating dividend: T,
        by divisor:  T,
        is division: Optional<Fallible<Division<T, T>>>,
        at location: SourceLocation = #_sourceLocation
    )   throws where T: BinaryInteger {
        
        if  let dividend = Finite (exactly: dividend),
            let divisor  = Nonzero(exactly: divisor) {
            
            let division = try #require(division)
            try Ɣrequire(validating: dividend, by: divisor, is: division)
            
        }   else {
            try #require(division == nil)
        }
    }
    
    private func Ɣrequire<T>(
        validating dividend: Finite<T>,
        by divisor:  Nonzero<T>,
        is division: Fallible<Division<T, T>>,
        at location: SourceLocation = #_sourceLocation
    )   throws where T: BinaryInteger {
        //=--------------------------------------=
        let quotient  = division.map(\.quotient)
        let remainder = division.value.remainder
        let product1  = quotient.value.times(divisor.value)
        //=--------------------------------------=
        try #require(product1.error == division.error)
        
        invariant: do {
            let lhs = dividend.value
            var rhs = product1.value
            
            rhs = try #require(rhs.plus(remainder).optional())
            
            try #require(lhs == rhs, "a == b * q + r [0]", sourceLocation: location)
        }
        
        invariant: do {
            var lhs = dividend.value
            let rhs = product1.value

            lhs = try #require(lhs.minus(remainder).optional())
            
            try #require(lhs == rhs, "a - r == b * q [0]", sourceLocation: location)
        }
        
        if  division.error {
            try #require(T.isSigned)
            try #require(dividend.value == T.lsb.up(Shift.max))
            try #require(divisor .value == T(-1))
            try #require(quotient.value == T.lsb.up(Shift.max))
            try #require(quotient.error == (true))
            try #require(remainder      == T.zero)
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Division x Composition
//*============================================================================*

@Suite struct BinaryIntegerTestsOnDivisionComposition {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/division/composition: random by nonzero",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func randomByRandom(
        type: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            for _ in 0 ..< conditional(debug: 128, release: 1024) {
                if  let divisor = Nonzero(exactly: T.entropic(using: &randomness)) {
                    let low  = T.Magnitude.entropic(using: &randomness)
                    let high = T.Magnitude.entropic(using: &randomness)
                    let dividend = Doublet(low: low, high: T(raw: high))
                    let division = T.division(dividend, by: divisor)
                    try Ɣrequire(validating:  dividend, by: divisor, is: division)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/division/composition: random by power-of-2-esque",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func randomByPowerOf2Esque(
        type: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            for _ in 0 ..< conditional(debug: 128, release: 1024) {
                let distance = Shift<T.Magnitude>.random(using: &randomness)
                let low  = T.Magnitude.entropic(using: &randomness)
                let high = T.Magnitude.entropic(using: &randomness)
                let dividend = Doublet(low: low, high: T(raw: high))
                var divisor  = Nonzero(T.lsb.up(distance))
                
                if  T.isSigned, Bool.random(using: &randomness.stdlib) {
                    divisor = divisor.complement()
                }
                
                let division = T.division(dividend, by: divisor)
                try Ɣrequire(validating:  dividend, by: divisor, is: division)
            }
        }
    }
    
    @Test(
        "BinaryInteger/division/composition: ascending zeros by ascending zeros",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func ascendingZerosByAscendingZeros(
        type: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {

        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            for _ in 0 ..< conditional(debug: 128, release: 1024) {
                var divisor = T.entropic(using: &randomness)
                if !divisor.isZero {
                    var low     = T.Magnitude.entropic(using: &randomness)
                    var high    = T.Magnitude.entropic(using: &randomness)
                    
                    low     = low    .drain(Bit.zero).up(Shift.random(using: &randomness))
                    high    = high   .drain(Bit.zero).up(Shift.random(using: &randomness))
                    divisor = divisor.drain(Bit.zero).up(Shift.random(using: &randomness))
                    
                    let divisor  = Nonzero(divisor)
                    let dividend = Doublet(low: low, high: T(raw: high))
                    let division = T.division(dividend, by: divisor)
                    try Ɣrequire(validating:  dividend, by: divisor, is: division)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/division: one half by nonzero",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func oneHalfByRandom(
        type: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            for _ in 0 ..< conditional(debug: 128, release: 1024) {
                if  let divisor = Nonzero(exactly: T.entropic(using: &randomness)) {
                    let low  = T.entropic(using: &randomness)
                    let high = T.init(repeating: low.appendix)
                    let dividend = Doublet(low: T.Magnitude(raw: low), high: high)
                    let division = T.division(dividend, by: divisor)
                    try #require(division ==  low.division( divisor))
                    try Ɣrequire(validating:  dividend, by: divisor, is: division)
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    private func Ɣrequire<T>(
        validating dividend: Doublet<T>,
        by divisor:  Nonzero<T>,
        is division: Fallible<Division<T, T>>,
        at location: SourceLocation = #_sourceLocation
    )   throws where T: SystemsInteger {
        //=--------------------------------------=
        let quotient  = division.map(\.quotient)
        let remainder = division.value.remainder
        let product   = quotient.value.multiplication(divisor.value)
        //=--------------------------------------=
        versus: do {
            let body = [dividend.low, T.Magnitude(raw: dividend.high)]
            let appendix: Bit = dividend.high.appendix
            let lenient = try #require(IXL(body, repeating: appendix).division(IXL(divisor.value)))
            try #require(quotient  == T.exactly(lenient.quotient), "lossy", sourceLocation: location)
            try #require(remainder == lenient.remainder, "exact", sourceLocation: location)
        }
        
        invariant: do {
            let lhs = dividend
            var rhs = product
            var carry = false
            
            rhs.low  = rhs.low .plus(T.Magnitude.init(raw: remainder), plus: carry).sink(&carry)
            rhs.high = rhs.high.plus(T(repeating: remainder.appendix), plus: carry).sink(&carry)
            
            try #require(lhs.low  == rhs.low,  "a == b * q + r [0]", sourceLocation: location)
            guard !division.error else { break invariant }
            try #require(lhs.high == rhs.high, "a == b * q + r [1]", sourceLocation: location)
        }
        
        invariant: do {
            var lhs = dividend
            let rhs = product
            var carry = false
            
            lhs.low  = lhs.low .minus(T.Magnitude.init(raw: remainder), plus: carry).sink(&carry)
            lhs.high = lhs.high.minus(T(repeating: remainder.appendix), plus: carry).sink(&carry)
            
            try #require(lhs.low  == rhs.low,  "a - r == b * q [0]", sourceLocation: location)
            guard !division.error else { break invariant }
            try #require(lhs.high == rhs.high, "a - r == b * q [1]", sourceLocation: location)
        }
        
        if  division.error, !T.isSigned {
            try #require(dividend.high >= divisor.value, "unsigned", sourceLocation: location)
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Division x Edge Cases
//*============================================================================*

@Suite struct BinaryIntegerTestsOnDivisionEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/division/edge-cases: random by zero is nil",
        Tag.List.tags(.documentation, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func randomByZeroIsNil(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 32, release: 256) {
                let index = Shift<T.Magnitude>.max(or: 255)
                let dividend = T.entropic(through: index, using: &randomness)
                let divisor  = T.zero
                try #require(dividend.division(divisor) == nil)
            }
        }
    }
    
    @Test(
        "BinaryInteger/division/edge-cases: T.min < 0 by -1 is error",
        Tag.List.tags(.documentation, .exhaustive, .generic),
        arguments: typesAsSystemsIntegerAsSigned
    )   func negativeMinByNegativeOneIsError(
        type: any SystemsIntegerAsSigned.Type
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerAsSigned {
            let dividend = T.min
            let divisor  = T(-1)
            let division = Division(quotient: T.min, remainder: T.zero)
            try #require(dividend.division(divisor) == division.veto())
        }
    }
    
    @Test(
        "BinaryInteger/division/edge-cases: finite by infinite is trivial",
        Tag.List.tags(.documentation, .generic, .random),
        arguments: typesAsArbitraryIntegerAsUnsigned, fuzzers
    )   func finiteByInfiniteIsTrivial(
        type: any ArbitraryIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 32, release: 256) {
                let index = Shift<T.Magnitude>.max(or: 255)
                let dividend = T.entropic(through: index, as: Domain.natural, using: &randomness)
                let divisor  = T.entropic(through: index, as: Domain.natural, using: &randomness).toggled()
                let division = Division(quotient: T.zero, remainder: dividend)
                try #require(!dividend.isInfinite)
                try #require((divisor).isInfinite)
                try #require(dividend.division(divisor) == Fallible(division))
            }
        }
    }
    
    @Test(
        "BinaryInteger/division/edge-cases: infinite by random is nil",
        Tag.List.tags(.documentation, .generic, .random),
        arguments: typesAsArbitraryIntegerAsUnsigned, fuzzers
    )   func infiniteByRandomIsNil(
        type: any ArbitraryIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 32, release: 256) {
                let index = Shift<T.Magnitude>.max(or: 255)
                let dividend = T.entropic(through: index, as: Domain.natural, using: &randomness).toggled()
                let divisor  = T.entropic(through: index, as: Domain.binary,  using: &randomness)
                try #require(dividend.isInfinite)
                try #require(dividend.division(divisor) == nil)
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Division x Conveniences
//*============================================================================*

@Suite struct BinaryIntegerTestsOnDivisionConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/division/conveniences: as BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func asBinaryInteger(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
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
        "BinaryInteger/division/conveniences: as Finite<Value>",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func asFinite(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
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
    
    @Test(
        "BinaryInteger/division/conveniences: as FiniteInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsFiniteInteger, fuzzers
    )   func asFiniteInteger(
        type: any FiniteInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
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
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Lenient
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/division/conveniences: as LenientInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsArbitraryIntegerAsSigned, fuzzers
    )   func asLenientInteger(
        type: any ArbitraryIntegerAsSigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
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
        "BinaryInteger/division/conveniences: as Natural<Value>",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func asNatural(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
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
    
    @Test(
        "BinaryInteger/division/conveniences: as NaturalInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsSystemsIntegerAsUnsigned, fuzzers
    )   func asNaturalInteger(
        type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
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
}

//*============================================================================*
// MARK: * Binary Integer x Division x Open Source Issues
//*============================================================================*

@Suite(.serialized) struct BinaryIntegerTestsOnDivisionOpenSourceIssues {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/division/open-source: issues",
        Tag.List.tags(.generic, .opensource),
        ParallelizationTrait.serialized,
        arguments: Array<(IXL, IXL, IXL, IXL, String)>([
        (
            dividend:  IXL(3) << 96,
            divisor:   IXL(2) << 96,
            quotient:  IXL(1) << 00,
            remainder: IXL(1) << 96,
            source: "https://github.com/apple/swift-numerics/issues/272"
        ),(
            dividend:  IXL("311758830729407788314878278112166161571")!,
            divisor:   IXL("259735543268722398904715765931073125012")!,
            quotient:  IXL("000000000000000000000000000000000000001")!,
            remainder: IXL("052023287460685389410162512181093036559")!,
            source: "https://github.com/apple/swift-numerics/issues/272"
        ),(
            dividend:  IXL("213714108890282186096522258117935109183")!,
            divisor:   IXL("205716886996038887182342392781884393270")!,
            quotient:  IXL("000000000000000000000000000000000000001")!,
            remainder: IXL("007997221894243298914179865336050715913")!,
            source: "https://github.com/apple/swift-numerics/issues/272"
        ),(
            dividend:  IXL("000000000000000000002369676578372158364766242369061213561181961479062237766620")!,
            divisor:   IXL("000000000000000000000000000000000000000102797312405202436815976773795958969482")!,
            quotient:  IXL("000000000000000000000000000000000000000000000000000000000023051931251193218442")!,
            remainder: IXL("000000000000000000000000000000000000000001953953567802622125048779101000179576")!,
            source: "https://github.com/apple/swift-numerics/issues/272"
        ),(
            dividend:  IXL("096467201117289166187766181030232879447148862859323917044548749804018359008044")!,
            divisor:   IXL("000000000000000000004646260627574879223760172113656436161581617773435991717024")!,
            quotient:  IXL("000000000000000000000000000000000000000000000000000000000020762331011904583253")!,
            remainder: IXL("000000000000000000002933245778855346947389808606934720764144871598087733608972")!,
            source: "https://github.com/apple/swift-numerics/issues/272"
        ),(
            dividend:  IXL("000000000000000000003360506852691063560493141264855294697309369118818719524903")!,
            divisor:   IXL("000000000000000000000000000000000000000038792928317726192474768301090870907748")!,
            quotient:  IXL("000000000000000000000000000000000000000000000000000000000086626789943967710436")!,
            remainder: IXL("000000000000000000000000000000000000000016136758413064865246015978698186666775")!,
            source: "https://github.com/oscbyspro/Numberick/issues/101"
        ),
    ])) func issues(
        dividend: IXL, divisor: IXL, quotient: IXL, remainder: IXL, source: String
    )   throws {
       
        for type in typesAsBinaryInteger {
            try whereIs(type)
        }
        
        try whereIs(I128.self)
        try whereIs(U128.self)
        try whereIs(I256.self)
        try whereIs(U256.self)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger  {
            guard let dividend  = T.exactly(dividend ).optional() else { return }
            guard let divisor   = T.exactly(divisor  ).optional() else { return }
            guard let quotient  = T.exactly(quotient ).optional() else { return }
            guard let remainder = T.exactly(remainder).optional() else { return }
            let expectation = Fallible(Division(quotient: quotient, remainder: remainder))
            try #require(dividend.division(divisor) == expectation)
        }
    }
}
