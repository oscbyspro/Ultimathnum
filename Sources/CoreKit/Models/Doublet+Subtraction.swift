//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Doublet x Subtraction
//*============================================================================*

extension Doublet {
    
    //=------------------------------------------------------------------------=
    // MARK: Transfornations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> Fallible<Self> {
        let low  = (~self.low ).plus(1)
        let high = (~self.high).plus(High(Bit(bitPattern: low.error)))
        return Fallible(Self(low: low.value, high: high.value),  error: high.error == Self.isSigned)
    }
    
    @inlinable public consuming func minus(_ increment: Base) -> Fallible<Self> {
        let appendix = High(repeating: increment.appendix)
        let low  = self.low .minus(Low(bitPattern: increment))
        let high = self.high.minus((((appendix))), carrying: low.error)
        return Fallible(Self(low: low.value, high: high.value),  error: high.error)
    }
    
    @inlinable public consuming func minus(_ increment: borrowing Self) -> Fallible<Self> {
        let low  = self.low .minus(increment.low)
        let high = self.high.minus(increment.high, carrying: low.error)
        return Fallible(Self(low: low.value, high: high.value),  error: high.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func minus(_ increment: borrowing Self, carrying error: consuming Bool) -> Fallible<Self> {
        let low  = self.low .minus(increment.low,  carrying:     error)
        let high = self.high.minus(increment.high, carrying: low.error)
        return Fallible(Self(low: low.value, high: high.value),  error: high.error)
    }
}
