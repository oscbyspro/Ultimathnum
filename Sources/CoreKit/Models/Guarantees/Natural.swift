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

/// A finite, nonnegative, value.
///
/// ### Trusted Input
///
/// This is a trusted input type. Validate inputs with these methods:
///
/// ```
/// init(_:)         // error: traps
/// init(_:prune:)   // error: throws
/// init(exactly:)   // error: nil
/// init(unchecked:) // error: unchecked
/// ```
///
/// ### How to bit cast a `Natural<Value>`
///
/// You may always bit cast a signed natural value to its unsigned magnitude.
/// The most convenient way is by calling `magnitude()`. Please keep in mind,
/// however, that the inverse case is not as simple. `U8.max` is natural, for
/// example, but it becomes negative when reinterpreted as an `I8` value.
///
@frozen public struct Natural<Value>: Equatable where Value: BinaryInteger {
    
    public typealias Value = Value
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static func predicate(_ value: /* borrowing */ Value) -> Bool {
        !Bool(value.appendix) // await borrowing fix
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
    /// - Requires: `value.appendix == 0`
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
    /// - Requires: `value.appendix == 0`
    ///
    @inlinable public init(_ value: consuming Value) {
        self.init(exactly: value)!
    }
    
    /// Creates a new instance by returning `nil` on failure.
    ///
    /// - Requires: `value.appendix == 0`
    ///
    @inlinable public init?(exactly value: consuming Value) {
        guard Self.predicate(value) else { return nil }
        self.value = value
    }
    
    /// Creates a new instance by throwing the `error()` on failure.
    ///
    /// - Requires: `value.appendix == 0`
    ///
    @inlinable public init<Failure>(
        _ value: consuming Value,
        prune error: @autoclosure () -> Failure
    )   throws where Failure: Swift.Error {
        guard Self.predicate(value) else { throw error() }
        self.value = value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// The magnitude of this value.
    ///
    /// - Note: This is a bit cast because `self ∈ ℕ → unsigned`.
    ///
    @inlinable public consuming func magnitude() -> Natural<Value.Magnitude> {
        Natural<Value.Magnitude>(unchecked: Value.Magnitude(raw: self.value))
    }
}
