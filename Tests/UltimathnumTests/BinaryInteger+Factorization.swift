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
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Factorization
//*============================================================================*

final class BinaryIntegerTestsOnFactorization: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testEachPairInFibonacciSequenceIsCoprime() {
        var fibonacci = (low: 0 as IX, high: 1 as IX)
        next: while fibonacci.high >= fibonacci.low {
            Test().euclidean(fibonacci.low,   fibonacci.high, 00000001 as UX)
            ((fibonacci)) = (fibonacci.low &+ fibonacci.high, fibonacci.high)
        }
    }
    
    func testEveryIntegerDividesZero() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            let patterns: Range<I8> = -5..<5
            
            for x: T in patterns.lazy.map(T.init(load:)) {
                Test().euclidean(T.zero, x, x.isInfinite ? nil : x.magnitude())
            }
            
            Test().euclidean(T.zero, Esque<T>.min, Esque<T>.min.magnitude())
            Test().euclidean(T.zero, Esque<T>.max, T.isFinite ? Esque<T>.max.magnitude() : nil)
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testGreatestCommonDivisorOfSmallPowersOf2() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            Test().euclidean( 2 as T, 16 as T,  2 as T.Magnitude)
            Test().euclidean( 4 as T, 16 as T,  4 as T.Magnitude)
            Test().euclidean( 8 as T, 16 as T,  8 as T.Magnitude)
            Test().euclidean(16 as T, 16 as T, 16 as T.Magnitude)
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testGreatestCommonDivisorOfSmallPrimeProducts() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            precondition(T.size >= Count(16))
            // even x even
            Test().euclidean(2                  as T, 2 * 5 * 11 as T, 2          as T.Magnitude)
            Test().euclidean(2 * 3              as T, 2 * 5 * 11 as T, 2          as T.Magnitude)
            Test().euclidean(2 * 3 * 5          as T, 2 * 5 * 11 as T, 2 * 5      as T.Magnitude)
            Test().euclidean(2 * 3 * 5 * 7      as T, 2 * 5 * 11 as T, 2 * 5      as T.Magnitude)
            Test().euclidean(2 * 3 * 5 * 7 * 11 as T, 2 * 5 * 11 as T, 2 * 5 * 11 as T.Magnitude)
            Test().euclidean(    3 * 5 * 7 * 11 as T, 2 * 5 * 11 as T,     5 * 11 as T.Magnitude)
            Test().euclidean(        5 * 7 * 11 as T, 2 * 5 * 11 as T,     5 * 11 as T.Magnitude)
            Test().euclidean(            7 * 11 as T, 2 * 5 * 11 as T,         11 as T.Magnitude)
            Test().euclidean(                11 as T, 2 * 5 * 11 as T,         11 as T.Magnitude)
            // even x odd
            Test().euclidean(2                  as T, 3 * 5 * 07 as T, 1          as T.Magnitude)
            Test().euclidean(2 * 3              as T, 3 * 5 * 07 as T, 3          as T.Magnitude)
            Test().euclidean(2 * 3 * 5          as T, 3 * 5 * 07 as T, 3 * 5      as T.Magnitude)
            Test().euclidean(2 * 3 * 5 * 7      as T, 3 * 5 * 07 as T, 3 * 5 * 07 as T.Magnitude)
            Test().euclidean(2 * 3 * 5 * 7 * 11 as T, 3 * 5 * 07 as T, 3 * 5 * 07 as T.Magnitude)
            Test().euclidean(    3 * 5 * 7 * 11 as T, 3 * 5 * 07 as T, 3 * 5 * 07 as T.Magnitude)
            Test().euclidean(        5 * 7 * 11 as T, 3 * 5 * 07 as T,     5 * 07 as T.Magnitude)
            Test().euclidean(            7 * 11 as T, 3 * 5 * 07 as T,         07 as T.Magnitude)
            Test().euclidean(                11 as T, 3 * 5 * 07 as T,         01 as T.Magnitude)
            // odd  x even
            Test().euclidean(1                  as T, 2 * 5 * 11 as T, 1          as T.Magnitude)
            Test().euclidean(1 * 3              as T, 2 * 5 * 11 as T, 1          as T.Magnitude)
            Test().euclidean(1 * 3 * 5          as T, 2 * 5 * 11 as T, 1 * 5      as T.Magnitude)
            Test().euclidean(1 * 3 * 5 * 7      as T, 2 * 5 * 11 as T, 1 * 5      as T.Magnitude)
            Test().euclidean(1 * 3 * 5 * 7 * 11 as T, 2 * 5 * 11 as T, 1 * 5 * 11 as T.Magnitude)
            Test().euclidean(    3 * 5 * 7 * 11 as T, 2 * 5 * 11 as T,     5 * 11 as T.Magnitude)
            Test().euclidean(        5 * 7 * 11 as T, 2 * 5 * 11 as T,     5 * 11 as T.Magnitude)
            Test().euclidean(            7 * 11 as T, 2 * 5 * 11 as T,         11 as T.Magnitude)
            Test().euclidean(                11 as T, 2 * 5 * 11 as T,         11 as T.Magnitude)
            // odd  x odd
            Test().euclidean(1                  as T, 3 * 5 * 07 as T, 1          as T.Magnitude)
            Test().euclidean(1 * 3              as T, 3 * 5 * 07 as T, 3          as T.Magnitude)
            Test().euclidean(1 * 3 * 5          as T, 3 * 5 * 07 as T, 3 * 5      as T.Magnitude)
            Test().euclidean(1 * 3 * 5 * 7      as T, 3 * 5 * 07 as T, 3 * 5 * 07 as T.Magnitude)
            Test().euclidean(1 * 3 * 5 * 7 * 11 as T, 3 * 5 * 07 as T, 3 * 5 * 07 as T.Magnitude)
            Test().euclidean(    3 * 5 * 7 * 11 as T, 3 * 5 * 07 as T, 3 * 5 * 07 as T.Magnitude)
            Test().euclidean(        5 * 7 * 11 as T, 3 * 5 * 07 as T,     5 * 07 as T.Magnitude)
            Test().euclidean(            7 * 11 as T, 3 * 5 * 07 as T,         07 as T.Magnitude)
            Test().euclidean(                11 as T, 3 * 5 * 07 as T,         01 as T.Magnitude)
        }
        
        whereIs(I32.self)
        whereIs(U32.self)
        
        whereIs(DoubleInt<I8>.self)
        whereIs(DoubleInt<U8>.self)
        
        whereIs(InfiniInt<I8>.self)
        whereIs(InfiniInt<U8>.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Each Byte
    //=------------------------------------------------------------------------=
    
    func testCoefficientsForEachBytePairAsI8() throws {
        #if DEBUG
        throw XCTSkip("req. release mode")
        #else
        var lhsCoefficients: Set<I8> = []
        var rhsCoefficients: Set<I8> = []
        
        for a in I8.min...I8.max {
            for b in I8.min...I8.max {
                let bezout = a.bezout(b)
                lhsCoefficients.insert(bezout.lhsCoefficient)
                rhsCoefficients.insert(bezout.rhsCoefficient)
            }
        }
                
        Test().yay(lhsCoefficients.sorted().elementsEqual(-63...63))
        Test().yay(rhsCoefficients.sorted().elementsEqual(-63...63))
        #endif
    }
    
    func testCoefficientsForEachBytePairAsU8() throws {
        #if DEBUG
        throw XCTSkip("req. release mode")
        #else
        var lhsCoefficients: Set<I8> = []
        var rhsCoefficients: Set<I8> = []
        
        for a in U8.min...U8.max {
            for b in U8.min...U8.max {
                let bezout = a.bezout(b)
                lhsCoefficients.insert(bezout.lhsCoefficient)
                rhsCoefficients.insert(bezout.rhsCoefficient)
            }
        }
                
        Test().yay(lhsCoefficients.sorted().elementsEqual(-127...127))
        Test().yay(rhsCoefficients.sorted().elementsEqual(-127...127))
        #endif
    }
    
    func testGreatestCommonDivisorForEachBytePairAsSigned() {
        func whereIs<T>(_ type: T.Type) where T: SignedInteger {
            //=----------------------------------=
            var success = U32.zero
            let values8 = T(I8.min) ... T(I8.max)
            //=----------------------------------=
            for lhs in values8 {
                for rhs in values8 {
                    let bezout = lhs.bezout(rhs)
                    let euclidean = lhs.euclidean(rhs)
                    
                    if  euclidean == bezout.divisor {
                        success  &+= 1
                    }
                    
                    if  euclidean == lhs.magnitude().euclidean(rhs.magnitude()) {
                        success  &+= 1 // proxy validation through unsigned types
                    }
                    
                    if  T(raw: euclidean) == lhs &* bezout.lhsCoefficient &+ rhs &* bezout.rhsCoefficient {
                        success  &+= 1
                    }
                }
            }
            
            Test().same(success, 3 &* 65536)
        }
        
        whereIs(I8 .self)
        #if !DEBUG
        whereIs(I16.self)
        whereIs(I32.self)
        whereIs(I64.self)
        whereIs(IX .self)
        whereIs(DoubleInt<IX>.self)
        whereIs(InfiniInt<IX>.self)
        #endif
    }
    
    func testGreatestCommonDivisorForEachBytePairAsUnsigned() {
        func whereIs<T>(_ type: T.Type) where T: UnsignedInteger {
            //=----------------------------------=
            var coprime = U32.zero
            var success = U32.zero
            let values8 = T(U8.min) ... T(U8.max)
            //=----------------------------------=
            for lhs in values8 {
                for rhs in values8 {
                    let bezout = lhs.bezout(rhs)!
                    let euclidean = lhs.euclidean(rhs)!
                    
                    if  euclidean == 1 {
                        coprime  &+= 1
                    }
                    
                    always: do {
                        let a = I16(lhs) * I16(bezout.lhsCoefficient)
                        let b = I16(rhs) * I16(bezout.rhsCoefficient)
                        success &+= U32(Bit((a + b) == bezout.divisor))
                    }
                    
                    if  euclidean == bezout.divisor {
                        success  &+= 1
                    }
                    
                    if  lhs.isZero, rhs.isZero {
                        success  &+= U32(Bit(euclidean == 0))
                    }   else {
                        success  &+= U32(Bit(euclidean >= 1))
                    }
                    
                    if  bezout == lhs.bezout(rhs) {
                        success  &+= 1
                    }
                    
                    if  euclidean == lhs.euclidean(rhs) {
                        success  &+= 1
                    }
                }
            }
            
            Test().same(coprime, 1 &* 39641)
            Test().same(success, 5 &* 65536)
        }
        
        whereIs(U8 .self)
        #if !DEBUG
        whereIs(U16.self)
        whereIs(U32.self)
        whereIs(U64.self)
        whereIs(UX .self)
        whereIs(DoubleInt<UX>.self)
        whereIs(InfiniInt<UX>.self)
        #endif
    }
}
