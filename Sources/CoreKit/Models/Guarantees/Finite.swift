//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Natural
//*============================================================================*

/// A finite value.
///
/// ### Trusted Input
///
/// This is a trusted input type. Validate inputs with these methods:
///
/// ```swift
/// init(_:)         // error: traps
/// init(_:prune:)   // error: throws
/// init(exactly:)   // error: nil
/// init(unchecked:) // error: unchecked
/// ```
///
@frozen public struct Finite<Value>: Equatable where Value: BinaryInteger {
    
    public typealias Value = Value
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// Indicates whether the given `value` can be trusted.
    ///
    /// - Returns: `value ∈ ℤ`
    ///
    @inlinable public static func predicate(_ value: /* borrowing */ Value) -> Bool {
        !value.isInfinite // await borrowing fix
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let value: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance without validation in release mode.
    ///
    /// - Requires: `value ∈ ℤ`
    ///
    /// - Warning: Only use this method when you know the `value` is valid.
    ///
    @_disfavoredOverload // collection.map(Self.init)
    @inlinable public init(unchecked value: consuming Value) {
        Swift.assert(Self.predicate(value), String.brokenInvariant())
        self.value = value
    }
    
    /// Creates a new instance by trapping on failure.
    ///
    /// - Requires: `value ∈ ℤ`
    ///
    @inlinable public init(_ value: consuming Value) {
        precondition(Self.predicate(value), String.brokenInvariant())
        self.value = value
    }
    
    /// Creates a new instance by returning `nil` on failure.
    ///
    /// - Requires: `value ∈ ℤ`
    ///
    @inlinable public init?(exactly value: consuming Value) {
        guard Self.predicate(value) else { return nil }
        self.value = value
    }
    
    /// Creates a new instance by throwing the `error()` on failure.
    ///
    /// - Requires: `value ∈ ℤ`
    ///
    @inlinable public init<Error>(_ value: consuming Value, prune error: @autoclosure () -> Error) throws where Error: Swift.Error {
        guard Self.predicate(value) else { throw error() }
        self.value = value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// The `magnitude` of `self`.
    @inlinable public consuming func magnitude() -> Finite<Value.Magnitude> {
        Finite<Value.Magnitude>(unchecked: self.value.magnitude())
    }
}
