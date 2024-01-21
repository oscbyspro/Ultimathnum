//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Division
//*============================================================================*

@frozen public struct Division<Value> {
    
    public typealias Value = Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var quotient:  Value
    public var remainder: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(quotient: Value, remainder: Value) {
        self.quotient  = quotient
        self.remainder = remainder
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var components: (quotient: Value, remainder: Value) {
        consuming get {
            (quotient: self.quotient, remainder: self.remainder)
        }
        
        consuming set {
            (quotient: self.quotient, remainder: self.remainder) = newValue
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Equatable
//=----------------------------------------------------------------------------=

extension Division: Equatable where Value: Equatable { }

//=----------------------------------------------------------------------------=
// MARK: + Bit Castable
//=----------------------------------------------------------------------------=

extension Division: BitCastable where Value: BitCastable {
        
    //=------------------------------------------------------------------------=
    // MARK: Details x Bit Pattern
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming Division<Value.BitPattern>) {
        self.init(
        quotient:  Value(bitPattern: bitPattern.quotient ),
        remainder: Value(bitPattern: bitPattern.remainder))
    }
    
    @inlinable public var bitPattern: Division<Value.BitPattern> {
        consuming get {
            Division<  Value.BitPattern>(
            quotient:  Value.BitPattern(bitPattern: self.quotient ),
            remainder: Value.BitPattern(bitPattern: self.remainder))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Integer
//=----------------------------------------------------------------------------=

extension Division where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Increments the `quotient` if the `remainder` is positive.
    @inlinable public consuming func ceil() throws -> Value {
        let instance: Self = consume self
        let increment: Value = instance.remainder > 0 ?  1 : 0
        return try (consume instance).quotient.plus(increment)
    }
    
    /// Decrements the `quotient` if the `remainder` is negative.
    @inlinable public consuming func floor() throws -> Value {
        let instance: Self = consume self
        let increment: Value = instance.remainder < 0 ? -1 : 0
        return try (consume instance).quotient.plus(increment)
    }
}
