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

extension UMNNormalInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient (dividingBy divisor: borrowing Self) -> UMNOverflow<Self> {
        fatalError("TODO")
    }
    
    @inlinable public consuming func remainder(dividingBy divisor: borrowing Self) -> UMNOverflow<Self> {
        fatalError("TODO")
    }
    
    @inlinable public consuming func divided(by divisor: borrowing Self) -> UMNOverflow<UMNQuoRem<Self, Self>> {
        fatalError("TODO")
    }
}
