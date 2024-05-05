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
public protocol SystemsInteger<BitPattern>: EdgyInteger where Magnitude: SystemsInteger, Signitude: SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// This cannot be an extension because Swift does not expose unchecked shifts,
    /// which means that you cannot premask a `Shift<Self>` instance without cost.
    ///
    @inlinable static func &<<(instance: consuming Self, distance: borrowing Self) -> Self
    
    /// ### Development
    ///
    /// This cannot be an extension because Swift does not expose unchecked shifts,
    /// which means that you cannot premask a `Shift<Self>` instance without cost.
    ///
    @inlinable static func &>>(instance: consuming Self, distance: borrowing Self) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable borrowing func multiplication(_ multiplier: borrowing Self) -> Doublet<Self>
    
    @inlinable static func division(_ dividend: consuming Doublet<Self>, by divisor: borrowing Divisor<Self>) -> Fallible<Division<Self, Self>>
}
