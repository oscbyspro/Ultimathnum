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
    
    //*========================================================================*
    // MARK: * Result
    //*========================================================================*
    
    @frozen public struct Result {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=

        public var value: Value
        public var overflow: Bool
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=

        @inlinable public init(_ value: consuming Value, overflow: consuming Bool) {
            self.value = value; self.overflow = overflow
        }
        
        @inlinable public init(_ value: () throws -> Value) {
            brr: do {
                self.init(try value(), overflow: false)
            }   catch let error as Overflow<Value> {
                self.init((consume error).value, overflow: true)
            }   catch {
                fatalError("await typed throws")
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=

        @inlinable public var components: (value: Value, overflow: Bool) {
            consuming get {
                (value: self.value, overflow: self.overflow)
            }
            
            consuming set {
                (value: self.value, overflow: self.overflow) = newValue
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public consuming func resolve() throws -> Value {
            try Overflow.resolve(self.value, overflow: self.overflow)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Bit Castable
//=----------------------------------------------------------------------------=

extension Overflow: BitCastable where Value: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bit Pattern
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming Overflow<Value.BitPattern>) {
        self.init(Value(bitPattern: bitPattern.value))
    }
    
    @inlinable public var bitPattern: Overflow<Value.BitPattern> {
        consuming get {
            .init(Value.BitPattern(bitPattern: self.value))
        }
    }
}

extension Overflow.Result: BitCastable where Value: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bit Pattern
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming Overflow<Value.BitPattern>.Result) {
        self.init(Value(bitPattern: bitPattern.value), overflow: bitPattern.overflow)
    }
    
    @inlinable public var bitPattern: Overflow<Value.BitPattern>.Result {
        consuming get {
            .init(Value.BitPattern(bitPattern: self.value), overflow: self.overflow)
        }
    }
}
