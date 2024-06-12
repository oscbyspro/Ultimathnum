//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: + Binary Integer x Factorization
//*============================================================================*

extension FiniteInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the greatest common divisor.
    ///
    /// - Note: The greatest common divisor of `(0, 0)` is zero.
    ///
    /// ### Gretest Common Divisor to Least Common Multiple
    ///
    /// ```swift
    /// gcd(a, b) * lcm(a, b) == |a| * |b|
    /// ```
    ///
    @inlinable public consuming func euclidean(_ other: consuming Self) -> Magnitude {
        Self.euclidean(Finite(unchecked: self), Finite(unchecked: other))
    }
    
    /// Returns the greatest common divisor and `2` Bézout coefficients.
    ///
    /// - Note: The greatest common divisor of `(0, 0)` is zero.
    ///
    /// - Note: The `XGCD` algorithm behaves well for all finite unsigned inputs.
    ///
    /// ### Bézout's identity
    ///
    /// ```swift
    /// divisor == lhs * lhsCoefficient + rhs * rhsCoefficient
    /// ```
    ///
    /// - Note: This equation is mathematical and subject to overflow.
    ///
    @inlinable public consuming func bezout(
        _ other: consuming Self
    )   -> (
        divisor: Magnitude,
        lhsCoefficient: Signitude,
        rhsCoefficient: Signitude
    )   where Self: UnsignedInteger {
        Self.bezout(Finite(unchecked: self), Finite(unchecked: other))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the greatest common divisor.
    ///
    /// - Note: The greatest common divisor of `(0, 0)` is zero.
    ///
    /// ### Gretest Common Divisor to Least Common Multiple
    ///
    /// ```swift
    /// gcd(a, b) * lcm(a, b) == |a| * |b|
    /// ```
    ///
    @inlinable public static func euclidean(
        _ lhs: consuming Finite<Self>, 
        _ rhs: consuming Finite<Self>
    )   -> Magnitude {
        
        var value = (consume lhs).value
        var other = (consume rhs).value
        
        dividing: while !other.isZero {
            (value, other) = (copy other, value.remainder(Divisor(unchecked: other)))
        }
        
        return value.magnitude() as Magnitude
    }
    
    /// Returns the greatest common divisor and `2` Bézout coefficients.
    ///
    /// - Note: The greatest common divisor of `(0, 0)` is zero.
    ///
    /// - Note: The `XGCD` algorithm behaves well for all finite unsigned inputs.
    ///
    /// ### Bézout's identity
    ///
    /// ```swift
    /// divisor == lhs * lhsCoefficient + rhs * rhsCoefficient
    /// ```
    ///
    /// - Note: This equation is mathematical and subject to overflow.
    ///
    @inlinable public static func bezout(
        _ lhs: consuming Finite<Self>,
        _ rhs: consuming Finite<Self>
    )   -> (
        divisor: Magnitude,
        lhsCoefficient: Signitude,
        rhsCoefficient: Signitude
    )   where Self: UnsignedInteger {

        var value = (consume lhs).value
        var other = (consume rhs).value
        
        var x: (Signitude, Signitude) = (1, 0)
        var y: (Signitude, Signitude) = (0, 1)
        
        // note that the bit cast may overflow in the final iteration
        dividing: while !other.isZero {
            let (division) = (value).division(Divisor(unchecked: copy other)).unchecked()
            (value, other) = (other, division.remainder)
            x = (x.1, x.0 &- x.1 &* Signitude(raw: division.quotient))
            y = (y.1, y.0 &- y.1 &* Signitude(raw: division.quotient))
        }
        
        return (divisor: value, lhsCoefficient: x.0, rhsCoefficient: y.0)
    }
}
