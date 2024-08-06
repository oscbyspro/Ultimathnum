//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Logarithm
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The binary logarithm of `self` rounded towards zero.
    ///
    /// ```swift
    /// I8( 4).ilog2() // 2
    /// I8( 3).ilog2() // 1
    /// I8( 2).ilog2() // 1
    /// I8( 1).ilog2() // 0
    /// I8( 0).ilog2() // nil
    /// I8(-1).ilog2() // nil
    /// I8(-2).ilog2() // nil
    /// I8(-3).ilog2() // nil
    /// I8(-4).ilog2() // nil
    /// ```
    ///
    /// - Note: `Nonzero<T.Magnitude>` returns nonoptional results.
    ///
    @inlinable public borrowing func ilog2() -> Optional<Count<IX>> {
        // TODO: consider BinaryInteger/isPositive
        guard  self.signum() == Signum.more else { return nil }
        return Nonzero(unchecked: Magnitude(raw: copy self)).ilog2()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Guarantees
//=----------------------------------------------------------------------------=

extension Nonzero where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The binary logarithm of `self` rounded towards zero.
    ///
    /// ```swift
    /// I8( 4).ilog2() // 2
    /// I8( 3).ilog2() // 1
    /// I8( 2).ilog2() // 1
    /// I8( 1).ilog2() // 0
    /// I8( 0).ilog2() // nil
    /// I8(-1).ilog2() // nil
    /// I8(-2).ilog2() // nil
    /// I8(-3).ilog2() // nil
    /// I8(-4).ilog2() // nil
    /// ```
    ///
    /// - Note: `Nonzero<T.Magnitude>` returns nonoptional results.
    ///
    @inlinable public borrowing func ilog2() -> Optional<Count<IX>> {
        guard !self.value.isNegative else { return nil }
        let magnitude = Nonzero<Value.Magnitude>(unchecked: Value.Magnitude(raw: self.value))
        return magnitude.ilog2() as Count<IX>
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Guarantees x Unsigned
//=----------------------------------------------------------------------------=

extension Nonzero where Value: UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The binary logarithm of `self` rounded towards zero.
    ///
    /// ```swift
    /// I8( 4).ilog2() // 2
    /// I8( 3).ilog2() // 1
    /// I8( 2).ilog2() // 1
    /// I8( 1).ilog2() // 0
    /// I8( 0).ilog2() // nil
    /// I8(-1).ilog2() // nil
    /// I8(-2).ilog2() // nil
    /// I8(-3).ilog2() // nil
    /// I8(-4).ilog2() // nil
    /// ```
    ///
    /// - Note: `Nonzero<T.Magnitude>` returns nonoptional results.
    ///
    @inlinable public borrowing func ilog2() -> Count<IX> {
        let mask = UX(raw: Value.size).minus(1).unchecked()
        let dzbc = UX(raw: self.value.descending(0 as Bit))
        return Count.init(raw: mask.minus(dzbc).unchecked())
    }
}
