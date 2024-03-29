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
// MARK: * Infini Int x Division
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable consuming public func quotient (_ divisor: borrowing Self) -> Fallible<Self> {
        fatalError("TODO")
    }
    
    @inlinable consuming public func remainder(_ divisor: borrowing Self) -> Fallible<Self> {
        fatalError("TODO")
    }
    
    @inlinable consuming public func division (_ divisor: borrowing Self) -> Fallible<Division<Self, Self>> {
        fatalError("TODO")
    }
}
