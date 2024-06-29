//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Systems
//*============================================================================*

/// A binary systems integer.
///
/// ### Size
///
/// Keep it simple.
///
/// - Requires: Its bit width must be at least 8.
///
/// - Requires: Its bit width must be a power of 2.
///
/// - Requires: Its bit width must fit in `IX`.
///
/// ### Trivial
///
/// Its bit pattern must represent its value. It may not use indirection.
///
/// - Requires: It must be bitwise copyable.
///
public protocol SystemsInteger<BitPattern>: EdgyInteger, FiniteInteger where Magnitude: SystemsInteger, Signitude: SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the byte swapped version of `self`.
    @inlinable consuming func reversed(_ type: U8.Type) -> Self
    
    /// Returns the `low` and `high` product of `self` times `multiplier`.
    @inlinable borrowing func multiplication(_ multiplier: borrowing Self) -> Doublet<Self>
    
    /// Returns the result of dividing the `dividend` by the `divisor`.
    @inlinable static func division(_ dividend: consuming Doublet<Self>, by divisor: borrowing Divisor<Self>) -> Fallible<Division<Self, Self>>
}
