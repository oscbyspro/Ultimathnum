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
// MARK: * Infini Int x Euclidean
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testEuclideanBySmallPrimeComposites() {
        func whereTheElementIs<E>(_ type: E.Type) where E: SystemsInteger {
            typealias T = InfiniInt<E>
            typealias M = T.Magnitude
            //=----------------------------------=
            let primes54 = Self.primes54.map(T.init(_:))
            //=----------------------------------=
            always: do  {
                let lhs = primes54[..<27].reduce(1 as T, *)
                let rhs = primes54[27...].reduce(1 as T, *)
                Test().euclidean(lhs, rhs, 1)
            }
            
            always: do  {
                let all = primes54.reduce(1 as T, *)
                Test().euclidean(all, all, M(all))
            }
            
            always: do  {
                let lhs = primes54[..<40].reduce(1 as T, *)
                let rhs = primes54[10...].reduce(1 as T, *)
                let gcd = primes54[10..<40].lazy.map(M.init(_:)).reduce(1 as M, *)
                
                Test().euclidean(lhs, rhs, gcd)
                Test().euclidean(lhs.squared().unwrap(), rhs.squared().unwrap(), gcd.squared().unwrap())
            }
            
            always: do  {
                let lhs = primes54[..<50].reduce(1 as T, *)
                let rhs = primes54[20...].reduce(1 as T, *)
                let gcd = primes54[20..<50].lazy.map(M.init(_:)).reduce(1 as M, *)
                
                Test().euclidean(lhs, rhs, gcd)
                Test().euclidean(lhs.squared().unwrap(), rhs.squared().unwrap(), gcd.squared().unwrap())
            }
        }
        
        for element in Self.elements {
            whereTheElementIs(element)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testEuclideanInfiniteInputsTrap() throws {
        throw XCTSkip("req. crash tests")
    }
}
