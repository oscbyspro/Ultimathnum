//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Fallible x Veto
//*============================================================================*

extension Fallible {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Generates an `error` indicator then combines it at the end of the `action`.
    @inlinable public static func sink(_ action: (inout Bool) throws -> Self) rethrows -> Self {
        var error = false
        let value = try action(&error)
        return (((value))).veto(error)
    }
    
    /// Generates an `error` indicator then combines it at the end of the `action`.
    @inlinable public static func sink(_ action: (inout Bool) throws -> Value) rethrows -> Self {
        var error = false
        let value = try action(&error)
        return Self(value,error:error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Sets the `error` indicator.
    @inlinable public consuming func veto() -> Self {
        Self(self.value, error: true)
    }
    
    /// Sets the `error` indicator when `condition` is `true`.
    @inlinable public consuming func veto(_ condition: Bool) -> Self {
        Self(self.value, error: Bool(Bit(self.error) | Bit(condition)))
    }
    
    /// Sets the `error` indicator if the `predicate` returns `true`.
    @inlinable public consuming func veto(_ predicate: (Value) -> Bool) -> Self {
        let condition = predicate(self.value)
        return self.veto(condition)
    }
}
