//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Count
//*============================================================================*

/// A binary integer bit count.
///
/// - Bit patterns in `min ..< msb` are natural.
/// - Bit patterns in `min ... max` are infinite.
///
/// ```
/// min ..< msb: [0,  IX.max + 0]
/// msb ... max: [∞ - IX.max,  ∞] ≤ log2(&0 + 1) = log2(UXL.max + 1)
/// ```
///
/// Its extends like a signed integer but compares like an unsigned integer
/// This mix produces a natural prefix and a relatively infinite suffix. It 
/// then increments the latter by one so the maximum value becomes power of
/// two. Think of it as an unsigned one's complement format.
///
/// - Note: Please roll a `D20` arcana check.
///
/// ### The upper bound is power of `2`
///
/// We define `Count.infinity` as a power of `2` becuase it makes our lives easier,
/// as long as we are consistend about it. This means that all binary integer sizes
/// are powers of two. We may also truncate negative values in `[-IX.min, -1]`.
///
/// - Seealso: `Count.exactly(_:)` and its `[-IX.min, IX.max]` semantics.
///
@frozen public struct Count: BitCastable, Comparable, CustomStringConvertible, Recoverable, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// A value equal to `0`.
    @inlinable public static var zero: Self {
        Self(raw: IX(repeating: Bit.zero))
    }
    
    /// A value equal to `log2(&0 + 1)`
    ///
    /// - Important: It is a power of `2`.
    ///
    @inlinable public static var infinity: Self {
        Self(raw: IX(repeating: Bit.one))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: IX
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    @inlinable public init(raw source: IX.BitPattern) {
        self.base = IX(raw: source)
    }
    
    @inlinable public func load(as type: IX.BitPattern.Type) -> IX.BitPattern {
        self.base.load(as: IX.BitPattern.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns its raw `value` and an `error` indicator.
    ///
    ///     ┌──────────────────┬───────────────┐
    ///     │ self             │ value │ error │
    ///     ├──────────────────┼───────┼───────┤
    ///     │ 0                │  0    │ false │
    ///     │ 1                │  1    │ false │
    ///     │ 2                │  2    │ false │
    ///     ├──────────────────┼───────┼───────┤
    ///     │ log2(&0 + 1) - 2 │ -3    │ true  │
    ///     │ log2(&0 + 1) - 1 │ -2    │ true  │
    ///     │ log2(&0 + 1)     │ -1    │ true  │
    ///     └──────────────────┴───────┴───────┘
    ///
    /// - Note: The `error` is set if `self` is infinite.
    ///
    @inlinable public func natural() -> Fallible<IX> {
        Fallible(self.base, error: self.isInfinite)
    }
}
