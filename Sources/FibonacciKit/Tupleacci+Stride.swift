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
// MARK: * Tupleacci x Stride
//*============================================================================*

extension Tupleacci {
    
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
        let  major = major
        self.major = minor.plus(major).sink(&error)
        self.minor = major
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
        let  minor = minor
        self.minor = major.minus(minor).sink(&error)
        self.major = minor
        return self.veto(error)
    }
}
