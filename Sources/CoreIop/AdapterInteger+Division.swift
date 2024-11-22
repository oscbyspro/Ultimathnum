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
// MARK: * Adapter Integer x Division
//*============================================================================*

extension AdapterInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func /(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(Base(lhs) / rhs.base)
    }
    
    @inlinable public static func /=(lhs: inout Self, rhs: borrowing Self) {
        lhs.base /= rhs.base
    }
    
    @inlinable public static func %(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(Base(lhs) % rhs.base)
    }
    
    @inlinable public static func %=(lhs: inout Self, rhs: borrowing Self) {
        lhs.base %= rhs.base
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotientAndRemainder(dividingBy divisor: borrowing Self) -> (quotient: Self, remainder: Self) {
        let division = Base(self).division(Nonzero(divisor.base)).unwrap().unwrap()
        return (quotient: Self(division.quotient), remainder: Self(division.remainder))
    }
}
