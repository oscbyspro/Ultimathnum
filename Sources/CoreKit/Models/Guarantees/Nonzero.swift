//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Nonzero
//*============================================================================*

/// A nonzero value.
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
@frozen public struct Nonzero<Value>: BitCastable, Equatable where Value: BinaryInteger {
    
    public typealias Value = Value
    
    public typealias BitPattern = Nonzero<Value.Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// Indicates whether the given `value` can be trusted.
    ///
    /// - Returns: `value ≠ 0`
    ///
    @inlinable public static func predicate(_ value: /* borrowing */ Value) -> Bool {
        !value.isZero // await borrowing fix
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
    /// - Requires: `value ≠ 0`
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
    /// - Requires: `value ≠ 0`
    ///
    @inlinable public init(_ value: consuming Value) {
        precondition(Self.predicate(value), String.brokenInvariant())
        self.value = value
    }
    
    /// Creates a new instance by returning `nil` on failure.
    ///
    /// - Requires: `value ≠ 0`
    ///
    @inlinable public init?(exactly value: consuming Value) {
        guard Self.predicate(value) else { return nil }
        self.value = value
    }
    
    /// Creates a new instance by throwing the `error()` on failure.
    ///
    /// - Requires: `value ≠ 0`
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
    
    /// The `complement` of `self`.
    @inlinable public consuming func complement() -> Nonzero<Value> {
        Self(unchecked: self.value.complement())
    }
    
    /// The `magnitude` of `self`.
    @inlinable public consuming func magnitude() -> Nonzero<Value.Magnitude> {
        Nonzero<Value.Magnitude>(unchecked: self.value.magnitude())
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conveniences
//=----------------------------------------------------------------------------=

extension Nonzero where Value: SystemsInteger<UX.BitPattern> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance equal to `T.size`.
    ///
    /// - Note: A systems integer's size is never zero.
    ///
    @inlinable public init<T>(size source: T.Type) where T: SystemsInteger {
        self.init(unchecked: Value.init(size: T.self))
    }
}
