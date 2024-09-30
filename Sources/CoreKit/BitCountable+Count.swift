//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Countable x Count
//*============================================================================*

extension BitCountable {
    
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
    @inlinable public borrowing func entropy() -> Count {
        var result = IX(raw: self.nondescending(self.appendix))
        result = result.incremented().unchecked("BitCountable/entropy/0...IX.max")
        return Count(Natural(unchecked: result))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Inverses
    //=------------------------------------------------------------------------=
    
    /// The inverse ascending `bit` count in `self`.
    ///
    /// - Invariant: `count(x) + noncount(x) == size()`
    ///
    /// ### SystemsInteger
    ///
    /// ```swift
    /// I8(11).nonascending(0) // 8
    /// I8(11).nonascending(1) // 6
    /// I8(22).nonascending(0) // 7
    /// I8(22).nonascending(1) // 8
    /// ```
    ///
    /// ### ArbitraryInteger
    ///
    /// ```
    /// 11010000|0... // nonascending(0) == ∞
    /// 11010000|0... // nonascending(1) == ∞ - 2
    /// 11010000|1... // nonascending(0) == ∞
    /// 11010000|1... // nonascending(1) == ∞ - 2
    /// ```
    ///
    @inlinable public borrowing func nonascending(_ bit: Bit) -> Count {
        let size = IX(raw: self.size())
        let base = IX(raw: self.ascending(bit))
        let difference = size.minus(base).unchecked()
        return Count(raw: difference)
    }
    
    /// The inverse descending `bit` count in `self`.
    ///
    /// - Invariant: `count(x) + noncount(x) == size()`
    ///
    /// ### SystemsInteger
    ///
    /// ```swift
    /// I8(11).nondescending(0) // 4
    /// I8(11).nondescending(1) // 8
    /// I8(22).nondescending(0) // 5
    /// I8(22).nondescending(1) // 8
    /// ```
    ///
    /// ### ArbitraryInteger
    ///
    /// ```
    /// 11010000|0... // nondescending(0) == 4
    /// 11010000|0... // nondescending(1) == ∞
    /// 11010000|1... // nondescending(0) == ∞
    /// 11010000|1... // nondescending(1) == 8
    /// ```
    ///
    @inlinable public borrowing func nondescending(_ bit: Bit) -> Count {
        let size = IX(raw: self.size())
        let base = IX(raw: self.descending(bit))
        let difference = size.minus(base).unchecked()
        return Count(raw: difference)
    }
}
