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
// MARK: * Binary Integer x Logarithm
//*============================================================================*

@Suite struct BinaryIntegerTestsOnLogarithm {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
        
    @Test("BinaryInteger/ilog2() - [entropic]", arguments: binaryIntegers, fuzzers)
    func binaryIntegerLogarithm(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 32, release: 256) {
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                if !random.isPositive {
                    #expect(random.ilog2() == nil)
                    
                }   else {
                    let nonzero = try #require(Nonzero(exactly:  random))
                    let expectation = try #require(nonzero.value.ilog2())
                    let magnitude: Nonzero<T.Magnitude> = nonzero.magnitude()
                    #expect(expectation == magnitude.ilog2())
                    #expect(expectation == magnitude.value.ilog2())
                    try Ɣexpect(nonzero.value, ilog2: expectation)
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Logarithm x Edge Cases
//*============================================================================*

@Suite(.tags(.documentation)) struct BinaryIntegerTestsOnLogarithmEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("BinaryInteger/ilog2() - small positive", .serialized, arguments: [
        
        Some( 1 as U8, yields: Count(0)),
        Some( 2 as U8, yields: Count(1)),
        Some( 3 as U8, yields: Count(1)),
        Some( 4 as U8, yields: Count(2)),
        Some( 5 as U8, yields: Count(2)),
        Some( 6 as U8, yields: Count(2)),
        Some( 7 as U8, yields: Count(2)),
        Some( 8 as U8, yields: Count(3)),
        Some( 9 as U8, yields: Count(3)),
        Some(10 as U8, yields: Count(3)),
        Some(11 as U8, yields: Count(3)),
        Some(12 as U8, yields: Count(3)),
        Some(13 as U8, yields: Count(3)),
        Some(14 as U8, yields: Count(3)),
        Some(15 as U8, yields: Count(3)),
        Some(16 as U8, yields: Count(4)),
        
    ] as [Some<U8, Count>])
    func binaryIntegerLogarithmOfSmallPositive(expectation: Some<U8, Count>) throws {
        for type in binaryIntegers {
            try whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try Ɣexpect(T(expectation.input), ilog2: expectation.output)
        }
    }
    
    @Test("BinaryInteger/ilog2() - zero is nil [uniform]", arguments: binaryIntegersWhereIsSigned)
    func binaryIntegerLogarithmOfZeroIsNil(type: any BinaryInteger.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            #expect(T.zero.ilog2() == nil)
        }
    }
    
    @Test("BinaryInteger/ilog2() - negative is nil [uniform]", arguments: binaryIntegersWhereIsSigned, fuzzers)
    func binaryIntegerLogarithmOfNegativeIsNil(type: any SignedInteger.Type, randomness: consuming FuzzerInt) throws {
        try whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SignedInteger {
            let low  = T(repeating: Bit.one).up(Shift.max(or: 255))
            let high = T(repeating: Bit.one)
            
            #expect(low .ilog2() == nil)
            #expect(high.ilog2() == nil)
            
            for _ in 0 ..< 32 {
                let random = T.random(in: low...high, using: &randomness)
                #expect(random.isNegative)
                #expect(random.ilog2() == nil)
            }
        }
    }
    
    @Test("BinaryInteger/ilog2() - infinite is one less than size [uniform]", arguments: arbitraryIntegersWhereIsUnsigned, fuzzers)
    func binaryIntegerLogarithmOfInfiniteIsOneLessThanSize(type: any ArbitraryIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerWhereIsUnsigned {
            let low  = T(repeating: Bit.one).up(Shift.max(or: 255))
            let high = T(repeating: Bit.one)
            let expectation = Count(raw: -2)
            
            #expect(expectation  == Count(raw: IX(raw: T.size) - 1))
            #expect(low .ilog2() == expectation)
            #expect(high.ilog2() == expectation)
            
            for _ in 0 ..< 32 {
                let random = T.random(in: low...high, using: &randomness)
                #expect(random.isInfinite)
                #expect(random.ilog2() == expectation)
            }
        }
    }
}
