//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Triplet x Division x Unsigned x Private
//*============================================================================*

extension Triplet where Base == Base.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` and `remainder` of dividing the `dividend` by the `divisor`,
    /// The `divisor` must be normalized and the `quotient` must fit in one element.
    ///
    /// ### Development 1
    ///
    /// Comparing is faster than overflow checking, according to time profiler.
    ///
    /// ### Development 2
    ///
    /// The approximation needs at most two corrections, but looping is faster.
    ///
    @inlinable package consuming func division3212MSB(_ divisor: Doublet<Base>) -> Division<Base, Doublet<Base>> {
        //=--------------------------------------=
        Swift.assert(
            divisor.high & Base.msb != 0,
            "the divisor must be normalized"
        )
        Swift.assert(
            Doublet(low: self.mid, high: self.high) < divisor,
            "the quotient must fit in one element"
        )
        //=--------------------------------------=
        var quotient: Base = if  divisor.high == self.high {
            Base.max // the quotient must fit in one element
        }   else {
            Doublet(low: self.mid, high: self.high).quotient(divisor.high).assert()
        }
        //=--------------------------------------=
        // decrement when overestimated (max 2)
        //=--------------------------------------=
        var product = divisor.multiplication(quotient)

        while self < product {
            quotient = quotient.minus(0000001).assert()
            product  = product .minus(divisor).assert()
        };  ((self)) = ((self)).minus(product).assert()
        
        Swift.assert(self < Triplet(high: 0, low: divisor))
        return Division(quotient: quotient, remainder: Doublet(low: self.low, high: self.mid))
    }
}
