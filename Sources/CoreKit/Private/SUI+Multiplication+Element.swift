//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Strict Unsigned Integer x Multiplication x Element x Sub Sequence
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Some + Some
//=----------------------------------------------------------------------------=

extension Namespace.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Multiplies `base` by `multiplier` then adds `increment`.
    ///
    /// - Returns: The `low` product is formed in `base` and the `high` product is returned in one element.
    ///
    @inlinable package static func multiply(
    _   base: inout Base, by multiplier: Base.Element, add increment: Base.Element) -> Base.Element {
        //=--------------------------------------=
        var carry: Base.Element = increment
        var index: Base.Index = base.startIndex
        //=--------------------------------------=
        self.multiply(&base, by: multiplier, add: &carry, from: &index, to: base.endIndex)
        //=--------------------------------------=
        return carry as Base.Element
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Multiplies `base` by `multiplier` then adds `increment` from `index` to `limit`.
    ///
    /// - Returns: The `low` product is formed in `base[index..<limit]` and the `high` product is formed in `increment`.
    ///
    @inlinable package static func multiply(
    _   base: inout Base, by multiplier: Base.Element, add increment: inout Base.Element, from index: inout Base.Index, to limit: Base.Index) {
        //=--------------------------------------=
        Swift.assert(index >= base.startIndex)
        Swift.assert(index <= limit)
        Swift.assert(limit <= base.endIndex  )
        //=--------------------------------------=
        forwards: while index < limit {
            var  wide = base[index].multiplication(multiplier)
            wide.high = wide.high &+ Base.Element(Bit(bitPattern: Fallible.capture(&wide.low, map:{ $0.plus(increment) })))
            increment = wide.high
            base[index] = wide.low
            base.formIndex(after: &index)
        }
    }
}
