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
    
    @inlinable public consuming func minus(_ decrement: borrowing Self) -> Fallible<Self> {
        Fallible(bitPattern: self.storage.minus(decrement.storage))
    }
    
    @inlinable public consuming func minus(_ decrement: consuming Element) -> Fallible<Self> {
        let appendix = High(repeating: decrement.appendix)
        let low  = self.low .minus(Low(load: decrement))
        let high = self.high.minus(appendix, carrying: low.error)
        return Fallible(Self(low: low.value, high: high.value), error: high.error)
    }
}
