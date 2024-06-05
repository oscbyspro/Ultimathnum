//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: + Binary Integer x Euclidean (GCD)
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the greatest common divisor.
    ///
    /// - Note: The greatest common divisor of `(0, 0)` is zero.
    ///
    @inlinable public consuming func euclidean(_ other: consuming Self) -> Magnitude {
        dividing: while other != .zero {
            (self, other) = (copy other, self.remainder(Divisor(unchecked: other)))
        }
        
        return self.magnitude() as Magnitude
    }
}

//*============================================================================*
// MARK: + Binary Integer x Euclidean (GCD) x Unsigned
//*============================================================================*

extension UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the greatest common divisor and `1` Bézout coefficient.
    ///
    /// - Note: The greatest common divisor of `(0, 0)` is zero.
    ///
    /// - Note: The `XGCD` algorithm behaves well for all unsigned inputs.
    ///
    /// ### Bézout's identity
    ///
    /// ```swift
    /// divisor == lhs * lhsCoefficient + rhs * rhsCoefficient
    /// ```
    ///
    /// - Note: This equation is mathematical and subject to overflow.
    ///
    @inlinable public consuming func euclidean1(_ other: consuming Self) 
    -> (divisor: Self, lhsCoefficient: Signitude) {
        
        var x: (Signitude, Signitude) = (1, 0)
        
        dividing: while other != .zero {
            let (division) = self.division(Divisor(unchecked: copy other)).unchecked()
            
            (self,  other) = (other, division.remainder)
            x = (x.1, x.0 &- x.1 &* Signitude(raw: division.quotient))
        }
        
        return (divisor: self, lhsCoefficient: x.0)
    }
    
    /// Returns the greatest common divisor and `2` Bézout coefficients.
    ///
    /// - Note: The greatest common divisor of `(0, 0)` is zero.
    ///
    /// - Note: The `XGCD` algorithm behaves well for all unsigned inputs.
    ///
    /// ### Bézout's identity
    ///
    /// ```swift
    /// divisor == lhs * lhsCoefficient + rhs * rhsCoefficient
    /// ```
    ///
    /// - Note: This equation is mathematical and subject to overflow.
    ///
    @inlinable public consuming func euclidean2(_ other: consuming Self) 
    -> (divisor: Self, lhsCoefficient: Signitude, rhsCoefficient: Signitude) {
        
        var x: (Signitude, Signitude) = (1, 0)
        var y: (Signitude, Signitude) = (0, 1)
        
        dividing: while other != .zero {
            let (division) = self.division(Divisor(unchecked: copy other)).unchecked()
            
            (self,  other) = (other, division.remainder)
            x = (x.1, x.0 &- x.1 &* Signitude(raw: division.quotient))
            y = (y.1, y.0 &- y.1 &* Signitude(raw: division.quotient))
        }
        
        return (divisor: self, lhsCoefficient: x.0, rhsCoefficient: y.0)
    }
}
