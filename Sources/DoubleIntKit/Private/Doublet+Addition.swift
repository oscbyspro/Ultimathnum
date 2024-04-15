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
// MARK: * Doublet x Addition
//*============================================================================*

extension Doublet {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1
    //=------------------------------------------------------------------------=
        
    @inlinable public consuming func plus(_ increment: Base) -> Fallible<Self> {
        let appendix = High.init(repeating: increment.appendix)
        let low  = self.low .plus(Low(bitPattern: increment))
        let high = self.high.plus(appendix,  and: low.error)
        return Self(low: low.value, high: high.value).combine(high.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2
    //=------------------------------------------------------------------------=
    
    @inlinable package consuming func plus(_ increment: borrowing Self) -> Fallible<Self> {
        let low  = self.low .plus(increment.low)
        let high = self.high.plus(increment.high, and: low.error)
        return Self(low: low.value, high: high.value).combine(high.error)
    }
}
