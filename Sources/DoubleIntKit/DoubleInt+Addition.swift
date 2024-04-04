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
// MARK: * Double Int x Addition
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ increment: borrowing Self) -> Fallible<Self> {
        Fallible(bitPattern: self.storage.plus(increment.storage))
    }
    
    @inlinable public consuming func plus(_ increment: consuming Element) -> Fallible<Self> {
        let appendix = High(repeating: increment.appendix)
        let low  = self.low .plus(Low(load: increment))
        let high = self.high.plus(appendix, carrying: low.error)
        return Fallible(Self(low: low.value, high: high.value), error: high.error)
    }
}
