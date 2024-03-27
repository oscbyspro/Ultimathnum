//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Division
//*============================================================================*

@frozen public struct Division<Quotient, Remainder> {
    
    public typealias Quotient = Quotient
    
    public typealias Remainder = Remainder
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var quotient:  Quotient
    public var remainder: Remainder
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(quotient: Quotient, remainder: Remainder) {
        self.quotient  = quotient
        self.remainder = remainder
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var components: (quotient: Quotient, remainder: Remainder) {
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

extension Division: Equatable where Quotient: Equatable, Remainder: Equatable { }

//=----------------------------------------------------------------------------=
// MARK: + Bit Castable
//=----------------------------------------------------------------------------=

extension Division: BitCastable where Quotient: BitCastable, Remainder: BitCastable {
        
    //=------------------------------------------------------------------------=
    // MARK: Details x Bit Pattern
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming Division<Quotient.BitPattern, Remainder.BitPattern>) {
        self.init(
        quotient:  Quotient (bitPattern: bitPattern.quotient ),
        remainder: Remainder(bitPattern: bitPattern.remainder))
    }
    
    @inlinable public var bitPattern: Division<Quotient.BitPattern, Remainder.BitPattern> {
        consuming get {
            Division<  Quotient .BitPattern, Remainder.BitPattern>(
            quotient:  Quotient .BitPattern(bitPattern: self.quotient ),
            remainder: Remainder.BitPattern(bitPattern: self.remainder))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Integer
//=----------------------------------------------------------------------------=

extension Division where Quotient: BinaryInteger, Remainder: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Increments the `quotient` if the `remainder` is positive.
    @inlinable public consuming func ceil() throws -> Quotient {
        let instance: Self = consume self
        let increment: Quotient = instance.remainder > 0 ?  1 : 0
        return try (consume instance).quotient.plus(increment)
    }
    
    /// Decrements the `quotient` if the `remainder` is negative.
    @inlinable public consuming func floor() throws -> Quotient {
        let instance: Self = consume self
        let increment: Quotient = instance.remainder < 0 ? -1 : 0
        return try (consume instance).quotient.plus(increment)
    }
}
