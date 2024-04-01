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
    
    @inlinable public consuming func plus(_ increment: borrowing Self) -> Fallible<Self> {
        let a = self.low .plus(increment.low)
        let b = self.high.plus(increment.high, carrying: a.error)
        return Fallible(Self(low: a.value, high: b.value), error: b.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ increment: borrowing Self, carrying error: consuming Bool) -> Fallible<Self> {
        let a = self.low .plus(increment.low,  carrying:   error)
        let b = self.high.plus(increment.high, carrying: a.error)
        return Fallible(Self(low: a.value, high: b.value), error: b.error)
    }
}
