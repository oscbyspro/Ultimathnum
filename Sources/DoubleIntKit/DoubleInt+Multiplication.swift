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
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func squared() -> Fallible<Self> {
        self.times(copy self)
    }
    
    @inlinable public func times(_ multiplier: Self) -> Fallible<Self> {
        let lhsIsLessThanZero: Bool = (self/*--*/.isLessThanZero)
        let rhsIsLessThanZero: Bool = (multiplier.isLessThanZero)
        let minus: Bool = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        var result = Fallible<Self>(bitPattern: self.magnitude._times(multiplier.magnitude))
        //=--------------------------------------=
        var suboverflow = (result.value.isLessThanZero)
        if  minus {
            suboverflow = !result.value.capture({ $0.negated() }) && suboverflow
        }
        //=--------------------------------------=
        return result.combine(suboverflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public func multiplication(_ multiplier: Self) -> Doublet<Self> {
        let lhsIsLessThanZero: Bool = (self/*--*/.isLessThanZero)
        let rhsIsLessThanZero: Bool = (multiplier.isLessThanZero)
        let minus: Bool = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        let result: Doublet<Magnitude> = self.magnitude._multiplication(multiplier.magnitude)
        return Doublet(bitPattern: minus ? result.negated().value : result)
    }
}

//*============================================================================*
// MARK: * Double Int x Multiplication x Unsigned
//*============================================================================*

extension DoubleInt where Base == Base.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func _times(_ multiplier: Self) -> Fallible<Self> {
        var ax = self.low .multiplication(multiplier.low)
        let ay = self.low .times(multiplier.high)
        let bx = self.high.times(multiplier.low )
        let by = !(self.high == 0 || multiplier.high == 0)
        
        let o0 = ax.high.capture({ $0.plus(ay.value) })
        let o1 = ax.high.capture({ $0.plus(bx.value) })
        
        let overflow = by || ay.error || bx.error || o0 || o1
        return Fallible(Self(bitPattern: ax), error: overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public func _multiplication(_ multiplier: Self) -> Doublet<Self> {
        var ax = self.low .multiplication(multiplier.low )
        let ay = self.low .multiplication(multiplier.high)
        let bx = self.high.multiplication(multiplier.low )
        var by = self.high.multiplication(multiplier.high)
        
        let a0 = ax.high.capture({ $0.plus(ay.low ) })
        let a1 = ax.high.capture({ $0.plus(bx.low ) })
        let a2 = Low(Bit(bitPattern: a0)) &+ Low(Bit(bitPattern: a1))
        
        let b0 = by.low .capture({ $0.plus(ay.high) })
        let b1 = by.low .capture({ $0.plus(bx.high) })
        let b2 = Low(Bit(bitPattern: b0)) &+ Low(Bit(bitPattern: b1))
        
        let o0 = by.low .capture({ $0.plus(a2) })
        let _  = by.high.capture({ $0.plus(b2  &+  Low(Bit(bitPattern: o0))) })
        return Doublet(low: Magnitude(ax), high: Magnitude(by))
    }
}
