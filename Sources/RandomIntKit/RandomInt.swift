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
