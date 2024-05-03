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
/// This is a Trusted Input™ type. It is not allowed to pass through the standard
/// `Fallible<Value>` propagation mechanism. Instead, create valid instances with
/// initializers such as:
///
/// ```
/// init(_:)         // error: traps
/// init(_:prune:)   // error: throws
/// init(exactly:)   // error: nil
/// init(unchecked:) // error: unsafe (with debug assertions)
/// ```
///
@frozen public struct Divisor<Value>: Functional where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
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
    
    /// Creates a new instance and traps on failure in debug mode only.
    ///
    /// - Warning: Use this method only when you are 100% sure the input is valid.
    ///
    @_disfavoredOverload // elements.map(Divisor.init)
    @inlinable public init(unchecked value: consuming Value) {
        Swift.assert(Self.predicate(value), String.brokenInvariant())
        self.value = value
    }
    
    /// Creates a new instance and traps on failure.
    @inlinable public init(_ value: consuming Value) {
        self.init(exactly: value)!
    }
    
    @inlinable public init?(exactly value: consuming Value) {
        guard Self.predicate(value) else { return nil }
        self.value = value
    }
    
    @inlinable public init<Failure>(_ value: consuming Value, prune error: @autoclosure () -> Failure) throws where Failure: Error {
        guard Self.predicate(value) else { throw error() }
        self.value = value
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
