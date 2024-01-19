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
// MARK: * Double Int x Division
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(divisor: borrowing Self) throws -> Self {
        fatalError("TODO")
    }
    
    @inlinable public consuming func remainder(divisor: borrowing Self) throws -> Self {
        fatalError("TODO")
    }
    
    @inlinable public consuming func divided(by divisor: borrowing Self) throws -> Division<Self> {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func dividing(_ dividend: consuming Doublet<Self>, by multiplier: borrowing Self) throws -> Division<Self> {
        fatalError("TODO")
    }
}
