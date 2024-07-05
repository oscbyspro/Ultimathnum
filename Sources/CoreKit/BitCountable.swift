//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Countable
//*============================================================================*

/// A countable bit pattern abstraction bounded by memory.
///
/// A countable bit pattern is represented by a `body` and an `appendix`. It may
/// contain up to `log2(UXL.max + 1)` bits (i.e. `Count.infinity`), but its `body`
/// and `appendix` must fit in `[0, IX.max]` bits. This means that you may count
/// finite and infinite bit patterns, as long as they are representable in memory.
///
/// - Requires: Its `body` and `appendix` must fit in `IX.max` bits.
///
public protocol BitCountable {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The bit that extends the abstract `body` of `self`
    ///
    /// ### BinaryInteger
    ///
    /// Its significance depends on signedness:
    ///
    /// ```
    ///            ┌───────────────┬───────────────┐
    ///            │ appendix == 0 │ appendix == 1 |
    /// ┌──────────┼───────────────┤───────────────┤
    /// │   Signed │     self >= 0 │     self <  0 │
    /// ├──────────┼───────────────┤───────────────┤
    /// │ Unsigned │     self <  ∞ │     self >= ∞ │
    /// └──────────┴───────────────┴───────────────┘
    /// ```
    ///
    @inlinable var appendix: Bit { borrowing get }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The number of bits in the abstract `body` of this type.
    ///
    /// ```
    /// ┌──────┬───────────────────┐
    /// │ type │ size              │
    /// ├──────┼───────────────────┤
    /// │ I64  │ 64                │
    /// │ IXL  │ log2(UXL.max + 1) │ == Count.infinity
    /// └──────┴───────────────────┘
    /// ```
    ///
    /// - Invariant: `count(x) + noncount(x) == size()`
    ///
    @inlinable func size() -> Count<IX>
    
    /// The `bit` count in `self`.
    ///
    /// - Invariant: `count(x) + noncount(x) == size()`
    ///
    /// ### SystemsInteger
    ///
    /// ```swift
    /// I8(11).count(0) // 5
    /// I8(11).count(1) // 3
    /// ```
    ///
    /// ### ArbitraryInteger
    ///
    /// ```
    /// 11010000|0... // count(0) == ∞ - 3
    /// 11010000|0... // count(1) == 3
    /// 11010000|1... // count(0) == 5
    /// 11010000|1... // count(1) == ∞ - 5
    /// ```
    ///
    @inlinable borrowing func count(_ bit: Bit) -> Count<IX>
    
    /// The ascending `bit` count in `self`.
    ///
    /// - Invariant: `count(x) + noncount(x) == size()`
    ///
    /// ### SystemsInteger
    ///
    /// ```swift
    /// I8(11).ascending(0) // 0
    /// I8(11).ascending(1) // 2
    /// I8(22).ascending(0) // 1
    /// I8(22).ascending(1) // 0
    /// ```
    ///
    /// ### ArbitraryInteger
    ///
    /// ```
    /// 11010000|0... // ascending(0) == 0
    /// 11010000|0... // ascending(1) == 2
    /// 11010000|1... // ascending(0) == 0
    /// 11010000|1... // ascending(1) == 2
    /// ```
    ///
    @inlinable borrowing func ascending(_ bit: Bit) -> Count<IX>
    
    /// The descending `bit` count in `self`.
    ///
    /// - Invariant: `count(x) + noncount(x) == size()`
    ///
    /// ### SystemsInteger
    ///
    /// ```swift
    /// I8(11).descending(0) // 4
    /// I8(11).descending(1) // 0
    /// I8(22).descending(0) // 3
    /// I8(22).descending(1) // 0
    /// ```
    ///
    /// ### ArbitraryInteger
    ///
    /// ```
    /// 11010000|0... // descending(0) == ∞ - 4
    /// 11010000|0... // descending(1) == 0
    /// 11010000|1... // descending(0) == 0
    /// 11010000|1... // descending(1) == ∞ - 8
    /// ```
    ///
    @inlinable borrowing func descending(_ bit: Bit) -> Count<IX>
}
