//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit

//*============================================================================*
// MARK: * Stdlib Int x Division
//*============================================================================*

extension StdlibInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func /(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base / rhs.base)
    }
    
    @inlinable public static func /=(lhs: inout Self, rhs: borrowing Self) {
        lhs.base /= rhs.base
    }
    
    @inlinable public static func %(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base % rhs.base)
    }
    
    @inlinable public static func %=(lhs: inout Self, rhs: borrowing Self) {
        lhs.base %= rhs.base
    }
    
    @inlinable public consuming func quotientAndRemainder(dividingBy rhs: borrowing Self) -> (quotient: Self, remainder: Self) {
        let result = self.base.division(Divisor(rhs.base)).unwrap()
        return (quotient: Self(result.quotient), remainder: Self(result.remainder))
    }
}
