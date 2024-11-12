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
// MARK: * Indexacci x Stride
//*============================================================================*

extension Indexacci {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the sequence pair at `index + 1`.
    ///
    /// ### Development
    ///
    /// - Todo: Measure versus `components()` approach.
    ///
    @inlinable public consuming func incremented() -> Fallible<Self> {
        var  error = false
        self.tuple = self.tuple.incremented().sink(&error)
        self.index = self.index.incremented().sink(&error)
        return self.veto(error)
    }
    
    /// Returns the sequence pair at `index - 1`.
    ///
    /// ### Development
    ///
    /// - Todo: Measure versus `components()` approach.
    ///
    @inlinable public consuming func decremented() -> Fallible<Self> {
        var  error = false
        self.tuple = self.tuple.decremented().sink(&error)
        self.index = self.index.decremented().sink(&error)
        return self.veto(error)
    }
}
