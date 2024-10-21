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
    /// - Note: `Finite<T>` guarantees nonoptional results.
    ///
    /// ### Greatest common divisor
    ///
    ///     1. gcd(a, 0) == abs( a)
    ///     2. gcd(a, b) == gcd(±a, ±b)
    ///     3. gcd(a, b) == gcd( a,  b % a)
    ///     4. gcd(a, b) == gcd( b,  a)
    ///
    /// ### Gretest Common Divisor to Least Common Multiple
    ///
    ///     gcd(a, b) * lcm(a, b) == |a| * |b|
    ///
    /// - Note: This equation is subject to overflow.
    ///
    @inlinable public consuming func euclidean(_ other: consuming Self) -> Magnitude? {
        //=--------------------------------------=
        // micro: T.predicate(x) then T(unsafe: x)
        //=--------------------------------------=
        guard  Finite.predicate(self ) else { return nil }
        guard  Finite.predicate(other) else { return nil }
        return Finite(unsafe: self).euclidean(Finite(unsafe: other))
    }
    
    /// The greatest common divisor and `2` Bézout coefficients.
    ///
    /// - Note: `Finite<T>` guarantees nonoptional results.
    ///
    /// ### Greatest common divisor
    ///
    ///     1. gcd(a, 0) == abs( a)
    ///     2. gcd(a, b) == gcd(±a, ±b)
    ///     3. gcd(a, b) == gcd( a,  b % a)
    ///     4. gcd(a, b) == gcd( b,  a)
    ///
    /// ### Bézout's identity
    ///
    ///     divisor == lhs * lhsCoefficient + rhs * rhsCoefficient
    ///
    /// - Note: This equation is subject to overflow.
    ///
    @inlinable public func bezout(_ other: consuming Self) -> Bezout<Magnitude>? {
        //=--------------------------------------=
        // micro: T.predicate(x) then T(unsafe: x)
        //=--------------------------------------=
        guard  Finite.predicate(self ) else { return nil }
        guard  Finite.predicate(other) else { return nil }
        return Finite(unsafe: self).bezout(Finite(unsafe: other))
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
    /// - Note: `Finite<T>` guarantees nonoptional results.
    ///
    /// ### Greatest common divisor
    ///
    ///     1. gcd(a, 0) == abs( a)
    ///     2. gcd(a, b) == gcd(±a, ±b)
    ///     3. gcd(a, b) == gcd( a,  b % a)
    ///     4. gcd(a, b) == gcd( b,  a)
    ///
    /// ### Gretest Common Divisor to Least Common Multiple
    ///
    ///     gcd(a, b) * lcm(a, b) == |a| * |b|
    ///
    /// - Note: This equation is subject to overflow.
    ///
    @inlinable public consuming func euclidean(_ other: consuming Self) -> Magnitude {
        let value = Finite(unchecked: self )
        let other = Finite(unchecked: other)
        return value.euclidean(other)
    }
    
    /// The greatest common divisor and `2` Bézout coefficients.
    ///
    /// - Note: `Finite<T>` guarantees nonoptional results.
    ///
    /// ### Greatest common divisor
    ///
    ///     1. gcd(a, 0) == abs( a)
    ///     2. gcd(a, b) == gcd(±a, ±b)
    ///     3. gcd(a, b) == gcd( a,  b % a)
    ///     4. gcd(a, b) == gcd( b,  a)
    ///
    /// ### Bézout's identity
    ///
    ///     divisor == lhs * lhsCoefficient + rhs * rhsCoefficient
    ///
    /// - Note: This equation is subject to overflow.
    ///
    @inlinable public func bezout(_ other: consuming Self) -> Bezout<Magnitude> {
        let value = Finite(unchecked: self )
        let other = Finite(unchecked: other)
        return value.bezout(other)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Guarantee
//=----------------------------------------------------------------------------=

extension Finite where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Tranformations
    //=------------------------------------------------------------------------=
    
    /// The greatest common divisor.
    ///
    /// - Note: `Finite<T>` guarantees nonoptional results.
    ///
    /// ### Greatest common divisor
    ///
    ///     1. gcd(a, 0) == abs( a)
    ///     2. gcd(a, b) == gcd(±a, ±b)
    ///     3. gcd(a, b) == gcd( a,  b % a)
    ///     4. gcd(a, b) == gcd( b,  a)
    ///
    /// ### Gretest Common Divisor to Least Common Multiple
    ///
    ///     gcd(a, b) * lcm(a, b) == |a| * |b|
    ///
    /// - Note: This equation is subject to overflow.
    ///
    @inlinable public consuming func euclidean(_ other: consuming Self) -> Value.Magnitude {
        if  Value.isSigned {
            // we only need an unsigned implementation
            return self.magnitude().euclidean(other.magnitude())
        }
        
        var value = (consume self ).magnitude().value
        var other = (consume other).magnitude().value
        //=--------------------------------------=
        // micro: T.predicate(x) then T(unsafe: x)
        //=--------------------------------------=
        dividing: while   Nonzero.predicate(other) {
            let divisor = Nonzero(unsafe: consume other)
            other = Finite<Value.Magnitude>(unchecked: consume value).remainder(divisor)
            value = (consume divisor).value
        }
        
        return value // as Value.Magnitude
    }
    
    /// The greatest common divisor and `2` Bézout coefficients.
    ///
    /// - Note: `Finite<T>` guarantees nonoptional results.
    ///
    /// ### Greatest common divisor
    ///
    ///     1. gcd(a, 0) == abs( a)
    ///     2. gcd(a, b) == gcd(±a, ±b)
    ///     3. gcd(a, b) == gcd( a,  b % a)
    ///     4. gcd(a, b) == gcd( b,  a)
    ///
    /// ### Bézout's identity
    ///
    ///     divisor == lhs * lhsCoefficient + rhs * rhsCoefficient
    ///
    /// - Note: This equation is subject to overflow.
    ///
    @inlinable public func bezout(_ other: consuming Self) -> Bezout<Value.Magnitude> {
        Bezout(self, other)
    }
}
