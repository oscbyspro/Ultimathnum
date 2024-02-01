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
    
    /// Forms the `remainder` of dividing the `dividend` by the `divisor`,
    /// then returns the `quotient`. The `divisor` must be normalized and
    /// the `quotient` must fit in one element.
    ///
    /// - Returns: The `quotient` is returned and the `remainder` replaces the `dividend`.
    ///
    /// ### Development 1
    ///
    /// Comparing is faster than overflow checking, according to time profiler.
    ///
    /// ### Development 2
    ///
    /// The approximation needs at most two corrections, but looping is faster.
    ///
    @inlinable package static func formRemainderWithQuotient3212MSB(
    dividing dividend: inout Triplet<Base>, by divisor: Doublet<Base>) -> Base {
        //=--------------------------------------=
        Swift.assert(divisor.high.count(0, option: .descending) == 0,
        "the divisor must be normalized")
        
        Swift.assert(self.compare22S(Doublet(high: dividend.high, low: dividend.mid), to: divisor) == Signum.less,
        "the quotient must fit in one element")
        //=--------------------------------------=
        var quotient: Base = divisor.high == dividend.high
        ? Base.max // the quotient must fit in one element
        : try! Base.dividing(Doublet(high: dividend.high, low: dividend.mid), by: divisor.high).quotient
        //=--------------------------------------=
        // decrement when overestimated (max 2)
        //=--------------------------------------=
        var product = self.multiplying213(divisor, by: quotient)
        
        while self.compare33S(dividend, to: product) == -1 {
            _ = Overflow.capture(&quotient, map:{ try $0.plus(1) })
            _ = self.decrement32B(&product,  by: divisor)
        };  _ = self.decrement33B(&dividend, by: product)
        
        Swift.assert(self.compare33S(dividend, to: Triplet(high: 0, mid: divisor.high, low: divisor.low)) == Signum.less)
        return quotient as Base
    }
}
