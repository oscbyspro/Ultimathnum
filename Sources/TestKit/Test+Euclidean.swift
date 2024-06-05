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
    
    public func euclidean<T>(_ lhs: T, _ rhs: T, _ gcd: T.Magnitude) where T: SignedInteger {
        //=--------------------------------------=
        let lhsMagnitude = lhs.magnitude()
        let rhsMagnitude = rhs.magnitude()
        //=--------------------------------------=
        let result0 = lhs.euclidean(rhs)
        let result1 = lhsMagnitude.euclidean1(rhsMagnitude)
        let result2 = lhsMagnitude.euclidean2(rhsMagnitude)
        
        same(result0, result1.divisor, "euclidean [0]")
        same(result0, result2.divisor, "euclidean [1]")
        same(result1.lhsCoefficient, result2.lhsCoefficient, "euclidean [2]")
        
        same(result0, lhs.euclidean(rhs.complement()), "euclidean [3]")
        same(result0, lhs.complement().euclidean(rhs), "euclidean [4]")
        same(result0, lhs.complement().euclidean(rhs.complement()), "euclidean [5]")
        
        if  IX.size > T.size {
            let a = IX(lhs) * IX(result2.lhsCoefficient)
            let b = IX(rhs) * IX(result2.rhsCoefficient)
            same(result0,  T.Magnitude(a + b), "bézout")
        }
        
        always: do {
            let a = T(raw: lhsMagnitude) &* result2.lhsCoefficient
            let b = T(raw: rhsMagnitude) &* result2.rhsCoefficient
            same(result0,  T.Magnitude(raw: a &+ b), "wrapping bézout")
        }
    }
}
