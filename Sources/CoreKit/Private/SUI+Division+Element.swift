//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Strict Unsigned Integer x Division x Element x Sub Sequence
//*============================================================================*

extension Namespace.StrictUnsignedInteger.SubSequence {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Returns the `remainder` of dividing the `base` by the `divisor`,
    /// along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is the first element in `base`.
    ///
    @inlinable package static func remainderReportingOverflow(
    dividing base: Base, by divisor: Base.Element) -> (partialValue: Base.Element, overflow: Bool) {
        //=--------------------------------------=
        guard divisor != 0 else {
            return (partialValue: base.first ?? 000 as Base.Element, overflow: true)
        }
        //=--------------------------------------=
        return (partialValue: self.remainder(dividing: base, by: divisor), overflow: false)
    }
    
    /// Returns the `remainder` of dividing the `base` by the `divisor`.
    ///
    /// - Requires: The divisor must be nonzero.
    ///
    @inlinable package static func remainder(
    dividing base: Base, by divisor: Base.Element) -> Base.Element {
        //=--------------------------------------=
        precondition(divisor != 0, String.overflow())
        //=--------------------------------------=
        var remainder = 0 as Base.Element
        var index = base.endIndex as Base.Index
        //=--------------------------------------=
        backwards: while index > base.startIndex {
            base.formIndex(before: &index)
            remainder = Base.Element.dividing(DoubleIntLayout(high: remainder, low: base[index]), by: divisor).assert().remainder
        }
        //=--------------------------------------=
        return remainder  as Base.Element
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Base is Mutable Collection
//=----------------------------------------------------------------------------=

extension Namespace.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the `quotient` of dividing the `base` by the `divisor`, and returns
    /// the `remainder` along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is the first element in `base`.
    ///
    @inlinable package static func formQuotientWithRemainderReportingOverflow(
    dividing base: inout Base, by divisor: Base.Element) -> (partialValue: Base.Element, overflow: Bool) {
        //=--------------------------------------=
        guard divisor != 0 else {
            return (partialValue: base.first ?? 000 as Base.Element, overflow: true)
        }
        //=--------------------------------------=
        return (partialValue: self.formQuotientWithRemainder(dividing: &base, by: divisor), overflow: false)
    }
    
    /// Forms the `quotient` of dividing the `base` by the `divisor`, and returns the `remainder`.
    ///
    /// - Requires: The divisor must be nonzero.
    ///
    @inlinable package static func formQuotientWithRemainder(
    dividing base: inout Base, by divisor: Base.Element) -> Base.Element {
        //=--------------------------------------=
        precondition(divisor != 0, String.overflow())
        //=--------------------------------------=
        var remainder = 0 as Base.Element
        var index = base.endIndex as Base.Index
        //=--------------------------------------=
        backwards: while index > base.startIndex {
            (base).formIndex(before: &index)
            (base[index], remainder) = Base.Element.dividing(DoubleIntLayout(high: remainder, low: base[index]), by: divisor).assert().components
        }
        //=--------------------------------------=
        return remainder  as Base.Element
    }
}
