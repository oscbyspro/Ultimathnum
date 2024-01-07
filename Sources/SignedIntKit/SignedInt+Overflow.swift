//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Signed Int x Overflow
//*============================================================================*

extension Overflow {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<Magnitude>(sign: consuming Sign, magnitude: consuming Overflow<Magnitude>) where Value == SignedInt<Magnitude> {
        self.init(Value(sign: sign, magnitude: magnitude.value), overflow: magnitude.overflow)
    }
}

