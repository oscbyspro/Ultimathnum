//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Triple Int Layout x Addition
//*============================================================================*

extension TripleIntLayout {
    
    //=------------------------------------------------------------------------=
    // MARK: Transfornations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ increment: borrowing Self) -> Fallible<Self> {
        let low  = self.low .plus(increment.low)
        let mid  = self.low .plus(increment.mid,  carrying:  low.error)
        let high = self.high.plus(increment.high, carrying:  mid.error)
        return Fallible(Self(low: low.value, mid: mid.value, high: high.value), error: high.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ increment: borrowing Self, carrying error: consuming Bool) -> Fallible<Self> {
        let low  = self.low .plus(increment.low,  carrying:      error)
        let mid  = self.low .plus(increment.mid,  carrying:  low.error)
        let high = self.high.plus(increment.high, carrying:  mid.error)
        return Fallible(Self(low: low.value, mid: mid.value, high: high.value), error: high.error)
    }
}
