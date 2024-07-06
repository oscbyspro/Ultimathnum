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
// MARK: * Triple Int x Division x Unsigned
//*============================================================================*

extension TripleInt where Base == Base.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 3 by 1 as 2 and 1
    //=------------------------------------------------------------------------=
    
    @inlinable package consuming func division3121(unchecked divisor: Divisor<Base>) -> Division<DoubleInt<Base>, Base> {
        Swift.assert(divisor.value > self.high, "quotient must fit in two halves")
        let high = Base.division( Doublet(low: self.mid, high: self.high     ), by:  divisor).unchecked()
        let low  = Base.division( Doublet(low: self.low, high: high.remainder), by:  divisor).unchecked()
        return Division(quotient: DoubleInt(low: low.quotient, high: high.quotient), remainder: low.remainder)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation x 3 by 2 as 1 and 2
    //=------------------------------------------------------------------------=
    
    @inlinable package consuming func division3212(normalized divisor: Divisor<DoubleInt<Base>>) -> Division<Base, DoubleInt<Base>> {
        //=--------------------------------------=
        Swift.assert(divisor.value.high >= Base.msb, "the divisor must be normalized")
        Swift.assert(DoubleInt(low: self.mid, high: self.high) < divisor.value, "the quotient must fit in one half")
        //=--------------------------------------=
        var quotient: Base = if divisor.value.high == self.high {
            Base.max // the quotient must fit in one part
        }   else {
            Base.division(Doublet(low: self.mid, high: self.high), by: Divisor(unchecked: divisor.value.high)).unchecked().quotient
        }
        //=--------------------------------------=
        // decrement when overestimated (max 2)
        //=--------------------------------------=
        var product: Self = divisor.value.multiplication(quotient)
        
        while self < product {
            quotient = quotient.minus(0000001).unchecked()
            product  = product .minus(divisor.value).unchecked()
        };  ((self)) = ((self)).minus(product).unchecked()
        
        Swift.assert(self.high.isZero, "remainder must fit in two halves")
        Swift.assert(DoubleInt(low: self.low, high: self.mid) < divisor.value, "remainder must be less than divisor")
        return Division(quotient: quotient, remainder: DoubleInt(low: self.low, high: self.mid))
    }
}
