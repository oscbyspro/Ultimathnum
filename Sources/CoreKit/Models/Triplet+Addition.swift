//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Triplet x Addition
//*============================================================================*

extension Triplet {
    
    //=------------------------------------------------------------------------=
    // MARK: Transfornations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ increment: Base) -> Fallible<Self> {
        let appendix = High(repeating: increment.appendix)
        let low  = self.low .plus(Low(bitPattern: increment))
        let mid  = self.mid .plus(Mid(bitPattern: appendix), carrying: low.error)
        let high = self.high.plus((((appendix))), carrying:  mid.error)
        return Fallible(Self(low: low.value, mid: mid.value, high: high.value), error: high.error)
    }
    
    @inlinable public consuming func plus(_ increment: borrowing Doublet<Base>) -> Fallible<Self> {
        let appendix = High(repeating: increment.high.appendix)
        let low  = self.low .plus(increment.low)
        let mid  = self.mid .plus(Mid(bitPattern: increment.high), carrying: low.error)
        let high = self.high.plus((((appendix))), carrying:  mid.error)
        return Fallible(Self(low: low.value, mid: mid.value, high: high.value), error: high.error)
    }
    
    @inlinable public consuming func plus(_ increment: borrowing Self) -> Fallible<Self> {
        let low  = self.low .plus(increment.low)
        let mid  = self.mid .plus(increment.mid,  carrying:  low.error)
        let high = self.high.plus(increment.high, carrying:  mid.error)
        return Fallible(Self(low: low.value, mid: mid.value, high: high.value), error: high.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ increment: borrowing Self, carrying error: consuming Bool) -> Fallible<Self> {
        let low  = self.low .plus(increment.low,  carrying:      error)
        let mid  = self.mid .plus(increment.mid,  carrying:  low.error)
        let high = self.high.plus(increment.high, carrying:  mid.error)
        return Fallible(Self(low: low.value, mid: mid.value, high: high.value), error: high.error)
    }
}
