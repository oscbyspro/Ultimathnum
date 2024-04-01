//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Triple Int Layout x Subtraction
//*============================================================================*

extension TripleIntLayout {
    
    //=------------------------------------------------------------------------=
    // MARK: Transfornations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> Fallible<Self> {
        let low  = (~self.low ).plus(1)
        let mid  = (~self.mid ).plus(Mid (Bit(bitPattern: low.error)))
        let high = (~self.high).plus(High(Bit(bitPattern: mid.error)))
        return Fallible(Self(low: low.value, mid: mid.value, high: high.value), error: high.error == Self.isSigned)
    }
    
    @inlinable public consuming func minus(_ increment: Base) -> Fallible<Self> {
        let appendix = High(repeating: increment.appendix)
        let low  = self.low .minus(Low(bitPattern: increment))
        let mid  = self.mid .minus(Mid(bitPattern: appendix), carrying: low.error)
        let high = self.high.minus((((appendix))), carrying: mid.error)
        return Fallible(Self(low: low.value, mid: mid.value, high: high.value), error: high.error)
    }
    
    @inlinable public consuming func minus(_ increment: borrowing DoubleIntLayout<Base>) -> Fallible<Self> {
        let appendix = High(repeating: increment.high.appendix)
        let low  = self.low .minus(increment.low)
        let mid  = self.mid .minus(Mid(bitPattern: increment.high), carrying: low.error)
        let high = self.high.minus((((appendix))), carrying: mid.error)
        return Fallible(Self(low: low.value, mid: mid.value, high: high.value), error: high.error)
    }
    
    @inlinable public consuming func minus(_ increment: borrowing Self) -> Fallible<Self> {
        let low  = self.low .minus(increment.low)
        let mid  = self.mid .minus(increment.mid,  carrying: low.error)
        let high = self.high.minus(increment.high, carrying: mid.error)
        return Fallible(Self(low: low.value, mid: mid.value, high: high.value), error: high.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func minus(_ increment: borrowing Self, carrying error: consuming Bool) -> Fallible<Self> {
        let low  = self.low .minus(increment.low,  carrying:     error)
        let mid  = self.mid .minus(increment.mid,  carrying: low.error)
        let high = self.high.minus(increment.high, carrying: mid.error)
        return Fallible(Self(low: low.value, mid: mid.value, high: high.value), error: high.error)
    }
}
