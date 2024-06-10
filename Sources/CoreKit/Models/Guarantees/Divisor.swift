//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Divisor
//*============================================================================*

/// A nonzero value.
///
/// ### Trusted Input
///
/// This is a trusted input type. Validate inputs with these methods:
///
/// ```
/// init(_:)         // error: traps
/// init(_:prune:)   // error: throws
/// init(exactly:)   // error: nil
/// init(unchecked:) // error: unsafe (with debug assertions)
/// ```
///
@frozen public struct Divisor<Value>: BitCastable where Value: BinaryInteger {
    
    public typealias Value = Value
    
    public typealias BitPattern = Divisor<Value.Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static func predicate(_ value: borrowing Value) -> Bool {
        value != Value.zero
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let value: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance without precondition checks.
    ///
    /// - Requires: `value != 0`
    ///
    /// - Warning: Use this method only when you are 100% sure the input is valid.
    ///
    @_disfavoredOverload // enables: elements.map(Self.init)
    @inlinable public init(unchecked value: consuming Value) {
        Swift.assert(Self.predicate(value), String.brokenInvariant())
        self.value = value
    }
    
    /// Creates a new instance by trapping on failure.
    ///
    /// - Requires: `value != 0`
    ///
    @inlinable public init(_ value: consuming Value) {
        self.init(exactly: value)!
    }
    
    /// Creates a new instance by returning `nil` on failure.
    ///
    /// - Requires: `value != 0`
    ///
    @inlinable public init?(exactly value: consuming Value) {
        guard Self.predicate(value) else { return nil }
        self.value = value
    }
    
    /// Creates a new instance by throwing the `error()` on failure.
    ///
    /// - Requires: `value != 0`
    ///
    @inlinable public init<Failure>(
        _ value: consuming Value, 
        prune error: @autoclosure () -> Failure
    )   throws where Failure: Swift.Error {
        guard Self.predicate(value) else { throw error() }
        self.value = value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming BitPattern) {
        self.init(unchecked: Value(raw: source.value))
    }
    
    @inlinable public consuming func load(as type: BitPattern.Type) -> BitPattern {
        BitPattern(unchecked: Value.Magnitude(raw: self.value))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func complement() -> Divisor<Value> {
        Self(unchecked: self.value.complement())
    }
    
    @inlinable public consuming func magnitude() -> Divisor<Value.Magnitude> {
        Divisor<Value.Magnitude>(unchecked: self.value.magnitude())
    }
}
