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
// MARK: * Double Int x Shift
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1 as 2
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func up(_ distance: Shift<Base.Magnitude>) -> Self {
        Self(self.storage.up(distance))
    }
    
    @inlinable public consuming func down(_ distance: Shift<Base.Magnitude>) -> Self {
        Self(self.storage.down(distance))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2 as 2
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func up(_ distance: Shift<Magnitude>) -> Self {
        let difference = UX(raw: distance.value).minus(UX(raw: Base.size))
        if  difference.error {
            return Self(self.storage.up(Shift(unchecked: distance.value)))
            
        }   else {
            let shift = Shift<Low>(unchecked: Count(raw: IX(raw: difference.value)))
            return Self(low: Low.zero, high: High(raw: self.low.up(shift)))
        }
    }
    
    @inlinable public consuming func down(_ distance: Shift<Magnitude>) -> Self {
        let difference = UX(raw: distance.value).minus(UX(raw: Base.size))
        if  difference.error {
            return Self(self.storage.down(Shift(unchecked: distance.value)))
            
        }   else {
            let shift = Shift<Low>(unchecked: Count(raw: IX(raw: difference.value)))
            return Self(low: Low(raw: self.high.down(shift)), high: High(repeating: self.high.appendix))
        }
    }
}
