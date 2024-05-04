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
        let minus  = self.high.isNegative != multiplier.high.isNegative
        var result = Fallible<Self>(raw: self.magnitude().times(multiplier.magnitude()))
        
        var suboverflow = (result.value.high.isNegative)
        if  minus {
            suboverflow = !result.value[{ $0.complement(true) }] && suboverflow
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
        return TripleInt(low: ax.low, high: bx.plus(ax.high).assert().storage)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2 as 2
    //=------------------------------------------------------------------------=
    
    @inlinable func times(_ multiplier: Self) -> Fallible<Self> {
        var ax = self.low .multiplication(multiplier.low)
        let ay = self.low .times(multiplier.high)
        let bx = self.high.times(multiplier.low )
        let by = !Bool(Bit(self.high == 0) | Bit(multiplier.high == 0))
        
        let o0 = ax.high[{ $0.plus(ay.value) }]
        let o1 = ax.high[{ $0.plus(bx.value) }]
        
        let error = Bit(by) | Bit(ay.error) | Bit(bx.error) | Bit(o0) | Bit(o1)
        return Fallible(Self(raw: ax), error: Bool(error))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2 as 4 (nonrecursive)
    //=------------------------------------------------------------------------=
    
    @inlinable func multiplication(_ multiplier: Self) -> Doublet<Self> {
        var ax = Self(self.low .multiplication(multiplier.low ))
        let ay = Self(self.low .multiplication(multiplier.high))
        let bx = Self(self.high.multiplication(multiplier.low ))
        var by = Self(self.high.multiplication(multiplier.high))
        //=--------------------------------------=
        let a0 = ax.high[{ $0.plus(ay.low ) }]
        let a1 = ax.high[{ $0.plus(bx.low ) }]
        let a2 = Low(Bit(a0)) &+  Low(Bit(a1))
        //=--------------------------------------=
        let b0 = by.low [{ $0.plus(ay.high) }]
        let b1 = by.low [{ $0.plus(bx.high) }]
        let b2 = Low(Bit(b0)) &+  Low(Bit(b1))
        //=--------------------------------------=
        by = by.plus(Self(low: a2, high: b2)).assert()
        //=--------------------------------------=
        return Doublet(low: Magnitude(ax), high: Magnitude(by))
    }
}
