//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Infini Int x Factorization
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testGreatestCommonDivisorOfSmallPrimeComposites() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            //=----------------------------------=
            let primes54 = primes54.map(T.init(_:))
            let result54 = primes54.reduce(1, *)
            //=----------------------------------=
            func check(_ test: Test, lhs a: Range<Int>, rhs b: Range<Int>, gcd c: Range<Int>) {
                let lhs = primes54[a].reduce(1, *)
                let rhs = primes54[b].reduce(1, *)
                let gcd = primes54[c].reduce(1, *).magnitude()
                test.euclidean(lhs, rhs, gcd)
                test.euclidean(
                    lhs.squared().unwrap(),
                    rhs.squared().unwrap(),
                    gcd.squared().unwrap()
                )
            }
            //=----------------------------------=
            check(Test(), lhs: 00 ..< 27, rhs: 27 ..< 54, gcd: 27 ..< 27)
            check(Test(), lhs: 00 ..< 30, rhs: 20 ..< 50, gcd: 20 ..< 30)
            check(Test(), lhs: 11 ..< 31, rhs: 21 ..< 41, gcd: 21 ..< 31)
            check(Test(), lhs: 12 ..< 32, rhs: 22 ..< 42, gcd: 22 ..< 32)
            check(Test(), lhs: 13 ..< 33, rhs: 23 ..< 43, gcd: 23 ..< 33)
            //=----------------------------------=
            Test().euclidean(result54, result54, T.Magnitude(result54))
        }
        
        whereIs(InfiniInt<IX>.self)
        whereIs(InfiniInt<UX>.self)
        #if !DEBUG
        whereIs(InfiniInt<I8>.self)
        whereIs(InfiniInt<U8>.self)
        #endif
    }
    
    func testGreatestCommonDivisorOfInfiniteInputsIsInvalid() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            Test().euclidean(~1 as T, ~1 as T, T.isSigned ? 2 : nil)
            Test().euclidean(~1 as T, ~0 as T, T.isSigned ? 1 : nil)
            Test().euclidean(~1 as T,  0 as T, T.isSigned ? 2 : nil)
            Test().euclidean(~1 as T,  1 as T, T.isSigned ? 1 : nil)
            
            Test().euclidean(~0 as T, ~1 as T, T.isSigned ? 1 : nil)
            Test().euclidean(~0 as T, ~0 as T, T.isSigned ? 1 : nil)
            Test().euclidean(~0 as T,  0 as T, T.isSigned ? 1 : nil)
            Test().euclidean(~0 as T,  1 as T, T.isSigned ? 1 : nil)
            
            Test().euclidean( 0 as T, ~1 as T, T.isSigned ? 2 : nil)
            Test().euclidean( 0 as T, ~0 as T, T.isSigned ? 1 : nil)
            Test().euclidean( 0 as T,  0 as T, 0)
            Test().euclidean( 0 as T,  1 as T, 1)
            
            Test().euclidean( 1 as T, ~1 as T, T.isSigned ? 1 : nil)
            Test().euclidean( 1 as T, ~0 as T, T.isSigned ? 1 : nil)
            Test().euclidean( 1 as T,  0 as T, 1)
            Test().euclidean( 1 as T,  1 as T, 1)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
