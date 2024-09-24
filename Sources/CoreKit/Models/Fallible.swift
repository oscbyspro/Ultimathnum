//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Fallible
//*============================================================================*

/// A `value` and an `error` indicator.
@frozen public struct Fallible<Value>: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// A `value` that may or may not be valid.
    ///
    /// The `error` indicator tells you whether it has been invalidated. 
    /// Alternatively, you may use methods like `optional()`, `result()` 
    /// or `prune(_:)` to access it conditionally.
    ///
    /// - Note: An invalid value can still be useful, think of it like a stack trace.
    ///
    /// - Note: Overflowing binary integer arithmetic is especially well-behaved.
    ///
    public var value: Value
    
    /// An `error` indicator.
    ///
    /// It tells you whether the `value` has been invalidated. You may use
    /// methods like `veto(_:)` to merge additional `error` indicators.
    ///
    public var error: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    /// Creates a new instance from the given `value` and `error`.
    @inlinable public init(_ value: consuming Value, error: consuming Bool = false) {
        self.value = value
        self.error = error
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns its `value` and `error` as a tuple.
    @inlinable public consuming func components() -> (value: Value, error: Bool) {
        (value: self.value, error: self.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Tries to return its `value` but returns `nil` on `error`.
    @inlinable public consuming func optional() -> Optional<Value> {
        if  self.error {
            return Optional.none
        }   else {
            return Optional.some(self.value)
        }
    }
    
    /// Tries to return its `value` but throws `failure()` on `error`.
    @inlinable public consuming func prune<Error>(_ failure: @autoclosure () -> Error) throws -> Value where Error: Swift.Error {
        if  self.error {
            throw  failure()
        }   else {
            return self.value
        }
    }
    
    /// Tries to return its `value` but returns `failure()` on `error`.
    @inlinable public consuming func result<Error>(_ failure: @autoclosure () -> Error) -> Result<Value, Error> {
        if  self.error {
            return Result.failure(failure())
        }   else {
            return Result.success(self.value)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
        
    /// Consumes the `value` and `error` with no other effect.
    ///
    /// You should not mark operations that return `Fallible<Value>` results as
    /// discardable. Instead, you should always use the most appropriate recovery
    /// mechanism. The `error` indicator has feelings and it would get very sad
    /// if you were to forget about it.
    ///
    @inlinable public consuming func discard() {
        
    }
    
    /// Returns the `value` and traps on `error`.
    @discardableResult @inlinable public consuming func unwrap(
        _ message: @autoclosure () -> String = String(),
        file: StaticString = #file, line: UInt = #line
    )   -> Value {
        
        if  self.error {
            Swift.preconditionFailure(message(), file: file, line: line)
        }
        
        return self.value
    }
    
    /// Returns the `value` and traps on `error` in debug mode.
    @discardableResult @inlinable public consuming func unchecked(
        _ message: @autoclosure () -> String = String(),
        file: StaticString = #file, line: UInt = #line
    ) -> Value {
        
        if  self.error {
            Swift.assertionFailure(message(), file: file, line: line)
        }
         
        return self.value
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Value is BitCastable
//=----------------------------------------------------------------------------=

extension Fallible: BitCastable where Value: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming Fallible<Value.BitPattern>) {
        self.init(Value(raw: source.value), error: source.error)
    }
    
    @inlinable public consuming func load(as type: BitPattern.Type) -> BitPattern {
        Fallible<Value.BitPattern>(Value.BitPattern(raw: self.value), error: self.error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Value is Sendable
//=----------------------------------------------------------------------------=

extension Fallible: Sendable where Value: Sendable { }
