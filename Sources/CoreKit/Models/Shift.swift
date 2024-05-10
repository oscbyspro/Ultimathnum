//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Shift
//*============================================================================*

/// A finite value from zero to the wrapped type's bit width.
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
@frozen public struct Shift<Value>: BitCastable where Value: BinaryInteger {
    
    public typealias Value = Value
    
    public typealias BitPattern = Shift<Value.Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static func predicate(_ value: Value) -> Bool {
        !Bool(value.appendix) && Value.Magnitude(raw: value) < Value.size
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
    @_disfavoredOverload // enables: elements.map(Self.init)
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
    // MARK: Initializes
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming BitPattern) {
        self.init(unchecked: Value(raw: source.value))
    }
    
    @inlinable public func load(as type: BitPattern.Type) -> BitPattern {
        BitPattern(unchecked: Value.Magnitude(raw: self.value))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func nondistance() -> Self where Value: SystemsInteger {
        Self(unchecked: Value(raw: Value.size).minus(self.value).assert())
    }
}
