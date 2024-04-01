//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
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
    dividing remainder: consuming TripleIntLayout<Base>, by divisor: DoubleIntLayout<Base>) -> Division<Base, DoubleIntLayout<Base>> {
        //=--------------------------------------=
        Swift.assert(divisor.high.count(0, option: .descending) == 0,
        "the divisor must be normalized")
        
        Swift.assert(DoubleIntLayout(high: remainder.high, low: remainder.mid) < divisor,
        "the quotient must fit in one element")
        //=--------------------------------------=
        var quotient: Base = divisor.high == remainder.high
        ? Base.max // the quotient must fit in one element
        : Base.division(DoubleIntLayout(high: remainder.high, low: remainder.mid), by: divisor.high).assert().quotient
        //=--------------------------------------=
        // decrement when overestimated (max 2)
        //=--------------------------------------=
        var product = divisor.multiplication(quotient)
        
        while remainder < product {
            quotient  = quotient .minus(0000001).assert()
            product   = product  .minus(divisor).assert()
        };  remainder = remainder.minus(product).assert()
        
        Swift.assert(remainder < TripleIntLayout(high: 0, mid: divisor.high, low: divisor.low))
        return Division(quotient: quotient, remainder: DoubleIntLayout(low: remainder.low, high: remainder.mid))
    }
}
