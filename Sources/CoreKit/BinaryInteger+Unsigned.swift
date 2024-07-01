//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Unsigned
//*============================================================================*

/// An unsigned binary integer.
///
/// An unsigned binary integer represents a nonnegative value. The appendix bit of
/// an unsigned binary integer indicates whether it is finite (`0`) or infinite (`1`).
///
///
///                ┌───────────┬───────────┐
///                │  Systems  │ Arbitrary |
///     ┌──────────┼───────────┤───────────┤
///     │   Signed │           │           │
///     ├──────────┼───────────┤───────────┤
///     │ Unsigned │     X     │     X     │
///     └──────────┴───────────┴───────────┘
///
///
public protocol UnsignedInteger: EdgyInteger where Element: UnsignedInteger, Magnitude == Self { }

//*============================================================================*
// MARK: * Binary Integer x Unsigned
//*============================================================================*

extension UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static var mode: Signedness {
        Signedness.unsigned
    }
}
