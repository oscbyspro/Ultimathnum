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
// MARK: * Doublet x Multiplication
//*============================================================================*

extension Doublet {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1
    //=------------------------------------------------------------------------=
    
    @inlinable package func multiplication(_ multiplier: Base) -> Triplet<Base> {
        let minus  = self.high.isLessThanZero != multiplier.isLessThanZero
        let result = Triplet<Base>(bitPattern: self.magnitude().multiplication(multiplier.magnitude()))
        return minus ? result.complement() : result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1
    //=------------------------------------------------------------------------=
    
    @inlinable package consuming func times(_ multiplier: Self) -> Fallible<Self> {
        let minus  = self.high.isLessThanZero != multiplier.high.isLessThanZero
        var result = Fallible<Self>(bitPattern: self.magnitude().times(multiplier.magnitude()))
        
        var suboverflow = (result.value.high.isLessThanZero)
        if  minus {
            suboverflow = !result.value[{ $0.complement(true) }] && suboverflow
        }
        
        return result.combine(suboverflow)
    }
}

//*============================================================================*
// MARK: * Doublet x Multiplication x Unsigned
//*============================================================================*

extension Doublet where Base == Base.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1
    //=------------------------------------------------------------------------=
    
    @inlinable func multiplication(_ multiplier: Base) -> Triplet<Base> {
        let ax = self.low .multiplication(multiplier)
        let bx = self.high.multiplication(multiplier)
        return Triplet(low: ax.low, high: bx.plus(ax.high).assert())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2
    //=------------------------------------------------------------------------=
    
    @inlinable func times(_ multiplier: Self) -> Fallible<Self> {
        var ax = self.low .multiplication(multiplier.low)
        let ay = self.low .times(multiplier.high)
        let bx = self.high.times(multiplier.low )
        let by = !Bool(Bit(self.high == 0) | Bit(multiplier.high == 0))
        
        let o0 = ax.high[{ $0.plus(ay.value) }]
        let o1 = ax.high[{ $0.plus(bx.value) }]
        
        let error = Bit(by) | Bit(ay.error) | Bit(bx.error) | Bit(o0) | Bit(o1)
        return Fallible(Self(bitPattern: ax), error: Bool(error))
    }
}
