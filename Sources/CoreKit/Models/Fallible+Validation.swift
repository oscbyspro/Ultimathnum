//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Fallible x Validation
//*============================================================================*

extension Fallible {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Sets the `error` indicator when `condition` is `true`.
    @inlinable public consuming func invalidated(_ condition: Bool) -> Self {
        Self(self.value, error: Bool(Bit(self.error) | Bit(condition)))
    }
    
    /// Sets the `error` indicator if the `predicate` return `true`.
    @inlinable public consuming func invalidated(_ predicate: (Value) -> Bool) -> Self {
        let condition = predicate(self.value)
        return self.invalidated(condition)
    }
}
