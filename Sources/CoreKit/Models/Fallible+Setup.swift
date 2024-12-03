//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Fallible x Setup
//*============================================================================*

extension Fallible {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    /// Creates a new instance by combining the mutable `value` and `error`
    /// indicator passed to the `setup` function by consuming them when the
    /// the `setup` function returns.
    ///
    /// ```swift
    /// let x = Fallible(U8.zero) { value, error in
    ///     value = value.decremented().sink(&error)
    /// }   // value: 255, error: true
    /// ```
    ///
    /// - Note: The default `error` indicator is `false`.
    ///
    @inlinable public init<Error>(
        _
        value: consuming Value,
        error: consuming Bool = false,
        setup: (inout Value, inout Bool) throws(Error) -> Void
    )   throws(Error) {
        
        try setup(&value, &error)
        self.init((value), error: error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Error
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance by combining the mutable `error` indicator passed
    /// to the `setup` function and the `value` that the `setup` function returns.
    ///
    /// ```swift
    /// let x = Fallible.error { error in
    ///     U8.zero.decremented().sink(&error)
    /// }   // value: 255, error: true
    /// ```
    ///
    /// - Note: The default `error` indicator is `false`.
    ///
    @inlinable public static func error<Error>(
        _ setup: (inout Bool) throws(Error) -> Value
    )   throws(Error) -> Self {
        
        try Self.error(false, setup: setup)
    }
    
    /// Creates a new instance by combining the mutable `error` indicator passed
    /// to the `setup` function and the `value` that the `setup` function returns.
    ///
    /// ```swift
    /// let x = Fallible.error { error in
    ///     U8.zero.decremented().sink(&error)
    /// }   // value: 255, error: true
    /// ```
    ///
    /// - Note: The default `error` indicator is `false`.
    ///
    @inlinable public static func error<Error>(
        _ error: consuming Bool, setup: (inout Bool) throws(Error) -> Value
    )   throws(Error) -> Self {
        
        let value = try    setup(&error)
        return Self(value, error: error)
    }
}
