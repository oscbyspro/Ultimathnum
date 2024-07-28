//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Literal Int x Count
//*============================================================================*

extension LiteralInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The number of bits needed to *arbitrarily* represent `self`.
    ///
    ///     ┌──────┬──────────── → ────────┐
    ///     │ self │ bit pattern │ entropy │
    ///     ├──────┼──────────── → ────────┤
    ///     │   ~3 │ 00........1 │ 3       │
    ///     │   ~2 │ 10........1 │ 3       │
    ///     │   ~1 │ 0.........1 │ 2       │
    ///     │   ~0 │ ..........1 │ 1       │
    ///     │    0 │ ..........0 │ 1       │
    ///     │    1 │ 1.........0 │ 2       │
    ///     │    2 │ 01........0 │ 3       │
    ///     │    3 │ 11........0 │ 3       │
    ///     └──────┴──────────── → ────────┘
    ///
    /// - Note: An in-memory `entropy` must fit in `[0, IX.max]`.
    ///
    @inlinable public func entropy() -> Count<IX> {
        Count(unchecked: IX(self.base.bitWidth))
    }
}
