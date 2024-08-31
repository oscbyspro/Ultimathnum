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
        let lhsMagnitude = lhs.magnitude()
        let rhsMagnitude = rhs.magnitude()
        
        let euclidean = lhs.euclidean(rhs)
        let bezout = lhsMagnitude.bezout(rhsMagnitude)
        
        same(euclidean, expectation,     "euclidean [0]")
        same(euclidean, bezout?.divisor, "euclidean [1]")
        
        if  T.isSigned {
            let lhsComplement = lhs.complement()
            let rhsComplement = rhs.complement()
            
            same(euclidean, lhs.euclidean(rhsComplement), "euclidean [2]")
            same(euclidean, lhsComplement.euclidean(rhs), "euclidean [3]")
            same(euclidean, lhsComplement.euclidean(rhsComplement), "euclidean [4]")
        }
        
        if  let bezout, IX.size > T.size {
            let a = IX(lhs) * IX(bezout.lhsCoefficient)
            let b = IX(rhs) * IX(bezout.rhsCoefficient)
            same(euclidean, T.Magnitude(a + b), "bézout identity")
        }
        
        if  let bezout {
            let a = lhsMagnitude &* T.Magnitude(raw: bezout.lhsCoefficient)
            let b = rhsMagnitude &* T.Magnitude(raw: bezout.rhsCoefficient)
            same(euclidean, a &+ b, "wrapping bézout identity")
        }
            
        if  let expectation, !expectation.isZero {
            same(lhsMagnitude % expectation, T.Magnitude.zero, "a % GCD(a, b) == 0")
            same(rhsMagnitude % expectation, T.Magnitude.zero, "b % GCD(a, b) == 0")
        }
    }
}
