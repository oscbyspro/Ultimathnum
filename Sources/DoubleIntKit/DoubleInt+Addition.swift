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
        
    @inlinable public consuming func plus(_ other: Base.Magnitude) -> Fallible<Self> {
        let low  = self.low .plus(Low(raw:  other))
        let high = self.high.incremented(low.error)
        return Self(low: low.value, high: high.value).veto(high.error)
    }
    
    @inlinable public consuming func minus(_ other: Base.Magnitude) -> Fallible<Self> {
        let low  = self.low .minus(Low(raw: other))
        let high = self.high.decremented(low.error)
        return Self(low: low.value, high: high.value).veto(high.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ other: borrowing Self) -> Fallible<Self> {
        let low  = self.storage.low .plus(other.storage.low)
        let high = self.storage.high.plus(other.storage.high, plus: low.error)
        return Self(low: low.value, high: high.value).veto(high.error)
    }
    
    @inlinable public consuming func minus(_ other: borrowing Self) -> Fallible<Self> {
        let low  = self.storage.low .minus(other.storage.low)
        let high = self.storage.high.minus(other.storage.high, plus: low.error)
        return Self(low: low.value, high: high.value).veto(high.error)
    }
}
