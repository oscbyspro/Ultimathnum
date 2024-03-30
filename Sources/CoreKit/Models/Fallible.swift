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
    
    @inlinable public static func success(_ value: consuming Value) -> Self {
        Self(value, error: false)
    }
    
    @inlinable public static func failure(_ value: consuming Value) -> Self {
        Self(value, error: true )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable public var components: (value: Value, error: Bool) {
        consuming get {
            (value: self.value, error: self.error)
        }
        
        mutating set {
            (value: self.value, error: self.error) = newValue
        }
    }
    
    /// Merges the current error and the new error in a branchless way.
    @inlinable public consuming func combine(_ error: Bool) -> Self {
        let a  = Swift.unsafeBitCast(self.error, to: UInt8.self)
        let b  = Swift.unsafeBitCast(/*-*/error, to: UInt8.self)
        return Self(self.value, error: Swift.unsafeBitCast(a | b, to: Bool.self))
    }
    
    @inlinable public consuming func map<T>(_ map: (Value) -> T) -> Fallible<T> {
        Fallible<T>(map(self.value), error: self.error)
    }
    
    @inlinable public consuming func map<T>(_ map: (Value) -> Fallible<T>) -> Fallible<T> {
        map(self.value).combine(self.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func get() throws -> Value {
        if  self.error {
            throw  Overflow()
        }   else {
            return self.value
        }
    }
    
    @inlinable public consuming func result() -> Result<Value, Overflow> {
        if  self.error {
            return Result.failure(Overflow())
        }   else {
            return Result.success(self.value)
        }
    }
    
    @inlinable public consuming func optional() -> Optional<Value> {
        if  self.error {
            return Optional.none
        }   else {
            return Optional.some(self.value)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func unwrap(file: StaticString = #file, line: UInt = #line) -> Value {
        if  self.error {
            Swift.preconditionFailure(file: file, line: line)
        }
        
        return self.value
    }
    
    @inlinable public consuming func assert(file: StaticString = #file, line: UInt = #line) -> Value {
        if  self.error {
            Swift.assertionFailure(file: file, line: line)
        }
         
        return self.value
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Equatable
//=----------------------------------------------------------------------------=

extension Fallible: Equatable where Value: Equatable { }
