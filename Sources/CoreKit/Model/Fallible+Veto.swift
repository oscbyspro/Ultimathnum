//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Functional x Filter
//*============================================================================*

extension Fallible where Value: Functional {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Sets the `error` indicator if the `predicate` return `true`.
    @inlinable public consuming func veto(_ predicate: (Value) -> Bool) -> Self {
        self.value.veto(predicate).combine(self.error)
    }
}
