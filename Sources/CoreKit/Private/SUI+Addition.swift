//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Strict Unsigned Integer x Addition x Sub Sequence
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Bit
//=----------------------------------------------------------------------------=

extension Namespace.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Increments `base` by `bit`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func increment(
    _   base: inout Base, by bit: Bool) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool = bit
        //=--------------------------------------=
        self.increment(&base, by: &bit, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Increments `base` by `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    /// ### Development
    ///
    /// Comparing the index before the bit is important for performance reasons.
    ///
    @inlinable package static func increment(
    _   base: inout Base, by bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        Swift.assert(index >= base.startIndex)
        Swift.assert(index <= base.endIndex  )
        //=--------------------------------------=
        while index < base.endIndex, bit {
            bit = Overflow.capture(&base[index], map:{ try $0.plus(1) })
            base.formIndex(after: &index)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Some
//=----------------------------------------------------------------------------=

extension Namespace.StrictUnsignedInteger.SubSequence where Base: MutableCollection {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Increments `base` by `increment`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func increment(
    _   base: inout Base, by increment: Base.Element) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool
        //=--------------------------------------=
        bit = self.increment(&base, by: increment, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }

    /// Partially increments `base` by `increment`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func incrementInIntersection(
    _   base: inout Base, by increment: Base.Element) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool
        //=--------------------------------------=
        bit = self.incrementInIntersection(&base, by: increment, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    /// Increments `base` by `increment` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func increment(
    _   base: inout Base, by increment: Base.Element, at index: inout Base.Index) -> Bool {
        //=--------------------------------------=
        var bit = self.incrementInIntersection(&base, by: increment, at: &index)
        //=--------------------------------------=
        self.increment(&base, by: &bit, at: &index)
        return bit as Bool as Bool as Bool as Bool
    }

    /// Partially increments `base` by `increment` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func incrementInIntersection(
    _   base: inout Base, by increment: Base.Element, at index: inout Base.Index) -> Bool {
        //=--------------------------------------=
        Swift.assert(index >= base.startIndex)
        Swift.assert(index <  base.endIndex  )
        //=--------------------------------------=
        defer {
            base.formIndex(after: &index)
        }
        
        return Overflow.capture(&base[index], map:{ try $0.plus(increment) })
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Some + Bit
//=----------------------------------------------------------------------------=

extension Namespace.StrictUnsignedInteger.SubSequence where Base: MutableCollection {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Increments `base` by the sum of `increment` and `bit`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func increment(
    _   base: inout Base, by increment: Base.Element, plus bit: Bool) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool = bit
        //=--------------------------------------=
        self.increment(&base, by: increment, plus: &bit, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }

    /// Partially increments `base` by the sum of `increment` and `bit`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func incrementInIntersection(
    _   base: inout Base, by increment: Base.Element, plus bit: Bool) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool = bit
        //=--------------------------------------=
        self.incrementInIntersection(&base, by: increment, plus: &bit, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Partially increments `base` by the sum of `increment` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable package static func increment(
    _   base: inout Base, by increment: Base.Element, plus bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        self.incrementInIntersection(&base, by: increment, plus: &bit, at: &index)
        //=--------------------------------------=
        self.increment(&base, by: &bit, at: &index)
    }

    /// Partially increments `base` by the sum of `increment` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable package static func incrementInIntersection(
    _   base: inout Base, by increment: Base.Element, plus bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        Swift.assert(index >= base.startIndex)
        Swift.assert(index <  base.endIndex  )
        //=--------------------------------------=
        var increment = increment as Base.Element
        //=--------------------------------------=
        if  bit {
            bit = Overflow.capture(&(increment), map:{ try $0.plus(1) })
        }
        
        if !bit {
            bit = Overflow.capture(&base[index], map:{ try $0.plus(increment) })
        }
        
        base.formIndex(after: &index)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Many + Bit
//=----------------------------------------------------------------------------=

extension Namespace.StrictUnsignedInteger.SubSequence where Base: MutableCollection {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Increments `base` by the sum of `elements` and `bit`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func increment(
    _   base: inout Base, by elements: some Sequence<Base.Element>, plus bit: Bool = false) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool = bit
        //=--------------------------------------=
        self.increment(&base, by: elements, plus: &bit, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }

    /// Partially increments `base` by the sum of `elements` and `bit.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func incrementInIntersection(
    _   base: inout Base, by elements: some Sequence<Base.Element>, plus bit: Bool = false) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool = bit
        //=--------------------------------------=
        self.incrementInIntersection(&base, by: elements, plus: &bit, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    /// Increments `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable package static func increment(
    _   base: inout Base, by elements: some Sequence<Base.Element>, plus bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        self.incrementInIntersection(&base, by: elements, plus: &bit, at: &index)
        //=--------------------------------------=
        self.increment(&base, by: &bit, at: &index)
    }

    /// Partially increments `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable package static func incrementInIntersection(
    _   base: inout Base, by elements: some Sequence<Base.Element>, plus bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        for element in elements {
            self.incrementInIntersection(&base, by: element, plus: &bit, at: &index)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Many × Some + Some
//=----------------------------------------------------------------------------=

extension Namespace.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Increments `base` by `elements` times `multiplier` plus `increment`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func increment(
    _ base: inout Base, by elements: some Sequence<Base.Element>, times multiplier: Base.Element,
    plus increment: Base.Element = 0) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex
        //=--------------------------------------=
        let bit = self.increment(&base, by: elements, times: multiplier, plus: increment, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }
    
    /// Partially increments `base` by `elements` times `multiplier` plus `increment`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func incrementInIntersection(
    _ base: inout Base, by elements: some Sequence<Base.Element>, times multiplier: Base.Element,
    plus increment: Base.Element = 0) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex
        //=--------------------------------------=
        let bit = self.incrementInIntersection(&base, by: elements, times: multiplier, plus: increment, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Increments `base` by `elements` times `multiplier` plus `increment` at `index`.
    ///
    /// - Returns: An overflow indicator.
    ///
    @discardableResult @inlinable package static func increment(
    _ base: inout Base, by elements: some Sequence<Base.Element>, times multiplier: Base.Element,
    plus increment: Base.Element, at index: inout Base.Index) -> Bool {
        //=--------------------------------------=
        var bit = self.incrementInIntersection(&base, by: elements, times: multiplier, plus: increment, at: &index)
        //=--------------------------------------=
        self.increment(&base, by: &bit, at: &index)
        return bit as Bool as Bool as Bool as Bool
    }
    
    /// Partially increments `base` by `elements` times `multiplier` plus `increment` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator.
    ///
    @discardableResult @inlinable package static func incrementInIntersection(
    _ base: inout Base, by elements: some Sequence<Base.Element>, times multiplier: Base.Element,
    plus increment: Base.Element, at index: inout Base.Index) -> Bool {
        //=--------------------------------------=
        var last: Base.Element = increment
        //=--------------------------------------=
        for element in elements {
            //  maximum == (high: ~1, low: 1)
            var wide = Base.Element.multiplying(element, by: multiplier)
            //  maximum == (high: ~0, low: 0)
            last = wide.high &+ Base.Element(Bit(bitPattern: Overflow.capture(&wide.low, map:{ try $0.plus(last) })))
            //  this cannot overflow because low == 0 when high == ~0
            last = last &+ Base.Element(Bit(bitPattern: self.incrementInIntersection(&base, by: wide.low, at: &index)))
        }
        
        return self.incrementInIntersection(&base, by: last, at: &index)
    }
}
