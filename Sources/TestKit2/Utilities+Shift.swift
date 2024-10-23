//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit

//*============================================================================*
// MARK: * Utilities x Shift
//*============================================================================*

extension Shift {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Returns `max` for systems integers but returns `arbitrary` otherwise.
    @inlinable public static func max(or arbitrary: IX) -> Self {
        if !Target.isArbitrary {
            return Self.max
        }   else {
            return Self(Count(arbitrary))
        }
    }
    
    @inlinable public static func random(using randomness: inout some Randomness) -> Self where Target: SystemsInteger {
        Self.random(through: Self.max, using: &randomness)
    }
    
    @inlinable public static func random(through limit: Self, using randomness: inout some Randomness) -> Self {
        Shift(Count(IX.random(in: IX.zero...limit.natural().unwrap(), using: &randomness)))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Systems
//=----------------------------------------------------------------------------=

extension Shift where Target: SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static var all: some Sequence<Self> {
        let range = IX.zero..<IX(size: Target.self)
        return range.lazy.map {
            Self(unchecked: Count(Natural(unchecked: $0)))
        }
    }
    
}
