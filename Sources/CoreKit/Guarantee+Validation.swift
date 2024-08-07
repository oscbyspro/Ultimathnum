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
    /// - Requires: `Self.predicate(value)` must be `true` to succeed.
    ///
    @inlinable public init(_ value: consuming Value) {
        self.init(exactly: value)!
    }
    
    /// Creates a new instance by returning `nil` on failure.
    ///
    /// - Requires: `Self.predicate(value)` must be `true` to succeed.
    ///
    @inlinable public init?(exactly value: consuming Value) {
        guard Self.predicate(value) else { return nil }
        self.init(unchecked: value)
    }
    
    /// Creates a new instance by throwing the `error()` on failure.
    ///
    /// - Requires: `Self.predicate(value)` must be `true` to succeed.
    ///
    @inlinable public init<Failure>(
        _ value: consuming Value,
        prune error: @autoclosure () -> Failure
    )   throws where Failure: Swift.Error {
        guard Self.predicate(value) else { throw error() }
        self.init(unchecked: value)
    }
}
