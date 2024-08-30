//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Guarantee x Validation
//*============================================================================*

extension Guarantee {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance by trapping on failure.
    ///
    /// - Requires: The given `value` must satisfy the `predicate` of this type.
    ///
    @inlinable public init(_ value: consuming Value) {
        precondition(Self.predicate(value), String.brokenInvariant())
        self.init(unsafe:/**/value)
    }
    
    /// Creates a new instance by trapping on failure in debug mode.
    ///
    /// - Requires: The given `value` must satisfy the `predicate` of this type.
    ///
    @inlinable public init(unchecked value: consuming Value) {
        Swift.assert(Self.predicate(value), String.brokenInvariant())
        self.init(unsafe:/**/value)
    }
    
    /// Creates a new instance by returning `nil` on failure.
    ///
    /// - Requires: The given `value` must satisfy the `predicate` of this type.
    ///
    @inlinable public init?(exactly value: consuming Value) {
        guard Self.predicate(value) else { return nil }
        self.init(unsafe:/**/value)
    }
    
    /// Creates a new instance by throwing the `error()` on failure.
    ///
    /// - Requires: The given `value` must satisfy the `predicate` of this type.
    ///
    @inlinable public init<Error>(_ value: consuming Value, prune error: @autoclosure () -> Error) throws where Error: Swift.Error {
        guard Self.predicate(value) else { throw error() }
        self.init(unsafe:/**/value)
    }
}
