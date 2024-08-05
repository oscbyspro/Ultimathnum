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
    
    /// The real binary logarithm of `self` rounded towards zero.
    ///
    /// ```swift
    /// I8( 4).ilog2() // 2
    /// I8( 3).ilog2() // 1
    /// I8( 2).ilog2() // 1
    /// I8( 1).ilog2() // 0
    /// I8( 0).ilog2() // nil
    /// I8(-1).ilog2() // 0
    /// I8(-2).ilog2() // 1
    /// I8(-3).ilog2() // 1
    /// I8(-4).ilog2() // 2
    /// ```
    ///
    /// - Note: You may use `Nonzero<T>` for nonoptional results.
    ///
    /// - Note: Signed integers do not need to call `magnitude()`.
    ///
    @inlinable public borrowing func ilog2() -> Optional<Count<IX>> {
        Nonzero(exactly: copy self)?.ilog2()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Guarantees
//=----------------------------------------------------------------------------=

extension Nonzero where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The real binary logarithm of `self` rounded towards zero.
    ///
    /// ```swift
    /// I8( 4).ilog2() // 2
    /// I8( 3).ilog2() // 1
    /// I8( 2).ilog2() // 1
    /// I8( 1).ilog2() // 0
    /// I8( 0).ilog2() // nil
    /// I8(-1).ilog2() // 0
    /// I8(-2).ilog2() // 1
    /// I8(-3).ilog2() // 1
    /// I8(-4).ilog2() // 2
    /// ```
    ///
    /// - Note: You may use `Nonzero<T>` for nonoptional results.
    ///
    /// - Note: Signed integers do not need to call `magnitude()`.
    ///
    @inlinable public borrowing func ilog2() -> Count<IX> {
        if  self.value.isNegative {
            let size = UX(raw: Value.size)
            let dobc = UX(raw: self.value.descending(1 as Bit))
            let azbc = UX(raw: self.value.ascending (0 as Bit))
            return Count.init(raw: size.minus(dobc).decremented(azbc &+ dobc != size).unchecked())
            
        }   else {
            let mask = UX(raw: Value.size).minus(1).unchecked()
            let dzbc = UX(raw: self.value.descending(0 as Bit))
            return Count.init(raw: mask.minus(dzbc).unchecked())
        }
    }
}
