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
    /// I8( 8).ilog2() // 3
    /// I8( 7).ilog2() // 2
    /// I8( 6).ilog2() // 2
    /// I8( 5).ilog2() // 2
    /// I8( 4).ilog2() // 2
    /// I8( 3).ilog2() // 1
    /// I8( 2).ilog2() // 1
    /// I8( 1).ilog2() // 0
    /// I8( 0).ilog2() // nil
    /// I8(-1).ilog2() // nil
    /// ```
    ///
    /// - Note: `Nonzero<T.Magnitude>` guarantees nonoptional results.
    ///
    @inlinable public borrowing func ilog2() -> Optional<Count> {
        guard self.isPositive else { return nil }
        let positive = Nonzero(unchecked: Magnitude(raw: copy self))
        return positive.ilog2() as Count
    }
}

//*============================================================================*
// MARK: * Binary Integer x Logarithm x Unsigned
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Guarantee
//=----------------------------------------------------------------------------=

extension Nonzero where Value: UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The binary logarithm of `self` rounded towards zero.
    ///
    /// ```swift
    /// I8( 8).ilog2() // 3
    /// I8( 7).ilog2() // 2
    /// I8( 6).ilog2() // 2
    /// I8( 5).ilog2() // 2
    /// I8( 4).ilog2() // 2
    /// I8( 3).ilog2() // 1
    /// I8( 2).ilog2() // 1
    /// I8( 1).ilog2() // 0
    /// I8( 0).ilog2() // nil
    /// I8(-1).ilog2() // nil
    /// ```
    ///
    /// - Note: `Nonzero<T.Magnitude>` guarantees nonoptional results.
    ///
    @inlinable public borrowing func ilog2() -> Count {
        let mask = UX(raw: Value.size).minus(1).unchecked()
        let dzbc = UX(raw: self.value.descending(Bit.zero))
        return Count.init(raw: mask.minus(dzbc).unchecked())
    }
}
