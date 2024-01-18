//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Int x Division x Signed
//*============================================================================*

extension BitInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(divisor: borrowing Self) throws -> Self {
        try Overflow.resolve(self, overflow: self <= divisor)
    }
    
    @inlinable public consuming func remainder(divisor: borrowing Self) throws -> Self {
        try Overflow.resolve(Self(bitPattern: Bit(self < divisor)), overflow: self <= divisor)
    }
    
    @inlinable public consuming func divided(by divisor: borrowing Self) throws -> Division<Self> {
        try Overflow.resolve(Division(quotient: copy self, remainder: Self(bitPattern: Bit(self < divisor))), overflow: self <= divisor)
    }
    
    @inlinable public static func dividing(_ dividend: consuming Doublet<Self>, by divisor: borrowing Self) throws -> Division<Self> {
        let quotient  = Self(bitPattern: dividend.low)
        let remainder = Self(bitPattern: dividend.low) &  ~(copy divisor)
        let overflow  = divisor == 0 || (dividend.low) == 0 && dividend.high == -1
        return try Overflow.resolve(Division(quotient: quotient, remainder: remainder), overflow: overflow)
    }
}

//*============================================================================*
// MARK: * Bit Int x Division x Unsigned
//*============================================================================*

extension BitInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient (divisor: borrowing Self) throws -> Self {
        try Overflow.resolve(self, overflow: divisor == 0)
    }
    
    @inlinable public consuming func remainder(divisor: borrowing Self) throws -> Self {
        try Overflow.resolve(Self(bitPattern: Bit(self > divisor)), overflow: divisor == 0)
    }
    
    @inlinable public consuming func divided(by divisor: borrowing Self) throws -> Division<Self> {
        try Overflow.resolve(Division(quotient: self, remainder: Self(bitPattern: Bit(self > divisor))), overflow: divisor == 0)
    }
    
    @inlinable public static func dividing(_ dividend: consuming Doublet<Self>, by divisor: borrowing Self) throws -> Division<Self> {
        let quotient  = Self(bitPattern: dividend.low)
        let remainder = Self(bitPattern: dividend.low) &  ~(copy divisor)
        let overflow  = divisor == 0 ||  dividend.high == 1
        return try Overflow.resolve(Division(quotient: quotient, remainder: remainder), overflow: overflow)
    }
}
