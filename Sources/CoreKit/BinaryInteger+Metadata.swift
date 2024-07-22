//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Metadata
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// Indicates whether this is an arbitrary integer type.
    ///
    ///                ┌───────────┬───────────┐
    ///                │  Systems  │ Arbitrary │
    ///     ┌──────────┼───────────┤───────────┤
    ///     │   Signed │           │     X     │
    ///     ├──────────┼───────────┤───────────┤
    ///     │ Unsigned │           │     X     │
    ///     └──────────┴───────────┴───────────┘
    ///
    @inlinable public static var isArbitrary: Bool {
        Self.size.isInfinite
    }
    
    /// Indicates whether this is an edgy integer type.
    ///
    ///                ┌───────────┬───────────┐
    ///                │  Systems  │ Arbitrary │
    ///     ┌──────────┼───────────┤───────────┤
    ///     │   Signed │     X     │           │
    ///     ├──────────┼───────────┤───────────┤
    ///     │ Unsigned │     X     │     X     │
    ///     └──────────┴───────────┴───────────┘
    ///
    @inlinable public static var isEdgy: Bool {
        !Self.isArbitrary || !Self.isSigned
    }
    
    /// Indicates whether this is a finite integer type.
    ///
    ///                ┌───────────┬───────────┐
    ///                │  Systems  │ Arbitrary │
    ///     ┌──────────┼───────────┤───────────┤
    ///     │   Signed │     X     │     X     │
    ///     ├──────────┼───────────┤───────────┤
    ///     │ Unsigned │     X     │           │
    ///     └──────────┴───────────┴───────────┘
    ///
    @inlinable public static var isFinite: Bool {
        !Self.isArbitrary || Self.isSigned
    }
    
    /// Indicates the role of the `appendix` bit.
    ///
    /// ```
    ///            ┌───────────────┬───────────────┐
    ///            │ appendix == 0 │ appendix == 1 │
    /// ┌──────────┼───────────────┤───────────────┤
    /// │   Signed │     self >= 0 │     self <  0 │
    /// ├──────────┼───────────────┤───────────────┤
    /// │ Unsigned │     self <  ∞ │     self >= ∞ │
    /// └──────────┴───────────────┴───────────────┘
    /// ```
    ///
    @inlinable public static var isSigned: Bool {
        Self.mode == .signed
    }
}

//*============================================================================*
// MARK: * Binary Integer x Metadata x Signed
//*============================================================================*

extension SignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static var mode: Signedness {
        Signedness.signed
    }
}

//*============================================================================*
// MARK: * Binary Integer x Metadata x Unsigned
//*============================================================================*

extension UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static var mode: Signedness {
        Signedness.unsigned
    }
}
