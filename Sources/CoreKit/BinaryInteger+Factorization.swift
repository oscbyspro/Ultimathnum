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

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Tranformations
    //=------------------------------------------------------------------------=
    
    /// The greatest common divisor.
    ///
    /// - Note: The greatest common divisor of `(0, 0)` is zero.
    ///
    /// - Note: `Finite<T>` guarantees nonoptional results.
    ///
    /// ### Gretest Common Divisor to Least Common Multiple
    ///
    ///     gcd(a, b) * lcm(a, b) == |a| * |b|
    ///
    /// - Note: This equation is mathematical and subject to overflow.
    ///
    @inlinable public consuming func euclidean(_ other: consuming Self) -> Magnitude? {
        guard
        let value = Finite(exactly: self ),
        let other = Finite(exactly: other)
        else { return nil }
        return value.euclidean(other)
    }
    
    /// The greatest common divisor and `2` Bézout coefficients.
    ///
    /// - Note: The greatest common divisor of `(0, 0)` is zero.
    ///
    /// - Note: The `XGCD` algorithm behaves well for all finite unsigned inputs.
    ///
    /// - Note: `Finite<T>` guarantees nonoptional results.
    ///
    /// ### Bézout's identity
    ///
    /// ```swift
    /// divisor == lhs * lhsCoefficient + rhs * rhsCoefficient
    /// ```
    ///
    /// - Note: This equation is mathematical and subject to overflow.
    ///
    @inlinable public func bezout(_ other: consuming Self) -> Bezout<Magnitude>? {
        guard
        let value = Finite(exactly: self ),
        let other = Finite(exactly: other)
        else { return nil }
        return value.bezout(other)
    }
}

//*============================================================================*
// MARK: + Binary Integer x Factorization x Finite
//*============================================================================*

extension FiniteInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Tranformations
    //=------------------------------------------------------------------------=
    
    /// The greatest common divisor.
    ///
    /// - Note: The greatest common divisor of `(0, 0)` is zero.
    ///
    /// - Note: `Finite<T>` guarantees nonoptional results.
    ///
    /// ### Gretest Common Divisor to Least Common Multiple
    ///
    ///     gcd(a, b) * lcm(a, b) == |a| * |b|
    ///
    /// - Note: This equation is mathematical and subject to overflow.
    ///
    @inlinable public consuming func euclidean(_ other: consuming Self) -> Magnitude {
        let value = Finite(unchecked: self )
        let other = Finite(unchecked: other)
        return value.euclidean(other)
    }
    
    /// The greatest common divisor and `2` Bézout coefficients.
    ///
    /// - Note: The greatest common divisor of `(0, 0)` is zero.
    ///
    /// - Note: The `XGCD` algorithm behaves well for all finite unsigned inputs.
    ///
    /// - Note: `Finite<T>` guarantees nonoptional results.
    ///
    /// ### Bézout's identity
    ///
    /// ```swift
    /// divisor == lhs * lhsCoefficient + rhs * rhsCoefficient
    /// ```
    ///
    /// - Note: This equation is mathematical and subject to overflow.
    ///
    @inlinable public func bezout(_ other: consuming Self) -> Bezout<Magnitude> {
        let value = Finite(unchecked: self )
        let other = Finite(unchecked: other)
        return value.bezout(other)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Guarantees
//=----------------------------------------------------------------------------=

extension Finite where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Tranformations
    //=------------------------------------------------------------------------=
    
    /// The greatest common divisor.
    ///
    /// - Note: The greatest common divisor of `(0, 0)` is zero.
    ///
    /// - Note: `Finite<T>` guarantees nonoptional results.
    ///
    /// ### Gretest Common Divisor to Least Common Multiple
    ///
    ///     gcd(a, b) * lcm(a, b) == |a| * |b|
    ///
    /// - Note: This equation is mathematical and subject to overflow.
    ///
    @inlinable public consuming func euclidean(_ other: consuming Self) -> Value.Magnitude {
        if  Value.isSigned {
            // we only need an unsigned implementation
            return self.magnitude().euclidean(other.magnitude())
        }
        
        var value = (consume self ).magnitude().value
        var other = (consume other).magnitude().value
        
        dividing: while let divisor = Nonzero(exactly: consume other) {
            other = (consume value).remainder(divisor)
            value = (consume divisor).value
        }
        
        return value // as Value.Magnitude as Value.Magnitude
    }
    
    /// The greatest common divisor and `2` Bézout coefficients.
    ///
    /// - Note: The greatest common divisor of `(0, 0)` is zero.
    ///
    /// - Note: The `XGCD` algorithm behaves well for all finite unsigned inputs.
    ///
    /// - Note: `Finite<T>` guarantees nonoptional results.
    ///
    /// ### Bézout's identity
    ///
    /// ```swift
    /// divisor == lhs * lhsCoefficient + rhs * rhsCoefficient
    /// ```
    ///
    /// - Note: This equation is mathematical and subject to overflow.
    ///
    @inlinable public func bezout(_ other: consuming Self) -> Bezout<Value.Magnitude> {
        Bezout(self.magnitude(), other.magnitude())
    }
}
