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
// MARK: * UNM x Normal Int x Division
//*============================================================================*

extension NormalInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient (divisor: borrowing Self) -> Overflow<Self> {
        fatalError("TODO")
    }
    
    @inlinable public consuming func remainder(divisor: borrowing Self) -> Overflow<Self> {
        fatalError("TODO")
    }
    
    @inlinable public consuming func divided(by divisor: borrowing Self) -> Overflow<QuoRem<Self, Self>> {
        fatalError("TODO")
    }
}
