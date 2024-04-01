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
// MARK: * Double Int x Subtraction
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> Fallible<Self> {
        Fallible(bitPattern: self.storage.negated())
    }
    
    @inlinable public consuming func minus(_ increment: borrowing Self) -> Fallible<Self> {
        Fallible(bitPattern: self.storage.minus(increment.storage))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func minus(_ increment: borrowing Self, carrying error: consuming Bool) -> Fallible<Self> {
        Fallible(bitPattern: self.storage.minus(increment.storage, carrying: error))
    }
}
