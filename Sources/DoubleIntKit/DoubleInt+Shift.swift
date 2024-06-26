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
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func up(_ distance: Shift<Magnitude>) -> Self {
        //=--------------------------------------=
        // note: even a 2-bit shift fits in 1 bit
        //=--------------------------------------=
        if  UX(load: distance.value.low) >= UX(size: Base.self) {
            let distance = Shift(unchecked: distance.value.low.minus(Base.size).unchecked())
            self.high = Base(raw: self.low.up(distance))
            self.low  = Base.Magnitude(repeating: Bit(false))
        }   else {
            self.storage = self.storage.up(Shift(unchecked: distance.value.low))
        }

        return self // as Self as Self as Self
    }
    
    @inlinable public consuming func down(_ distance: Shift<Magnitude>) -> Self {
        //=--------------------------------------=
        // note: even a 2-bit shift fits in 1 bit
        //=--------------------------------------=
        if  UX(load: distance.value.low) >= UX(size: Base.self) {
            let distance = Shift(unchecked: distance.value.low.minus(Base.size).unchecked())
            self.low  = Base.Magnitude(raw: self.high.down(distance))
            self.high = Base(repeating: Bit(self.high.isNegative))
        }   else {
            self.storage = self.storage.down(Shift(unchecked: distance.value.low))
        }
        
        return self // as Self as Self as Self
    }
}
