//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Guarantee
//*============================================================================*

/// A *trusted input* type.
public protocol Guarantee<Value> {
    
    associatedtype Value
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// Indicates whether the given `value` can be trusted.
    @inlinable static func predicate(_ value: borrowing Value) -> Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance without validation in release mode.
    ///
    /// - Requires: `Self.predicate(value)` must be `true` to succeed.
    ///
    /// - Warning: Only use this method when you know the `value` is valid.
    ///
    @_disfavoredOverload // collection.map(Self.init)
    @inlinable init(unchecked value: consuming Value)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The value of this trusted input.
    @inlinable var value: Value { get }
}
