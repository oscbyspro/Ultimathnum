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

/// A wrapped `value` and an `error` indicator.
@frozen public struct Fallible<Value> {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    public var value: Value
    public var error: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable public init(_ value: consuming Value, error: consuming Bool = false) {
        self.value = value
        self.error = error
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func components() -> (value: Value, error: Bool) {
        (value: self.value, error: self.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the current `value`, or `nil` if the `error` indicator is set.
    ///
    /// ```swift
    /// if  let index = unsigned.minus(1).optional() {
    ///     assert(unsigned >= 1)
    /// }   else {
    ///     assert(unsigned == 0)
    /// }
    /// ```
    ///
    @inlinable public consuming func optional() -> Optional<Value> {
        if  self.error {
            return Optional.none
        }   else {
            return Optional.some(self.value)
        }
    }
    
    /// Returns the current `value`, or throws `failure` if the `error` indicator is set.
    ///
    /// ```swift
    /// always: do {
    ///     try IX.max.plus(1).prune(Oops())
    /// }   catch let error {
    ///     // recover from failure and save the day
    /// }
    /// ```
    ///
    @inlinable public consuming func prune<Failure>(_ failure: @autoclosure () -> Failure) throws -> Value where Failure: Error {
        if  self.error {
            throw  failure()
        }   else {
            return self.value
        }
    }
    
    /// Returns the current `value`, or `failure` if the `error` indicator is set.
    ///
    /// ```swift
    /// switch IX.max.plus(1).prune(Oops()) {
    /// case Result<IX, Oops>.success(value): // ...
    /// case Result<IX, Oops>.failure(error): // ...
    /// }
    ///
    /// ```
    ///
    @inlinable public consuming func result<Failure>(_ failure: @autoclosure () -> Failure) -> Result<Value, Failure> {
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
