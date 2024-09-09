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
/// msb ... max: [∞ - IX.max,  ∞] ≤ log2(UXL.max + 1)
/// ```
///
/// Its extends like a signed integer but compares like an unsigned integer
/// This mix produces a natural prefix and a relatively infinite suffix. It 
/// then increments the latter by one so the maximum value becomes power of
/// two. Think of it as an unsigned one's complement format.
///
/// - Note: Please roll a `D20` arcana check.
///
@frozen public struct Count<Layout>: BitCastable, Comparable, Recoverable, 
Sendable where Layout: SignedInteger & SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// A value equal to `0`.
    @inlinable public static var zero: Self {
        Self(raw: Layout(repeating: 0))
    }
    
    /// A value equal to `log2(UXL.max + 1)`
    @inlinable public static var infinity: Self {
        Self(raw: Layout(repeating: 1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: Layout
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: consuming Layout) {
        self.init(exactly: source)!
    }
    
    @inlinable public init?(exactly source: consuming Layout) {
        guard !source.isNegative else { return nil }
        self.init(unchecked: source)
    }
    
    @inlinable public init(unchecked source: consuming Layout) {
        Swift.assert(!source.isNegative)
        self.base = ((source))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: Layout.BitPattern) {
        self.base = Layout(raw: source)
    }
    
    @inlinable public func load(as type: Layout.BitPattern.Type) -> Layout.BitPattern {
        self.base.load(as: Layout.BitPattern.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns its raw `value` and an `error` indicator.
    ///
    ///     ┌───────────────────────┬───────────────┐
    ///     │ self                  │ value │ error │
    ///     ├───────────────────────┼───────┼───────┤
    ///     │ 0                     │  0    │ false │
    ///     │ 1                     │  1    │ false │
    ///     │ 2                     │  2    │ false │
    ///     ├───────────────────────┼───────┼───────┤
    ///     │ log2(UXL.max + 1) - 2 │ -3    │ true  │
    ///     │ log2(UXL.max + 1) - 1 │ -2    │ true  │
    ///     │ log2(UXL.max + 1)     │ -1    │ true  │
    ///     └───────────────────────┴───────┴───────┘
    ///
    /// - Note: The `error` is set if `self` is infinite.
    ///
    @inlinable public func natural() -> Fallible<Layout> {
        Fallible(self.base, error: self.isInfinite)
    }
}
