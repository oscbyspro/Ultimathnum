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
// MARK: * Stdlib Int x Multiplication
//*============================================================================*

extension StdlibInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func *(lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(lhs.base * rhs.base)
    }
    
    @inlinable public static func *=(lhs: inout Self, rhs: borrowing Self) {
        lhs.base *= rhs.base
    }
    
    @inlinable public borrowing func squared() -> Self {
        Self(self.base.squared().unchecked("ArbitraryInteger & SignedInteger"))
    }
}
