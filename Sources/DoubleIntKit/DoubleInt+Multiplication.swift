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
// MARK: * Double Int x Multiplication
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2 as 2
    //=------------------------------------------------------------------------=

    @inlinable public consuming func squared() -> Fallible<Self> {
        self.times(copy self)
    }
    
    @inlinable public consuming func times(_ multiplier: Self) -> Fallible<Self> {
        var minus  = self.high.isNegative != multiplier.high.isNegative
        var result = Fallible<Self>(raw: self.magnitude().times(multiplier.magnitude()))
        
        var suboverflow = result.value.high.isNegative
        if  minus {
            (result.value, minus) = result.value.complement(true).components()
            suboverflow = Bool(Bit(suboverflow) & Bit(!minus))
        }
        
        return result.veto(suboverflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1 as 3
    //=------------------------------------------------------------------------=

    @inlinable package func multiplication(_ multiplier: Base) -> TripleInt<Base> {
        let minus  = self.high.isNegative != multiplier.isNegative
        let result = TripleInt<Base>(raw: self.magnitude().multiplication(multiplier.magnitude()))
        return minus ? result.complement() : result
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2 as 4 (nonrecursive)
    //=------------------------------------------------------------------------=
    
    @inlinable public func multiplication(_ multiplier: Self) -> Doublet<Self> {
        let minus  = self.high.isNegative != multiplier.high.isNegative
        let result: Doublet<Magnitude> = self.magnitude().multiplication(multiplier.magnitude())
        return Doublet(raw: minus ? result.complement() : result)
    }
}

//*============================================================================*
// MARK: * Double Int x Multiplication x Unsigned
//*============================================================================*

extension DoubleInt where Base == Base.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1 as 3
    //=------------------------------------------------------------------------=
    
    @inlinable func multiplication(_ multiplier: Base) -> TripleInt<Base> {
        let ax = Self(self.low .multiplication(multiplier))
        let bx = Self(self.high.multiplication(multiplier))
        return TripleInt(low: ax.low, high: bx.plus(ax.high).unchecked().storage)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2 as 2
    //=------------------------------------------------------------------------=
    
    @inlinable func times(_ multiplier: Self) -> Fallible<Self> {
        //=--------------------------------------=
        var ax = self.low .multiplication(multiplier.low)
        let ay = self.low .times(multiplier.high)
        let bx = self.high.times(multiplier.low )
        let by = !Bool(Bit(self.high == 0) | Bit(multiplier.high == 0))
        //=--------------------------------------=
        var o0 : Bool
        var o1 : Bool
        //=--------------------------------------=
        (ax.high, o0) = ax.high.plus(ay.value).components()
        (ax.high, o1) = ax.high.plus(bx.value).components()
        //=--------------------------------------=
        let error = Bit(by) | Bit(ay.error) | Bit(bx.error) | Bit(o0) | Bit(o1)
        return Fallible(Self(raw: ax), error: Bool(error))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2 as 4 (nonrecursive)
    //=------------------------------------------------------------------------=
    
    @inlinable func multiplication(_ multiplier: Self) -> Doublet<Self> {
        //=--------------------------------------=
        var ax = Self(self.low .multiplication(multiplier.low ))
        let ay = Self(self.low .multiplication(multiplier.high))
        let bx = Self(self.high.multiplication(multiplier.low ))
        var by = Self(self.high.multiplication(multiplier.high))
        //=--------------------------------------=
        var o0 : Bool
        var o1 : Bool
        //=--------------------------------------=
        (ax.high, o0) = ax.high.plus(ay.low ).components()
        (ax.high, o1) = ax.high.plus(bx.low ).components()
        let az = Low(Bit(o0)) &+ Low(Bit(o1))
        //=--------------------------------------=
        (by.low,  o0) = by.low .plus(ay.high).components()
        (by.low,  o1) = by.low .plus(bx.high).components()
        let bz = Low(Bit(o0)) &+ Low(Bit(o1))
        //=--------------------------------------=
        by = by.plus(Self(low: az, high: bz)).unchecked()
        //=--------------------------------------=
        return Doublet(low: Magnitude(ax), high: Magnitude(by))
    }
}
