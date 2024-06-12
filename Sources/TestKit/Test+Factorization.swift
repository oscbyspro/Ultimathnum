//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Test x Factorization
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func euclidean<T>(_ lhs: T, _ rhs: T, _ expectation: T.Magnitude?) where T: BinaryInteger {
        //=--------------------------------------=
        typealias M = T.Magnitude
        //=--------------------------------------=
        if  let expectation, !lhs.isInfinite, !rhs.isInfinite {
            let lhs = Finite(lhs)
            let rhs = Finite(rhs)
            
            let lhsMagnitude = lhs.magnitude()
            let rhsMagnitude = rhs.magnitude()
            
            let euclidean = T.euclidean(lhs, rhs)
            let bezout = M.bezout(lhsMagnitude, rhsMagnitude)
            
            same(euclidean, expectation,    "euclidean [0]")
            same(euclidean, bezout.divisor, "euclidean [1]")
            
            if  T.isSigned {
                let lhsComplement = Finite(lhs.value.complement())
                let rhsComplement = Finite(rhs.value.complement())
                
                same(euclidean, T.euclidean(lhs, rhsComplement), "euclidean [2]")
                same(euclidean, T.euclidean(lhsComplement, rhs), "euclidean [3]")
                same(euclidean, T.euclidean(lhsComplement, rhsComplement), "euclidean [4]")
            }
            
            if  IX.size > T.size {
                let a = IX(lhs.value) * IX(bezout.lhsCoefficient)
                let b = IX(rhs.value) * IX(bezout.rhsCoefficient)
                same(euclidean, T.Magnitude(a + b), "bézout identity")
            }
            
            always: do {
                let a = lhsMagnitude.value &* M(raw: bezout.lhsCoefficient)
                let b = rhsMagnitude.value &* M(raw: bezout.rhsCoefficient)
                same(euclidean, a &+ b, "wrapping bézout identity")
            }
                
            if !expectation.isZero {
                same(lhsMagnitude.value % expectation, M.zero, "a % GCD(a, b) == 0")
                same(rhsMagnitude.value % expectation, M.zero, "b % GCD(a, b) == 0")
            }
                        
        }   else {
            none(expectation, "GCD(inf, x) and GCD(x, inf) are bad")
        }
    }
}
