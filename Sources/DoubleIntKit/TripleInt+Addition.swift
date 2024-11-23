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
// MARK: * Triple Int x Addition
//*============================================================================*

extension TripleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 3 by 2
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ increment: borrowing DoubleInt<Low>) -> Fallible<Self> {
        let low  = self.storage.low .plus(increment.storage.low)
        let mid  = self.storage.mid .plus(Mid(raw: increment.storage.high), plus: low.error)
        let high = self.storage.high.incremented((mid.error))
        return Fallible(Self(low: low.value, mid: mid.value, high: high.value), error: high.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 3 by 3
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ increment: borrowing Self) -> Fallible<Self> {
        let low  = self.storage.low .plus(increment.storage.low)
        let mid  = self.storage.mid .plus(increment.storage.mid,  plus: low.error)
        let high = self.storage.high.plus(increment.storage.high, plus: mid.error)
        return Fallible(Self(low: low.value, mid: mid.value, high: high.value), error: high.error)
    }
}
