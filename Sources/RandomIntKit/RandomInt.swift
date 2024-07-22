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
@frozen public struct RandomInt: Randomness {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: SystemRandomNumberGenerator
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() {
        self.base = SystemRandomNumberGenerator()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func next() -> some SystemsInteger & UnsignedInteger {
        U64(self.base.next())
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Default
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Generates random bits through the given `index`.
    ///
    /// Signed integers are extended by the most significant bit wheras unsigned
    /// integer are extended by zero. You may bit cast a different type to adopt
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
    /// - Note: The default randomness is `RandomInt`.
    ///
    /// - Requires: The request must not exceed the entropy limit.
    ///
    @inlinable public static func random(through index: Shift<Magnitude>) -> Self {
        var randomness = RandomInt()
        return Self.random(through: index, using: &randomness)
    }
}
