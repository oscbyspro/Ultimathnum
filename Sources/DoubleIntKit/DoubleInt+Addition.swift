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
    // MARK: Transformations x 2 by 1
    //=------------------------------------------------------------------------=
        
    @inlinable public consuming func plus(_ increment: Base) -> Fallible<Self> {
        let appendix = High.init(repeating: increment.appendix)
        let low  = self.low .plus(Low(raw:  increment))
        let high = self.high.plus(appendix, plus: low.error)
        return Self(low: low.value, high: high.value).veto(high.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ increment: borrowing Self) -> Fallible<Self> {
        let low  = self.storage.low .plus(increment.storage.low)
        let high = self.storage.high.plus(increment.storage.high, plus: low.error)
        return Self(low: low.value, high: high.value).veto(high.error)
    }
}
