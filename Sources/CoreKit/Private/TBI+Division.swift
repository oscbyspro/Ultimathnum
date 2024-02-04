//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Tuple Binary Integer x Division x Unsigned
//*============================================================================*

extension Namespace.TupleBinaryInteger where Base == Base.Magnitude {
    
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
    @inlinable package static func division3212MSB(
    dividing remainder: consuming Triplet<Base>, by divisor: Doublet<Base>) -> Division<Base, Doublet<Base>> {
        //=--------------------------------------=
        Swift.assert(divisor.high.count(0, option: .descending) == 0,
        "the divisor must be normalized")
        
        Swift.assert(self.compare22S(Doublet(high: remainder.high, low: remainder.mid), to: divisor) == Signum.less,
        "the quotient must fit in one element")
        //=--------------------------------------=
        var quotient: Base = divisor.high == remainder.high
        ? Base.max // the quotient must fit in one element
        : try! Base.dividing(Doublet(high: remainder.high, low: remainder.mid), by: divisor.high).quotient
        //=--------------------------------------=
        // decrement when overestimated (max 2)
        //=--------------------------------------=
        var product = self.multiplying213(divisor, by: quotient)
        
        while self.compare33S(remainder, to: product) == Signum.less {
            _ = Overflow.capture(&(quotient), map:{ try $0.minus(1) })
            _ = self.decrement32B(&(product), by: divisor)
        };  _ = self.decrement33B(&remainder, by: product)
        
        Swift.assert(self.compare33S(remainder, to: Triplet(high: 0, mid: divisor.high, low: divisor.low)) == Signum.less)
        return Division(quotient: quotient, remainder: Doublet(low: remainder.low, high: remainder.mid))
    }
}
