//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Minimi Int x Division x Signed
//*============================================================================*

extension MinimiInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func quotient(divisor: Self) throws -> Self {
        try Overflow.resolve(self, overflow: self <= divisor)
    }
    
    @inlinable public func remainder(divisor: Self) throws -> Self {
        try Overflow.resolve(Self(bitPattern: self < divisor), overflow: self <= divisor)
    }
    
    @inlinable public func divided(by divisor: Self) throws -> Division<Self> {
        try Overflow.resolve(Division(quotient: self, remainder: Self(bitPattern: self < divisor)), overflow: self <= divisor)
    }
    
    @inlinable public static func dividing(_ dividend: Doublet<Self>, by divisor: Self) throws -> Division<Self> {
        let quotient  = Self(bitPattern: dividend.low)
        let remainder = Self(bitPattern: dividend.low) & ~divisor
        let overflow  = divisor == 0 || (dividend.low) == 0 && dividend.high == -1
        return try Overflow.resolve(Division(quotient: quotient, remainder: remainder), overflow: overflow)
    }
}

//*============================================================================*
// MARK: * Minimi Int x Division x Unsigned
//*============================================================================*

extension MinimiInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func quotient (divisor: Self) throws -> Self {
        try Overflow.resolve(self, overflow: divisor == 0)
    }
    
    @inlinable public func remainder(divisor: Self) throws -> Self {
        try Overflow.resolve(Self(bitPattern: self > divisor), overflow: divisor == 0)
    }
    
    @inlinable public func divided(by divisor: Self) throws -> Division<Self> {
        try Overflow.resolve(Division(quotient: self, remainder: Self(bitPattern: self > divisor)), overflow: divisor == 0)
    }
    
    @inlinable public static func dividing(_ dividend: Doublet<Self>, by divisor: Self) throws -> Division<Self> {
        let quotient  = Self(bitPattern: dividend.low)
        let remainder = Self(bitPattern: dividend.low) & ~divisor
        let overflow  = divisor == 0 ||  dividend.high == 1
        return try Overflow.resolve(Division(quotient: quotient, remainder: remainder), overflow: overflow)
    }
}
