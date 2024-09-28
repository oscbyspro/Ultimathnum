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
}
