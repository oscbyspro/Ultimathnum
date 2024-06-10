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
// MARK: * Test x Euclidean
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func euclidean<T>(_ lhs: T, _ rhs: T, _ gcd: T.Magnitude?) where T: BinaryInteger {
        //=--------------------------------------=
        typealias M = T.Magnitude
        //=--------------------------------------=
        if  let gcd, !lhs.isInfinite, !rhs.isInfinite {
            let lhs = Finite(lhs)
            let rhs = Finite(rhs)
            
            let lhsMagnitude = lhs.magnitude()
            let rhsMagnitude = rhs.magnitude()
            
            let result  = T.euclidean (lhs, rhs)
            let result1 = M.euclidean1(lhsMagnitude, rhsMagnitude)
            let result2 = M.euclidean2(lhsMagnitude, rhsMagnitude)
            
            same(result, gcd, "euclidean [0]")
            same(result, result1.divisor, "euclidean [1]")
            same(result, result2.divisor, "euclidean [2]")
            same(result1.lhsCoefficient, result2.lhsCoefficient, "euclidean [3]")
            
            if  T.isSigned {
                let lhsComplement = Finite(lhs.value.complement())
                let rhsComplement = Finite(rhs.value.complement())
                
                same(result, T.euclidean(lhs, rhsComplement), "euclidean [4]")
                same(result, T.euclidean(lhsComplement, rhs), "euclidean [5]")
                same(result, T.euclidean(lhsComplement, rhsComplement), "euclidean [6]")
            }
            
            if  IX.size > T.size {
                let a = IX(lhs.value) * IX(result2.lhsCoefficient)
                let b = IX(rhs.value) * IX(result2.rhsCoefficient)
                same(result, T.Magnitude(a + b), "bézout")
            }
            
            always: do {
                let a = lhsMagnitude.value &* M(raw: result2.lhsCoefficient)
                let b = rhsMagnitude.value &* M(raw: result2.rhsCoefficient)
                same(result, a &+ b, "wrapping bézout")
            }
            
        }   else {
            none(gcd, "GCD(inf, x) and GCD(x, inf) are bad")
        }
    }
}
