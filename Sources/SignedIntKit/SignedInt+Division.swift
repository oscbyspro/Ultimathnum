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
// MARK: * Signed Int x Division
//*============================================================================*

extension SignedInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(divisor: Self) throws -> Self {
        try Self(sign: self.sign ^ divisor.sign) {
            try self.magnitude.quotient(divisor: divisor.magnitude)
        }
    }
    
    @inlinable public consuming func remainder(divisor: Self) throws -> Self {
        try Self(sign: self.sign) {
            try self.magnitude.remainder(divisor: divisor.magnitude)
        }
    }
    
    @inlinable public consuming func divided(by divisor: Self) throws -> Division<Self> {
        let magnitude = Overflow.capture({ try self.magnitude.divided(by: divisor.magnitude) })
        let quotient  = Overflow.ignore ({ try Self(sign: self.sign ^ divisor.sign, magnitude: magnitude.value.quotient ) })
        let remainder = Overflow.ignore ({ try Self(sign: self.sign   /*--------*/, magnitude: magnitude.value.remainder) })
        return try Overflow.resolve(Division(quotient: quotient, remainder: remainder), overflow: magnitude.overflow)
    }
}
