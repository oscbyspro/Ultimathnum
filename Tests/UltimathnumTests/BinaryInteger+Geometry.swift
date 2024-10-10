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
    
    @Test("BinaryInteger/isqrt() - [entropic]", arguments: binaryIntegers, fuzzers)
    func integerSquareRoot(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        if  let type = type as? any SystemsIntegerWhereIsUnsigned.Type {
            try whereIsSystemsIntegerWhereIsUnsigned(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< conditional(debug:   32,  release: 256) {
                let value = T.entropic(through: Shift.max(or: 255), as: .natural, using: &randomness)
                try Ɣexpect(value, isqrt: try #require(value.isqrt()))
            }
        }
        
        func whereIsSystemsIntegerWhereIsUnsigned<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< conditional(debug:   32,  release: 256) {
                let value = T.entropic(through: Shift.max(or: 255), as: .natural, using: &randomness)
                try Ɣexpect(value, isqrt: value.isqrt())
            }
        }
    }
    
    @Test("BinaryInteger/isqrt() - recovery mechanism [entropic]", arguments: systemsIntegersWhereIsUnsigned, fuzzers)
    func integerSquareRootRecoveryMechanism(type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< 32 {
                let random = T.entropic(using: &randomness)
                let expectation: T = random.isqrt()
                for error in Bool.all {
                    #expect(random.veto(error).isqrt() == expectation.veto(error))
                }
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
    
    /// - Note: A binary algorithm may make a correct initial guess here.
    @Test("BinaryInteger/isqrt() - natural power-of-2 squares", arguments: binaryIntegers, fuzzers)
    func integerSquareRootOfNaturalPowerOf2Squares(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for index in 0 ..< ((IX(size: T.self) ?? 256) / 2) {
                let expectation = T.lsb << index
                let power = expectation << index
                #expect(power.isqrt() == expectation)
            }
        }
    }
    
    @Test("BinaryInteger/isqrt() - negative is nil [uniform]", arguments: binaryIntegersWhereIsSigned, fuzzers)
    func integerSquareRootOfNegativeIsNil(type: any SignedInteger.Type, randomness: consuming FuzzerInt) throws {
        try whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SignedInteger {
            let low  = T(repeating: Bit.one).up(Shift.max(or: 255))
            let high = T(repeating: Bit.one)
            
            #expect(low .isqrt() == nil)
            #expect(high.isqrt() == nil)
            
            for _ in 0 ..< 32 {
                let random = T.random(in: low...high, using: &randomness)
                #expect(random.isqrt() == nil)
            }
        }
    }
    
    @Test("BinaryInteger/isqrt() - infinite is nil [uniform]", arguments: arbitraryIntegersWhereIsUnsigned, fuzzers)
    func integerSquareRootOfInfiniteIsNil(type: any ArbitraryIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerWhereIsUnsigned {
            let low  = T(repeating: Bit.one).up(Shift.max(or: 255))
            let high = T(repeating: Bit.one)
            
            #expect(low .isqrt() == nil)
            #expect(high.isqrt() == nil)
            
            for _ in 0 ..< 32 {
                let random = T.random(in: low...high, using: &randomness)
                #expect(random.isqrt() == nil)
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Geometry x Examples
//*============================================================================*

@Suite(.tags(.documentation), .serialized) struct BinaryIntegerTestsOnGeometryExamples {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("BinaryInteger/isqrt()", arguments: [
        
        ( 0 as U8, 0 as U8),
        ( 1 as U8, 1 as U8),
        ( 2 as U8, 1 as U8),
        ( 3 as U8, 1 as U8),
        ( 4 as U8, 2 as U8),
        ( 5 as U8, 2 as U8),
        ( 6 as U8, 2 as U8),
        ( 7 as U8, 2 as U8),
        ( 8 as U8, 2 as U8),
        ( 9 as U8, 3 as U8),
        (10 as U8, 3 as U8),
        (11 as U8, 3 as U8),
        (12 as U8, 3 as U8),
        (13 as U8, 3 as U8),
        (14 as U8, 3 as U8),
        (15 as U8, 3 as U8),
        (16 as U8, 4 as U8),
        
    ]   as [(U8, U8)]) func integerSquareRootOfSmallNaturals(value: U8, expectation: U8) throws {
        for type in binaryIntegers {
            try whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try Ɣexpect(T(value), isqrt: T(expectation))
        }
    }
}
