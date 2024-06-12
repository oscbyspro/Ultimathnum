//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Core Int x Factorization
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testGreatestCommonDivisorOfSmallPowersOf2() {
        Test().euclidean( 2 as IX, 16 as IX,  2 as UX)
        Test().euclidean( 4 as IX, 16 as IX,  4 as UX)
        Test().euclidean( 8 as IX, 16 as IX,  8 as UX)
        Test().euclidean(16 as IX, 16 as IX, 16 as UX)
    }
    
    func testGreatestCommonDivisorOfSmallPrimeProducts() {
        // even x even
        Test().euclidean(2                  as IX, 2 * 5 * 11 as IX, 2          as UX)
        Test().euclidean(2 * 3              as IX, 2 * 5 * 11 as IX, 2          as UX)
        Test().euclidean(2 * 3 * 5          as IX, 2 * 5 * 11 as IX, 2 * 5      as UX)
        Test().euclidean(2 * 3 * 5 * 7      as IX, 2 * 5 * 11 as IX, 2 * 5      as UX)
        Test().euclidean(2 * 3 * 5 * 7 * 11 as IX, 2 * 5 * 11 as IX, 2 * 5 * 11 as UX)
        Test().euclidean(    3 * 5 * 7 * 11 as IX, 2 * 5 * 11 as IX,     5 * 11 as UX)
        Test().euclidean(        5 * 7 * 11 as IX, 2 * 5 * 11 as IX,     5 * 11 as UX)
        Test().euclidean(            7 * 11 as IX, 2 * 5 * 11 as IX,         11 as UX)
        Test().euclidean(                11 as IX, 2 * 5 * 11 as IX,         11 as UX)
        // even x odd
        Test().euclidean(2                  as IX, 3 * 5 * 07 as IX, 1          as UX)
        Test().euclidean(2 * 3              as IX, 3 * 5 * 07 as IX, 3          as UX)
        Test().euclidean(2 * 3 * 5          as IX, 3 * 5 * 07 as IX, 3 * 5      as UX)
        Test().euclidean(2 * 3 * 5 * 7      as IX, 3 * 5 * 07 as IX, 3 * 5 * 07 as UX)
        Test().euclidean(2 * 3 * 5 * 7 * 11 as IX, 3 * 5 * 07 as IX, 3 * 5 * 07 as UX)
        Test().euclidean(    3 * 5 * 7 * 11 as IX, 3 * 5 * 07 as IX, 3 * 5 * 07 as UX)
        Test().euclidean(        5 * 7 * 11 as IX, 3 * 5 * 07 as IX,     5 * 07 as UX)
        Test().euclidean(            7 * 11 as IX, 3 * 5 * 07 as IX,         07 as UX)
        Test().euclidean(                11 as IX, 3 * 5 * 07 as IX,         01 as UX)
        // odd  x even
        Test().euclidean(1                  as IX, 2 * 5 * 11 as IX, 1          as UX)
        Test().euclidean(1 * 3              as IX, 2 * 5 * 11 as IX, 1          as UX)
        Test().euclidean(1 * 3 * 5          as IX, 2 * 5 * 11 as IX, 1 * 5      as UX)
        Test().euclidean(1 * 3 * 5 * 7      as IX, 2 * 5 * 11 as IX, 1 * 5      as UX)
        Test().euclidean(1 * 3 * 5 * 7 * 11 as IX, 2 * 5 * 11 as IX, 1 * 5 * 11 as UX)
        Test().euclidean(    3 * 5 * 7 * 11 as IX, 2 * 5 * 11 as IX,     5 * 11 as UX)
        Test().euclidean(        5 * 7 * 11 as IX, 2 * 5 * 11 as IX,     5 * 11 as UX)
        Test().euclidean(            7 * 11 as IX, 2 * 5 * 11 as IX,         11 as UX)
        Test().euclidean(                11 as IX, 2 * 5 * 11 as IX,         11 as UX)
        // odd  x odd
        Test().euclidean(1                  as IX, 3 * 5 * 07 as IX, 1          as UX)
        Test().euclidean(1 * 3              as IX, 3 * 5 * 07 as IX, 3          as UX)
        Test().euclidean(1 * 3 * 5          as IX, 3 * 5 * 07 as IX, 3 * 5      as UX)
        Test().euclidean(1 * 3 * 5 * 7      as IX, 3 * 5 * 07 as IX, 3 * 5 * 07 as UX)
        Test().euclidean(1 * 3 * 5 * 7 * 11 as IX, 3 * 5 * 07 as IX, 3 * 5 * 07 as UX)
        Test().euclidean(    3 * 5 * 7 * 11 as IX, 3 * 5 * 07 as IX, 3 * 5 * 07 as UX)
        Test().euclidean(        5 * 7 * 11 as IX, 3 * 5 * 07 as IX,     5 * 07 as UX)
        Test().euclidean(            7 * 11 as IX, 3 * 5 * 07 as IX,         07 as UX)
        Test().euclidean(                11 as IX, 3 * 5 * 07 as IX,         01 as UX)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testEveryIntegerDividesZero() {
        for x: IX in -10 ... 9 {
            Test().euclidean(0 as IX, x, x.magnitude() as UX)
        }
        
        Test().euclidean(0 as IX, IX.max, IX.max.magnitude() as UX)
        Test().euclidean(0 as IX, IX.min, IX.min.magnitude() as UX)
    }
    
    func testEachPairInFibonacciSequenceIsCoprime() {
        var fibonacci = (low: 0 as IX, high: 1 as IX)
        next: while fibonacci.high >= fibonacci.low {
            Test().euclidean(fibonacci.low,   fibonacci.high, 00000001 as UX)
            ((fibonacci)) = (fibonacci.low &+ fibonacci.high, fibonacci.high)
        }
    }
    
    func testGreatestCommonDivisorForEachBytePairAsSigned() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & SignedInteger {
            //=----------------------------------=
            var success = U32.zero
            let values8 = T(I8.min) ... T(I8.max)
            //=----------------------------------=
            for lhs in values8 {
                for rhs in values8 {
                    let euclidean = lhs.euclidean(rhs)

                    if  euclidean == T.euclidean(Finite(lhs), Finite(rhs)) {
                        success += 1
                    }
                    
                    if  euclidean == lhs.magnitude().euclidean(rhs.magnitude()) {
                        success += 1 // proxy validation through unsigned types
                    }
                }
            }
            
            Test().same(success, 2 * 65536)
        }
        
        whereIs(I8 .self)
        #if !DEBUG
        whereIs(I16.self)
        whereIs(I32.self)
        whereIs(I64.self)
        whereIs(IX .self)
        #endif
    }
    
    func testGreatestCommonDivisorForEachBytePairAsUnsigned() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            //=----------------------------------=
            var coprime = U32.zero
            var success = U32.zero
            let values8 = T(U8.min) ... T(U8.max)
            //=----------------------------------=
            for lhs in values8 {
                for rhs in values8 {
                    let bezout = lhs.bezout(rhs)
                    let euclidean = lhs.euclidean(rhs)
                    
                    if  euclidean == 1 {
                        coprime += 1
                    }
                    
                    always: do {
                        let a = I16(lhs) * I16(bezout.lhsCoefficient)
                        let b = I16(rhs) * I16(bezout.rhsCoefficient)
                        success += U32(Bit((a + b) == bezout.divisor))
                    }
                    
                    if  euclidean == bezout.divisor {
                        success += 1
                    }
                    
                    if  lhs.isZero, rhs.isZero {
                        success += U32(Bit(euclidean == 0))
                    }   else {
                        success += U32(Bit(euclidean >= 1))
                    }
                    
                    if  bezout  == T.bezout(Finite(lhs), Finite(rhs)) {
                        success += 1
                    }
                    
                    if  euclidean == T.euclidean(Finite(lhs), Finite(rhs)) {
                        success += 1
                    }
                }
            }
            
            Test().same(coprime, 1 * 39641)
            Test().same(success, 5 * 65536)
        }
        
        whereIs(U8 .self)
        #if !DEBUG
        whereIs(U16.self)
        whereIs(U32.self)
        whereIs(U64.self)
        whereIs(UX .self)
        #endif
    }
}
