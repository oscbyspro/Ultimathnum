//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Strict Unsigned Integer x Subtraction x Sub Sequence
//*============================================================================*
// MARK: + Bit
//=----------------------------------------------------------------------------=

extension Namespace.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Decrements `base` by `bit`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func decrement(
    _   base: inout Base, by bit: Bool) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool = bit
        //=--------------------------------------=
        self.decrement(&base, by: &bit, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Decrements `base` by `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    /// ### Development
    ///
    /// Comparing the index before the bit is important for performance reasons.
    ///
    @inlinable package static func decrement(
    _   base: inout Base, by bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        Swift.assert(index >= base.startIndex)
        Swift.assert(index <= base.endIndex  )
        //=--------------------------------------=
        while index < base.endIndex, bit {
            bit = base[index].capture({ $0.minus(1) })
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

    /// Decrements `base` by `increment`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func decrement(
    _   base: inout Base, by increment: Base.Element) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool
        //=--------------------------------------=
        bit = self.decrement(&base, by: increment, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }

    /// Partially decrements `base` by `increment`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func decrementInIntersection(
    _   base: inout Base, by increment: Base.Element) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool
        //=--------------------------------------=
        bit = self.decrementInIntersection(&base, by: increment, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    /// Decrements `base` by `increment` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func decrement(
    _   base: inout Base, by increment: Base.Element, at index: inout Base.Index) -> Bool {
        //=--------------------------------------=
        var bit = self.decrementInIntersection(&base, by: increment, at: &index)
        //=--------------------------------------=
        self.decrement(&base, by: &bit, at: &index)
        return bit as Bool as Bool as Bool as Bool
    }

    /// Partially decrements `base` by `increment` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func decrementInIntersection(
    _   base: inout Base, by increment: Base.Element, at index: inout Base.Index) -> Bool {
        //=--------------------------------------=
        Swift.assert(index >= base.startIndex)
        Swift.assert(index <  base.endIndex  )
        //=--------------------------------------=
        defer {
            base.formIndex(after: &index)
        }
        
        return base[index].capture({ $0.minus(increment) })
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Some + Bit
//=----------------------------------------------------------------------------=

extension Namespace.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Decrements `base` by the sum of `increment` and `bit`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func decrement(
    _   base: inout Base, by increment: Base.Element, plus bit: Bool) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool = bit
        //=--------------------------------------=
        self.decrement(&base, by: increment, plus: &bit, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }

    /// Partially decrements `base` by the sum of `increment` and `bit`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func decrementInIntersection(
    _   base: inout Base, by increment: Base.Element, plus bit: Bool) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool = bit
        //=--------------------------------------=
        self.decrementInIntersection(&base, by: increment, plus: &bit, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Partially decrements `base` by the sum of `increment` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable package static func decrement(
    _   base: inout Base, by increment: Base.Element, plus bit: inout Bool, at index: inout Base.Index) {
        self.decrementInIntersection(&base, by: increment, plus: &bit, at: &index)
        self.decrement(&base, by: &bit, at: &index)
    }

    /// Partially decrements `base` by the sum of `increment` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable package static func decrementInIntersection(
    _   base: inout Base, by increment: Base.Element, plus bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        Swift.assert(index >= base.startIndex)
        Swift.assert(index <  base.endIndex  )
        //=--------------------------------------=
        var increment = increment as Base.Element
        //=--------------------------------------=
        if  bit {
            bit = (increment).capture({ $0.plus(1) })
        }

        if !bit {
            bit = base[index].capture({ $0.minus(increment) })
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

    /// Decrements `base` by the sum of `elements` and `bit`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func decrement(
    _   base: inout Base, by elements: some Sequence<Base.Element>, plus bit: Bool = false) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool = bit
        //=--------------------------------------=
        self.decrement(&base, by: elements, plus: &bit, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }

    /// Partially decrements `base` by the sum of `elements` and `bit`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func decrementInIntersection(
    _   base: inout Base, by elements: some Sequence<Base.Element>, plus bit: Bool = false) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool = bit
        //=--------------------------------------=
        self.decrementInIntersection(&base, by: elements, plus: &bit, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    /// Decrements `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable package static func decrement(
    _   base: inout Base, by elements: some Sequence<Base.Element>, plus bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        self.decrementInIntersection(&base, by: elements, plus: &bit, at: &index)
        //=--------------------------------------=
        self.decrement(&base, by: &bit, at: &index)
    }

    /// Partially decrements `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable package static func decrementInIntersection(
    _   base: inout Base, by elements: some Sequence<Base.Element>, plus bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        for element in elements {
            self.decrementInIntersection(&base, by: element, plus: &bit, at: &index)
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
    
    /// Decrements `base` by `elements` times `multiplier` plus `increment`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func decrement(
    _ base: inout Base, by elements: some Sequence<Base.Element>, times multiplier: Base.Element,
    plus increment: Base.Element = 0) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex
        //=--------------------------------------=
        let bit = self.decrement(&base, by: elements, times: multiplier, plus: increment, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }
    
    /// Partially decrements `base` by `elements` times `multiplier` plus `increment`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable package static func decrementInIntersection(
    _ base: inout Base, by elements: some Sequence<Base.Element>, times multiplier: Base.Element,
    plus increment: Base.Element = 0) -> (index: Base.Index, overflow: Bool) {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex
        //=--------------------------------------=
        let bit = self.decrementInIntersection(&base, by: elements, times: multiplier, plus: increment, at: &index)
        //=--------------------------------------=
        return (index: index as Base.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Decrements `base` by `elements` times `multiplier` plus `increment` at `index`.
    ///
    /// - Returns: An overflow indicator.
    ///
    @discardableResult @inlinable package static func decrement(
    _ base: inout Base, by elements: some Sequence<Base.Element>, times multiplier: Base.Element,
    plus increment: Base.Element, at index: inout Base.Index) -> Bool {
        //=--------------------------------------=
        var bit = self.decrementInIntersection(&base, by: elements, times: multiplier, plus: increment, at: &index)
        //=--------------------------------------=
        self.decrement(&base, by: &bit, at: &index)
        return bit as Bool as Bool as Bool as Bool
    }
    
    /// Partially decrements `base` by `elements` times `multiplier` plus `increment` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator.
    ///
    @discardableResult @inlinable package static func decrementInIntersection(
    _ base: inout Base, by elements: some Sequence<Base.Element>, times multiplier: Base.Element,
    plus increment: Base.Element, at index: inout Base.Index) -> Bool {
        //=--------------------------------------=
        var last: Base.Element = increment
        //=--------------------------------------=
        for element in elements {
            //  maximum == (high: ~1, low: 1)
            var wide = element.multiplication(multiplier)
            //  maximum == (high: ~0, low: 0)
            last = wide.high &+ Base.Element(Bit(bitPattern: wide.low.capture({ $0.plus(last) })))
            //  this cannot overflow because low == 0 when high == ~0
            last = last &+ Base.Element(Bit(bitPattern: self.decrementInIntersection(&base, by: wide.low, at: &index)))
        }
        
        return self.decrementInIntersection(&base, by: last, at: &index)
    }
}
