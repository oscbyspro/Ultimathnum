//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Random Int
//*============================================================================*

/// The system’s default source of random data.
///
/// ### Algorithm
///
/// It uses Swift's `SystemRandomNumberGenerator`.
///
@frozen public struct RandomInt: Interoperable, Randomness, Sendable {
    
    public typealias Stdlib = Swift.SystemRandomNumberGenerator
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Stdlib
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() {
        self.base = Stdlib()
    }
    
    @inlinable public init(_ source: consuming Stdlib) {
        self.base = source
    }
    
    @inlinable public consuming func stdlib() -> Stdlib {
        self.base
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func next() -> some SystemsInteger & UnsignedInteger {
        U64(self.base.next())
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Binary Integer
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Generates a random value in the given `range`.
    ///
    /// - Requires: The `range` must be finite.
    ///
    @inlinable public static func random(in range: ClosedRange<Self>) -> Self {
        var randomness = RandomInt()
        return Self.random(in: range, using: &randomness)
    }
    
    /// Generates a random value in the given `range`.
    ///
    /// - Requires: The `range` must be finite.
    ///
    @inlinable public static func random(in range: Range<Self>) -> Optional<Self> {
        var randomness = RandomInt()
        return Self.random(in: range, using: &randomness)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Generates random bits through the given `index`.
    ///
    /// Signed integers are extended by the most significant bit whereas unsigned
    /// integers are extended by zero. You may bit-cast a different type to adopt
    /// its behavior.
    ///
    ///                ┌──────────┬──────────┬──────────┐
    ///                │ index: 0 │ index: 1 │ index: 2 │
    ///     ┌──────────┼──────────┤──────────┤──────────┤
    ///     │   Signed │ -1 ... 0 │ -2 ... 1 │ -4 ... 3 │
    ///     ├──────────┼──────────┤──────────┤──────────┤
    ///     │ Unsigned │  0 ... 1 │  0 ... 3 │  0 ... 7 │
    ///     └──────────┴──────────┴──────────┴──────────┘
    ///
    /// - Note: The result is always finite.
    ///
    /// - Requires: The request must not exceed the entropy limit.
    ///
    @inlinable public static func random(through index: Shift<Magnitude>) -> Self {
        var randomness = RandomInt()
        return Self.random(through: index, using: &randomness)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Systems Integer
//=----------------------------------------------------------------------------=

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Generates a random value.
    @inlinable public static func random() -> Self {
        var randomness = RandomInt()
        return Self.random(using: &randomness)
    }
}
