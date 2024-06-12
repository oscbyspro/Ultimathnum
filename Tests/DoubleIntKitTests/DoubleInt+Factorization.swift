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
import TestKit

//*============================================================================*
// MARK: * Double Int x Factorization
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testGreatestCommonDivisorOfSmallPrimeComposites() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            //=----------------------------------=
            let primes54 = primes54.map(T.init(_:))
            //=----------------------------------=
            func check(_ test: Test, lhs a: Range<Int>, rhs b: Range<Int>, gcd c: Range<Int>) {
                let lhs = primes54[a].reduce(1, *)
                let rhs = primes54[b].reduce(1, *)
                let gcd = primes54[c].reduce(1, *).magnitude()
                test.euclidean(lhs, rhs, gcd)
            }
            //=----------------------------------=
            check(Test(), lhs: 00 ..< 27, rhs: 27 ..< 54, gcd: 27 ..< 27)
            check(Test(), lhs: 00 ..< 30, rhs: 20 ..< 50, gcd: 20 ..< 30)
            check(Test(), lhs: 11 ..< 31, rhs: 21 ..< 41, gcd: 21 ..< 31)
            check(Test(), lhs: 12 ..< 32, rhs: 22 ..< 42, gcd: 22 ..< 32)
            check(Test(), lhs: 13 ..< 33, rhs: 23 ..< 43, gcd: 23 ..< 33)
        }
        
        whereIs(I256.self)
        whereIs(U256.self)
    }
}
