//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Doublet x Multiplication
//*============================================================================*

extension Doublet {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func times(_ multiplier: Self) -> Fallible<Self> {
        let minus  = self.isLessThanZero != multiplier.isLessThanZero
        var result = Fallible<Self>(bitPattern: self.magnitude._times(multiplier.magnitude))
        
        var suboverflow = (result.value.isLessThanZero)
        if  minus {
            suboverflow = !Fallible.capture(&result.value) { $0.negated() } && suboverflow
        }
        
        return result.combine(suboverflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public func multiplication(_ multiplier: Base) -> Triplet<Base> {
        let minus  = self.high.isLessThanZero != multiplier.isLessThanZero
        let result = Triplet<Base>(bitPattern: self.magnitude._multiplication(multiplier.magnitude))
        return minus ? result.negated().value : result
    }
}

//*============================================================================*
// MARK: * Doublet x Multiplication x Unsigned
//*============================================================================*

extension Doublet where Base == Base.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func _times(_ multiplier: Self) -> Fallible<Self> {
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
    
    @inlinable func _multiplication(_ multiplier: Base) -> Triplet<Base> {
        let ax = self.low .multiplication(multiplier)
        let bx = self.high.multiplication(multiplier)
        return Triplet(low: ax.low, high: bx.plus(ax.high).assert())
    }
}
