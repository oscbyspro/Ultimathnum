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
// MARK: * Utilities x Randomness
//*============================================================================*

extension FuzzerInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func random() -> Self {
        var randomness = RandomInt()
        return Self.random(using: &randomness)
    }
    
    @inlinable public static func random(using randomness: inout some Randomness) -> Self {
        Self(seed: randomness.next())
    }
}
