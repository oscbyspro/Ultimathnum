//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Minimi Int x Division
//*============================================================================*

extension MinimiInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func quotient(divisor: Self) throws -> Self {
        if  divisor == 0 || Self.isSigned && Bool(bitPattern: self & divisor) {
            throw Overflow()
        }
        
        return consume self
    }
    
    @inlinable public func remainder(divisor: Self) throws -> Self {
        if  divisor == 0 || Self.isSigned && Bool(bitPattern: self & divisor) {
            throw Overflow()
        }
        
        return Self(bitPattern: self.base > divisor.base)
    }
    
    @inlinable public func divided(by divisor: Self) throws -> Division<Self, Self> {
        Division(quotient: self, remainder: try self.remainder(divisor: divisor))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func dividing(_ dividend: DoubleIntLayout<Self>, by divisor: Self) throws -> Division<Self, Self> {
        if  divisor == 0 || Bool(bitPattern: dividend.high) && !(Self.isSigned && Bool(bitPattern: dividend.low)) {
            throw  Overflow()
        }   else {
            let quotient  = Self(bitPattern: dividend.low)
            let remainder = Self(bitPattern: dividend.low) & ~divisor
            return Division(quotient: quotient, remainder: remainder)
        }
    }
}
