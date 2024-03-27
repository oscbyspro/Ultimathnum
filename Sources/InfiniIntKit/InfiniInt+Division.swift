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
    
    @inlinable consuming public func quotient(divisor: borrowing Self) throws -> Self {
        fatalError("TODO")
    }
    
    @inlinable consuming public func remainder(divisor: borrowing Self) throws -> Self {
        fatalError("TODO")
    }
    
    @inlinable consuming public func divided(by divisor: borrowing Self) throws -> Division<Self, Self> {
        fatalError("TODO")
    }
}
