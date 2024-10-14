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

@Suite("BinaryInteger/division(_:)") struct BinaryIntegerTestsOnDivision {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("signs", .serialized, .tags(.documentation), arguments: [
        
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
    
    @Test("1-by-1 division for each 8-bit", .tags(.exhaustive), arguments: i8u8)
    func division11ForEachEightBit(type: any SystemsInteger.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            var success = IX.zero
                        
            for dividend in T.all {
                for divisor in T.all {
                    guard let divisor = Nonzero(exactly: divisor) else { continue }
                    let division = dividend.division(divisor)
                    let reconstitution = division.value.dividend(divisor)
                    success &+= IX(Bit(reconstitution.value == dividend))
                    success &+= IX(Bit(reconstitution.error == division.error))
                }
            }
            
            #expect(success == 2 &* IX(T.all.count) &* IX(T.all.count - 1))
        }
    }
    
    @Test("1-by-1 division of random by random", arguments: typesAsBinaryInteger, fuzzers)
    func division11OfRandomByRandom(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 64,  release: 1024) {
                let dividend = T.entropic(through: Shift.max(or: 255), as: Domain.finite, using: &randomness)
                let divisor  = T.entropic(through: Shift.max(or: 255), as: Domain.binary, using: &randomness)
                Ɣexpect(bidirectional: dividend, by: divisor)
            }
        }
    }
    
    @Test("1-by-1 division of random by power-of-2-esque [entropic]", arguments: typesAsBinaryInteger, fuzzers)
    func division11OfRandomByPowerOf2Esque(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
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
                    let remainder = dividend.minus(quotient.value.times(divisor.value)).value
                    let division  = Fallible(Division(quotient: quotient.value, remainder: remainder), error: quotient.error)
                    Ɣexpect(bidirectional: dividend, by: divisor, is: division)
                }   else {
                    Ɣexpect(bidirectional: dividend, by: divisor, is: nil)
                }
            }
        }
    }
    
    @Test("1-by-1 division ascending zeros by ascending zeros [entropic]", arguments: typesAsBinaryInteger, fuzzers)
    func division11OfAscendingZerosByAscendingZeros(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
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
    
    @Test("1-by-1 division of contiguous ones by contiguous ones", arguments: typesAsBinaryInteger, fuzzers)
    func division11OfContiguousOnesByContiguousOnes(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
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
    
    @Test("1-by-1 division of silly big by silly big [entropic]", arguments: typesAsArbitraryInteger, fuzzers)
    func division11OfSillyBigBySillyBig(type: any ArbitraryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryInteger {
            let size: IX = conditional(debug: 1024, release: 8192)
            for _ in 0 ..< conditional(debug: 0016, release: 0064) {
                let dividend = T.entropic(size: size, as: Domain.finite, using: &randomness)
                let divisor  = T.entropic(size: size, as: Domain.finite, using: &randomness)
                //  one round-trip for performance
                if  let divisor  = Nonzero(exactly: divisor) {
                    let division = try #require(dividend.division(divisor).optional())
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
    
    @Test("2-by-1 division of random by random [entropic]", arguments: typesAsSystemsInteger, fuzzers)
    func division21OfRandomByRandom(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) {
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
    
    @Test("2-by-1 division of random by power-of-2-esque [entropic]", arguments: typesAsSystemsInteger, fuzzers)
    func division21OfRandomByPowerOf2Esque(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) {
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
    
    @Test("2-by-1 division of ascending zeros by ascending zeros [entropic]", arguments: typesAsSystemsInteger, fuzzers)
    func division21OfAscendingZerosByAscendingZeros(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) {
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
    
    @Test("2-by-1 division of one half by random [entropic]", arguments: typesAsSystemsInteger, fuzzers)
    func division21OfOneHalfByRandom(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            for _ in 0 ..< conditional(debug: 128, release: 1024) {
                let low  = T.entropic(using: &randomness)
                let high = T.init(repeating: low.appendix)
                let dividend = Doublet(low: T.Magnitude(raw: low), high: high)
                let divisor  = T.entropic(using: &randomness)
                let division = Nonzero(exactly:  divisor).map {
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

@Suite("BinaryInteger/division(_:) - edge cases", .tags(.documentation))
struct BinaryIntegerTestsOnDivisionEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 1 by 1
    //=------------------------------------------------------------------------=
    
    @Test("1-by-1 division of random by zero is nil [entropic]", arguments: typesAsBinaryInteger, fuzzers)
    func division11OfRandomByZeroIsNil(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 32, release: 256) {
                let dividend = T.entropic(through: Shift.max(or: 255), using: &randomness)
                Ɣexpect(bidirectional: dividend, by: T.zero, is: nil)
            }
        }
    }
    
    @Test("1-by-1 division of T.min by -1 as signed systems integers is error", arguments: typesAsSystemsIntegerAsSigned)
    func division11OfMinByNegativeOneAsSignedSystemsIntegerIsError(type: any SystemsIntegerAsSigned.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerAsSigned {
            let division = Fallible(Division(quotient: T.min, remainder: T.zero), error: true)
            Ɣexpect(bidirectional: T.min, by: -1, is: division)
        }
    }
    
    @Test("1-by-1 division of finite by infinite is trivial [uniform]", arguments: typesAsArbitraryIntegerAsUnsigned, fuzzers)
    func division11OfFiniteByInfiniteIsTrivial(type: any ArbitraryIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) throws {
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
    
    @Test("1-by-1 division of infinite by finite is error like signed [uniform]", arguments: typesAsArbitraryIntegerAsUnsigned, fuzzers)
    func division11OfInfiniteByFiniteIsErrorLikeSigned(type: any ArbitraryIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
                
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsUnsigned {
            let low  = T(repeating: Bit.one).up(Shift.max(or: 255))
            let high = T(repeating: Bit.one)
            let top  = low.toggled()
            
            for _ in 0 ..< conditional(debug: 32, release: 256) {
                let magnitudes: (dividend: T.Magnitude, divisor: T.Magnitude)
                let signitudes: (dividend: T.Signitude, divisor: T.Signitude)
                
                magnitudes.dividend = T.random(in: low...high, using: &randomness)
                magnitudes.divisor  = T.random(in: T(1)...top, using: &randomness)
                
                signitudes.dividend = T.Signitude(raw: magnitudes.dividend)
                signitudes.divisor  = T.Signitude(raw: magnitudes.divisor )
                                
                let division = signitudes.dividend.division(try #require(Nonzero(exactly: signitudes.divisor))).veto()
                Ɣexpect(bidirectional: magnitudes.dividend, by: magnitudes.divisor, is: Fallible(raw: division))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 2 by 1
    //=------------------------------------------------------------------------=
    
    @Test("2-by-1 division of random by zero is nil [entropic]", arguments: typesAsSystemsInteger, fuzzers)
    func division21OfRandomByZeroIsNil(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) {
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
// MARK: * Binary Integer x Division x Recovery Mechanisms
//*============================================================================*

@Suite("BinaryInteger/division(_:) - recovery mechanisms", .tags(.recoverable))
struct BinaryIntegerTestsOnDivisionRecoveryMechanisms {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("division error propagation as binary integer [entropic]", arguments: typesAsBinaryInteger, fuzzers)
    func divisionErrorPropagationAsBinaryInteger(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for _ in 0 ..< 8 {
                let dividend = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let divisor  = T.entropic(through: Shift.max(or: 255), using: &randomness)
                guard let divisor = Nonzero(exactly: divisor) else { continue }
                
                let division  = dividend.division (divisor) as Fallible<Division<T, T>>
                let quotient  = dividend.quotient (divisor) as Fallible<T>
                let remainder = dividend.remainder(divisor) as T
                
                #expect(quotient  == division.map(\.quotient))
                #expect(remainder == division.value.remainder)
                
                for error in Bool.all {
                    #expect(dividend.veto(error).division (divisor) == division .veto(error))
                    #expect(dividend.veto(error).quotient (divisor) == quotient .veto(error))
                    #expect(dividend.veto(error).remainder(divisor) == remainder.veto(error))
                }
            }
        }
    }
    
    @Test("division error propagation as natural integer [entropic]", arguments: typesAsSystemsIntegerAsUnsigned, fuzzers)
    func divisionErrorPropagationAsNaturalInteger(type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< 8 {
                let dividend = T.entropic(using: &randomness)
                let divisor  = T.entropic(using: &randomness)
                guard let divisor = Nonzero(exactly: divisor) else { continue }
                //  note that 1-by-1 division does not fail
                let division = dividend.division(divisor) as Fallible<Division<T, T>>
                let quotient = dividend.quotient(divisor) as Fallible<T>
                
                #expect(division.error == false)
                #expect(division.value == dividend.division(divisor))
                #expect(quotient.error == false)
                #expect(quotient.value == dividend.quotient(divisor))
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Division x Open Source Issues
//*============================================================================*

@Suite("BinaryInteger/division - open source issues", .tags(.opensource))
struct BinaryIntegerTestsOnDivisionOpenSourceIssues {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// https://github.com/oscbyspro/Numberick/issues/101
    ///
    /// - Note: Checks whether the 3212-path knows when the quotient fits.
    ///
    @Test(arguments: typesAsBinaryInteger) func sourceIsGitHubOscbysproNumberickIssues101(_ type: any BinaryInteger.Type) throws {
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
    @Test(arguments: typesAsBinaryInteger) func sourceIsGitHubAppleSwiftNumericsIssues272(_ type: any BinaryInteger.Type) throws {
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
