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
    /// - Note: `Natural<T>` returns nonoptional results.
    ///
    /// ```swift
    /// UXL(repeating: 1).isqrt() // nil
    /// ```
    ///
    /// - Note: Infinite square roots are `nil` on finite machines.
    ///
    @inlinable public func isqrt() -> Optional<Self> {
        Natural(exactly: self)?.isqrt()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Guarantees
//=----------------------------------------------------------------------------=

extension Natural {
    
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
    /// - Note: `Natural<T>` returns nonoptional results.
    ///
    /// ```swift
    /// UXL(repeating: 1).isqrt() // nil
    /// ```
    ///
    /// - Note: Infinite square roots are `nil` on finite machines.
    ///
    @inlinable public func isqrt() -> Value {
        guard let instance = Nonzero(exactly: self.value) else {
            return Value.zero
        }
        
        let magnitude = Value.Magnitude.isqrt(natural: Nonzero(raw: instance))
        return Value.init(raw: magnitude.value)
    }
}

//*============================================================================*
// MARK: * Binary Integer x Geometry x Unsigned
//*============================================================================*

extension UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the integer square root.
    ///
    /// - Requires: `instance ∈ ℕ `
    /// - Requires: `instance ≠ 0 `
    ///
    /// ### Algorithm
    ///
    /// - Seealso: https://en.wikipedia.org/wiki/newton's_method
    ///
    /// - Seealso: https://en.wikipedia.org/wiki/integer_square_root
    ///
    @inlinable internal static func isqrt(
        natural instance: Nonzero<Self>
    )   -> Nonzero<Self> {
        
        Swift.assert(!instance.value.isInfinite)
        Swift.assert(!instance.value.isNegative)
        
        var guess: Nonzero<Self> // must be overestimated initially
        let offset = UX(raw: instance.ilog2()).down(Shift.one) &+ 1
        var revision = Self.lsb.up(Shift(unchecked: Count(raw: offset)))
        
        repeat {
            
            guess = Nonzero(unchecked: consume revision)
            revision = instance.value.quotient(guess).unchecked()
            revision = (consume revision).plus(guess.value).unchecked()
            revision = (consume revision).down(Shift.one)
            
        }   while revision < guess.value
        return ((((((consume guess))))))
    }
}

//*============================================================================*
// MARK: * Binary Integer x Geometry x Unsigned x Systems
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
    /// - Note: `Natural<T>` returns nonoptional results.
    ///
    /// ```swift
    /// UXL(repeating: 1).isqrt() // nil
    /// ```
    ///
    /// - Note: Infinite square roots are `nil` on finite machines.
    ///
    @inlinable public func isqrt() -> Self {
        Nonzero(exactly: self)?.isqrt() ?? Self.zero
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

extension Fallible where Value: UnsignedInteger & SystemsInteger {
    
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
    /// - Note: `Natural<T>` returns nonoptional results.
    ///
    /// ```swift
    /// UXL(repeating: 1).isqrt() // nil
    /// ```
    ///
    /// - Note: Infinite square roots are `nil` on finite machines.
    ///
    @inlinable public func isqrt() -> Self {
        self.value.isqrt().veto(self.error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Guarantees
//=----------------------------------------------------------------------------=

extension Nonzero where Value: UnsignedInteger & SystemsInteger {
    
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
    /// - Note: `Natural<T>` returns nonoptional results.
    ///
    /// ```swift
    /// UXL(repeating: 1).isqrt() // nil
    /// ```
    ///
    /// - Note: Infinite square roots are `nil` on finite machines.
    ///
    @inlinable public func isqrt() -> Value {
        Value.isqrt(natural: self).value
    }
}
