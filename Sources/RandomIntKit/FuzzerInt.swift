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
// MARK: * Fuzzer Int
//*============================================================================*

/// A deterministic source of random data.
///
/// ### Algorithm
///
/// It adapts `SplitMix64` because it's simple and light-weight.
///
/// - Important: It may use a different algorithm in the future.
///
@frozen public struct FuzzerInt: Equatable, Randomness, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var state: U64
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(seed: U64) {
        self.state = (seed)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - TODO: Consider `ElementalInteger` to make it opaque again (`#123`).
    ///
    @inlinable public mutating func next() -> U64 {
        self.state &+= 0x9e3779b97f4a7c15
        var next = ((((((self.state))))))
        next = (next ^ (next &>> 30)) &* 0xbf58476d1ce4e5b9
        next = (next ^ (next &>> 27)) &* 0x94d049bb133111eb
        return (next ^ (next &>> 31))
    }
}
