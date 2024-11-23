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
        //=--------------------------------------=
        // error...: result ∉ [-U.max, U.max]
        // suberror: result ∉ [ S.min, S.max]
        // negative: result ∉ [-S.max, S.max]
        //=--------------------------------------=
        var minus  = self.isNegative != multiplier.isNegative
        var result = Fallible<Self>(raw: self.magnitude().times(multiplier.magnitude()))

        var suberror = result.value.isNegative
        if  minus {
            (result.value, minus) = result.value.complement(true).components()
            suberror = !minus && (suberror) // because S.min is not a suberror
        }
        
        return result.veto(suberror)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1 as 3
    //=------------------------------------------------------------------------=

    @inlinable package func multiplication(_ multiplier: High) -> TripleInt<High> {
        let minus  = self.isNegative != multiplier.isNegative
        let result = TripleInt<High>(raw: self.magnitude().multiplication(multiplier.magnitude()))
        return minus ? result.complement() : result
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2 as 4 (nonrecursive)
    //=------------------------------------------------------------------------=
    
    @inlinable public func multiplication(_ multiplier: Self) -> Doublet<Self> {
        let minus  = self.isNegative  != multiplier.isNegative
        let result: Doublet<Magnitude> = self.magnitude().multiplication(multiplier.magnitude())
        return Doublet(raw: minus ? result.complement() : result)
    }
}

//*============================================================================*
// MARK: * Double Int x Multiplication x Unsigned
//*============================================================================*

extension DoubleInt where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1 as 3
    //=------------------------------------------------------------------------=
    
    @inlinable func multiplication(_ multiplier: High) -> TripleInt<High> {
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
        let by = !Bool(Bit(self.high.isZero) | Bit(multiplier.high.isZero))
        //=--------------------------------------=
        var overflow: (Bool, Bool)
        //=--------------------------------------=
        (ax.high, overflow.0) = ax.high.plus(ay.value).components()
        (ax.high, overflow.1) = ax.high.plus(bx.value).components()
        //=--------------------------------------=
        let error = Bit(by) | Bit(ay.error) | Bit(bx.error) | Bit(overflow.0) | Bit(overflow.1)
        return Self(raw: ax).veto(Bool(error))
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
        var overflow: (Bool, Bool)
        //=--------------------------------------=
        (ax.high, overflow.0) = ax.high.plus(ay.low ).components()
        (ax.high, overflow.1) = ax.high.plus(bx.low ).components()
        let az =  Low(Bit(overflow.0)) &+ Low(Bit(overflow.1))
        //=--------------------------------------=
        (by.low,  overflow.0) = by.low .plus(ay.high).components()
        (by.low,  overflow.1) = by.low .plus(bx.high).components()
        let bz =  Low(Bit(overflow.0)) &+ Low(Bit(overflow.1))
        //=--------------------------------------=
        (by) = by.plus(Self(low: az, high: bz)).unchecked()
        return Doublet(low: Magnitude(ax), high: Magnitude(by))
    }
}
