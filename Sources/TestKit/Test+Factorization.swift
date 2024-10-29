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
    
    /// - Note: It also checks each complement combination when `T.isSigned`.
    public func euclidean<T>(_ lhs: T, _ rhs: T, _ expectation: T.Magnitude?) where T: BinaryInteger {
        func check(_ lhs: T, _ rhs: T) {
            let euclidean = lhs.euclidean(rhs)
            let bezout = lhs.bezout(rhs)
            
            same(euclidean, expectation,     "euclidean [0]")
            same(euclidean, bezout?.divisor, "euclidean [1]")
            
            if  let bezout, IX.size > T.size {
                let a = IX(lhs) * IX(bezout.lhsCoefficient)
                let b = IX(rhs) * IX(bezout.rhsCoefficient)
                same(euclidean, T.Magnitude(a + b), "bézout identity")
            }
            
            if  let bezout {
                let a = T.Magnitude(raw: lhs) &* T.Magnitude(raw: bezout.lhsCoefficient)
                let b = T.Magnitude(raw: rhs) &* T.Magnitude(raw: bezout.rhsCoefficient)
                same(euclidean, a &+ b, "wrapping bézout identity")
            }
                
            if  let expectation, !expectation.isZero {
                same(lhs.magnitude() % expectation, T.Magnitude.zero, "a % GCD(a, b) == 0")
                same(rhs.magnitude() % expectation, T.Magnitude.zero, "b % GCD(a, b) == 0")
            }
        }
        
        always: do {
            check(lhs, rhs)
        }
        
        if  T.isSigned {
            let lhsComplement = lhs.complement()
            let rhsComplement = rhs.complement()
            
            check(lhs, rhsComplement)
            check(lhsComplement, rhs)
            check(lhsComplement, rhsComplement)
        }
    }
}
