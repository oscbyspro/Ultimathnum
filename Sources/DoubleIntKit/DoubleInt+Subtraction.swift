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
    
    @inlinable public consuming func minus(_ decrement: borrowing Self) -> Fallible<Self> {
        Fallible(bitPattern: self.storage.minus(decrement.storage))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func minus(_ decrement: borrowing Self, carrying error: consuming Bool) -> Fallible<Self> {
        let low  = self.storage.low .minus(decrement.storage.low,  carrying:     error)
        let high = self.storage.high.minus(decrement.storage.high, carrying: low.error)
        return Fallible(Self(low: low.value, high: high.value), error: high.error)
    }
}
