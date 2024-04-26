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
// MARK: * Triplet x Division x Unsigned
//*============================================================================*

extension Triplet where Base == Base.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 3 by 1
    //=------------------------------------------------------------------------=
    
    @inlinable package consuming func division3121(unchecked divisor: Divisor<Base>) -> Division<Doublet<Base>, Base> {
        Swift.assert(divisor.value > self.high, "quotient must fit in two halves")
        let high = Doublet(low: self.mid, high: self.high     ).division2111(divisor).assert()
        let low  = Doublet(low: self.low, high: high.remainder).division2111(divisor).assert()
        return Division(quotient: Doublet(low: low.quotient, high: high.quotient), remainder: low.remainder)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation x 3 by 2
    //=------------------------------------------------------------------------=
    
    @inlinable package consuming func division3212(normalized divisor: Doublet<Base>) -> Division<Base, Doublet<Base>> {
        //=--------------------------------------=
        Swift.assert(
            divisor.high >= Base.msb,
            "the divisor must be normalized"
        )
        Swift.assert(
            Doublet(low: self.mid, high: self.high) < divisor,
            "the quotient must fit in one element"
        )
        //=--------------------------------------=
        var quotient: Base = if divisor.high == self.high {
            Base.max // the quotient must fit in one part
        }   else {
            Doublet(low: self.mid, high: self.high).division2111(Divisor(unchecked: divisor.high)).assert().quotient
        }
        //=--------------------------------------=
        // decrement when overestimated (max 2)
        //=--------------------------------------=
        var product: Self = divisor.multiplication(quotient)

        while self < product {
            quotient = quotient.minus(0000001).assert()
            product  = product .minus(divisor).assert()
        };  ((self)) = ((self)).minus(product).assert()
        
        Swift.assert(self < Triplet(high: 0, low: divisor))
        return Division(quotient: quotient, remainder: Doublet(low: self.low, high: self.mid))
    }
}
