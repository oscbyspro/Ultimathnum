//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Fallible x Combine
//*============================================================================*

extension Fallible {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Merges the current error and the new error in a branchless way.
    @inlinable public consuming func combine(_ error: Bool) -> Self {
        Self(self.value, error: Bool(Bit(self.error) | Bit(error)))
    }
}
