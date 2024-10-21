//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Geometry
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the integer square root of `self`.
    ///
    /// ```swift
    /// I8( 4).isqrt() // 2
    /// I8( 3).isqrt() // 1
    /// I8( 2).isqrt() // 1
    /// I8( 1).isqrt() // 1
    /// I8( 0).isqrt() // 0
    /// I8(-1).isqrt() // nil
    /// I8(-2).isqrt() // nil
    /// I8(-3).isqrt() // nil
    /// I8(-4).isqrt() // nil
    /// ```
    ///
    /// - Note: `Natural<T>` guarantees nonoptional results.
    ///
    /// ### Algorithm
    ///
    /// - Seealso: https://en.wikipedia.org/wiki/newton's_method
    ///
    /// - Seealso: https://en.wikipedia.org/wiki/integer_square_root
    ///
    @inlinable public func isqrt() -> Optional<Self> {
        Natural(exactly: self)?.isqrt()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Guarantee
//=----------------------------------------------------------------------------=

extension Natural {
    
    /// Returns the integer square root of `self`.
    ///
    /// ```swift
    /// I8( 4).isqrt() // 2
    /// I8( 3).isqrt() // 1
    /// I8( 2).isqrt() // 1
    /// I8( 1).isqrt() // 1
    /// I8( 0).isqrt() // 0
    /// I8(-1).isqrt() // nil
    /// I8(-2).isqrt() // nil
    /// I8(-3).isqrt() // nil
    /// I8(-4).isqrt() // nil
    /// ```
    ///
    /// - Note: `Natural<T>` guarantees nonoptional results.
    ///
    /// ### Algorithm
    ///
    /// - Seealso: https://en.wikipedia.org/wiki/newton's_method
    ///
    /// - Seealso: https://en.wikipedia.org/wiki/integer_square_root
    ///
    @inlinable public func isqrt() -> Value {
        if  Value.isSigned {
            // we only need an unsigned implementation
            return Value(raw: self.magnitude().isqrt())
        }
        
        guard let instance = Nonzero(exactly: self.magnitude().value) else {
            return Value.zero
        }
        
        var guess: Nonzero<Value.Magnitude> // initial guess must be overestimated
        let offset = UX(raw: instance.ilog2()).down(Shift.one).incremented().unchecked()
        var revision = Value.Magnitude.lsb.up(Shift(unchecked: Count(raw: offset)))
        
        repeat {
            
            guess    = Nonzero<Value.Magnitude>(unchecked: revision)
            revision = Natural<Value.Magnitude>(unchecked: instance.value).quotient(guess)
            revision = (consume revision).plus(guess.value).unchecked()
            revision = (consume revision).down(Shift.one)
            
        }while revision < guess.value
        return Value(raw: guess.value)
    }
}

//*============================================================================*
// MARK: * Binary Integer x Geometry x Natural
//*============================================================================*

extension BinaryInteger where Self: UnsignedInteger & SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the integer square root of `self`.
    ///
    /// ```swift
    /// I8( 4).isqrt() // 2
    /// I8( 3).isqrt() // 1
    /// I8( 2).isqrt() // 1
    /// I8( 1).isqrt() // 1
    /// I8( 0).isqrt() // 0
    /// I8(-1).isqrt() // nil
    /// I8(-2).isqrt() // nil
    /// I8(-3).isqrt() // nil
    /// I8(-4).isqrt() // nil
    /// ```
    ///
    /// - Note: `Natural<T>` guarantees nonoptional results.
    ///
    /// ### Algorithm
    ///
    /// - Seealso: https://en.wikipedia.org/wiki/newton's_method
    ///
    /// - Seealso: https://en.wikipedia.org/wiki/integer_square_root
    ///
    @inlinable public func isqrt() -> Self {
        Natural(unchecked: self).isqrt()
    }
}
