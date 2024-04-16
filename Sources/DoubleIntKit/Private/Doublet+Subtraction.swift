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
// MARK: * Doublet x Subtraction
//*============================================================================*

extension Doublet {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1
    //=------------------------------------------------------------------------=
        
    @inlinable public consuming func minus(_ decrement: Base) -> Fallible<Self> {
        let appendix = High.init(repeating: decrement.appendix)
        let low  = self.low .minus(Low(bitPattern: decrement))
        let high = self.high.minus(appendix, plus: low.error)
        return Self(low: low.value, high: high.value).combine(high.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2
    //=------------------------------------------------------------------------=
    
    @inlinable package consuming func minus(_ decrement: borrowing Self) -> Fallible<Self> {
        let low  = self.low .minus(decrement.low)
        let high = self.high.minus(decrement.high, plus: low.error)
        return Self(low: low.value, high: high.value).combine(high.error)
    }
}
