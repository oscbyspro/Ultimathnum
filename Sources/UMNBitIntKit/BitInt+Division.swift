//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import UMNCoreKit

//*============================================================================*
// MARK: * Bit Int x Division x Signed
//*============================================================================*

extension BitInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(divisor: borrowing Self) -> Overflow<Self> {
        Overflow(self, overflow: self <= divisor)
    }
    
    @inlinable public consuming func remainder(divisor: borrowing Self) -> Overflow<Self> {
        Overflow(Self(bitPattern: Bit(self < divisor)), overflow: divisor == 0)
    }
    
    @inlinable public consuming func divided(by divisor: borrowing Self) -> Overflow<Division<Self>> {
        Overflow(Division(quotient: copy self, remainder: Self(bitPattern: Bit(self < divisor))), overflow: self <= divisor)
    }
    
    @inlinable public static func dividing(_ dividend: consuming FullWidth<Self, Magnitude>, by divisor: borrowing Self) -> Overflow<Division<Self>> {
        let quotient  = Self(bitPattern: dividend.low)
        let remainder = Self(bitPattern: dividend.low) &  ~(copy divisor)
        let overflow  = divisor == 0 || (dividend.low) == 0 && dividend.high == -1
        return Overflow(Division(quotient: quotient, remainder: remainder), overflow: overflow)
    }
}

//*============================================================================*
// MARK: * Bit Int x Division x Unsigned
//*============================================================================*

extension BitInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient (divisor: borrowing Self) -> Overflow<Self> {
        Overflow(self, overflow: divisor == 0)
    }
    
    @inlinable public consuming func remainder(divisor: borrowing Self) -> Overflow<Self> {
        Overflow(Self(bitPattern: Bit(self > divisor)), overflow: divisor == 0)
    }
    
    @inlinable public consuming func divided(by divisor: borrowing Self) -> Overflow<Division<Self>> {
        Overflow(Division(quotient: self, remainder: Self(bitPattern: Bit(self > divisor))), overflow: divisor == 0)
    }
    
    @inlinable public static func dividing(_ dividend: consuming FullWidth<Self, Magnitude>, by divisor: borrowing Self) -> Overflow<Division<Self>> {
        let quotient  = Self(bitPattern: dividend.low)
        let remainder = Self(bitPattern: dividend.low) &  ~(copy divisor)
        let overflow  = divisor == 0 ||  dividend.high == 1
        return Overflow(Division(quotient: quotient, remainder: remainder), overflow: overflow)
    }
}
