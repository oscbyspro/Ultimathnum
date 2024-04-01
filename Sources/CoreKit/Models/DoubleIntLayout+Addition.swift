//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Double Int Layout x Addition
//*============================================================================*

extension DoubleIntLayout {
    
    //=------------------------------------------------------------------------=
    // MARK: Transfornations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ increment: Base) -> Fallible<Self> {
        let appendix = High(repeating: increment.appendix)
        let low  = self.low .plus(Low(bitPattern: increment))
        let high = self.high.plus((((appendix))), carrying: low.error)
        return Fallible(Self(low: low.value, high: high.value), error: high.error)
    }
    
    @inlinable public consuming func plus(_ increment: borrowing Self) -> Fallible<Self> {
        let low  = self.low .plus(increment.low)
        let high = self.high.plus(increment.high,  carrying: low.error)
        return Fallible(Self(low: low.value, high: high.value),  error: high.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ increment: borrowing Self, carrying error: consuming Bool) -> Fallible<Self> {
        let low  = self.low .plus(increment.low,   carrying:     error)
        let high = self.high.plus(increment.high,  carrying: low.error)
        return Fallible(Self(low: low.value, high: high.value),  error: high.error)
    }
}
