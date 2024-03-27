//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Overflow
//*============================================================================*

@frozen public struct Overflow<Value>: Swift.Error {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var value: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() where Value == Void {
        
    }
    
    @inlinable public init(_ value: consuming Value) {
        self.value = value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func void(_ value: () throws -> Value) throws -> Value {
        attempt: do {
            return try value()
        }   catch {
            throw Overflow<Void>()
        }
    }
    
    @inlinable public static func ignore(_ value: () throws -> Value) -> Value {
        Result(value).value
    }
    
    @inlinable public static func ignore(_ value: inout Value, map: (consuming Value) throws -> Value) {
        value = Overflow.capture({ try map(value) }).value
    }
        
    @inlinable public static func capture(_ value: () throws -> Value) -> Result {
        Result(value)
    }
    
    @inlinable public static func capture(_ value: inout Value, map: (consuming Value) throws -> Value) -> Bool {
        let overflow: Bool
        (value, overflow) = Overflow.capture({ try map(value) }).components
        return (overflow)
    }
    
    @inlinable public static func resolve(_ value: consuming Value, overflow: consuming Bool) throws -> Value {
        if  overflow {
            throw  Overflow(value)
        }   else {
            return value
        }
    }
}
