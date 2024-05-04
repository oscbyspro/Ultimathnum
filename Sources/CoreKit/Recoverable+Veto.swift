//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Recoverable x Veto
//*============================================================================*

extension Recoverable {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Sets the `error` indicator when `condition` is `true`.
    @inlinable public consuming func veto(_ condition: consuming Bool) -> Fallible<Self> {
        Fallible(self, error: condition)
    }
    
    /// Sets the `error` indicator if the `predicate` return `true`.
    @inlinable public consuming func veto(_ predicate: (Self) -> Bool) -> Fallible<Self> {
        let error = predicate(self)
        return self.veto(error)
    }
}
