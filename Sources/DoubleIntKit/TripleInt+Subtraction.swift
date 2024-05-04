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
// MARK: * Triple Int x Subtraction
//*============================================================================*

extension TripleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 3 by 2
    //=------------------------------------------------------------------------=
    
    @inlinable package consuming func minus(_ decrement: borrowing DoubleInt<Base>) -> Fallible<Self> {
        let appendix = High(repeating: decrement.storage.high.appendix)
        let low  = self.storage.low .minus(decrement.storage.low)
        let mid  = self.storage.mid .minus(Mid(raw: decrement.storage.high), plus: low.error)
        let high = self.storage.high.minus(appendix, plus: mid.error)
        return Self(low: low.value, mid: mid.value, high: high.value).invalidated(high.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 3 by 3
    //=------------------------------------------------------------------------=
    
    @inlinable package consuming func minus(_ decrement: borrowing Self) -> Fallible<Self> {
        let low  = self.storage.low .minus(decrement.storage.low)
        let mid  = self.storage.mid .minus(decrement.storage.mid,  plus: low.error)
        let high = self.storage.high.minus(decrement.storage.high, plus: mid.error)
        return Self(low: low.value, mid: mid.value, high: high.value).invalidated(high.error)
    }
}
