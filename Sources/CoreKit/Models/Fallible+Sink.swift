//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Fallible x Sink
//*============================================================================*

extension Fallible {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `value` by setting the `remote` indicator on `error`.
    ///
    /// ```swift
    /// var value = U8(3)
    /// var error = false // or Fallible<Void>()
    ///
    /// value = value.decremented().sink(&error) // value:   2, error: false
    /// value = value.decremented().sink(&error) // value:   1, error: false
    /// value = value.decremented().sink(&error) // value:   0, error: false
    /// value = value.decremented().sink(&error) // value: 255, error: true
    /// ```
    ///
    @inlinable public consuming func sink(_ remote: inout Bool) -> Value {
        remote = Fallible<Void>((),  error: remote).veto(self.error).error
        return self.value
    }
    
    /// Returns the `value` by setting the `remote` indicator on `error`.
    ///
    /// ```swift
    /// var value = U8(3)
    /// var error = false // or Fallible<Void>()
    ///
    /// value = value.decremented().sink(&error) // value:   2, error: false
    /// value = value.decremented().sink(&error) // value:   1, error: false
    /// value = value.decremented().sink(&error) // value:   0, error: false
    /// value = value.decremented().sink(&error) // value: 255, error: true
    /// ```
    ///
    @inlinable public consuming func sink(_ remote: inout Fallible<Void>) -> Value {
        self.sink(&remote.error)
    }
}
