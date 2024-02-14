//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Exchange Int x Element x Bit Pattern
//*============================================================================*

extension ExchangeInt where Element == Element.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The element at the given `index`, ordered from least significant to most.
    @inlinable public subscript(index: Int) -> Element {
        BitPattern.element(index, base: self.base, appendix: self.appendix.bitPattern)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func element(_ index: Int, base: Base, appendix: Bit.Extension<Element>) -> Element {
        switch comparison {
        case Signum.same: Equal.element(index, base: base, appendix: appendix)
        case Signum.less: Minor.element(index, base: base, appendix: appendix)
        case Signum.more: Major.element(index, base: base, appendix: appendix)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Equal
//=----------------------------------------------------------------------------=

extension ExchangeInt.Equal where Element == Element.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func element(_ index: Int, base: Base, appendix: Bit.Extension<Element>) -> Element {
        //=--------------------------------------=
        precondition(ExchangeInt.comparison == Signum.same, String.unreachable())
        //=--------------------------------------=
        if  index >= base.count {
            return appendix.element
        }
        //=--------------------------------------=
        return Element.tokenized(bitCastOrLoad: base[base.index(base.startIndex, offsetBy: index)])
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Minor
//=----------------------------------------------------------------------------=

extension ExchangeInt.Minor where Element == Element.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func element(_ index: Int, base: Base, appendix: Bit.Extension<Element>) -> Element {
        //=--------------------------------------=
        precondition(ExchangeInt.comparison == Signum.less, String.unreachable())
        //=--------------------------------------=
        precondition(index >= 0 as Int, String.indexOutOfBounds())
        let quotient  = index &>> self.ratio.trailingZeroBitCount
        let remainder = index &  (self.ratio - 1)
        //=--------------------------------------=
        if  quotient >= base.count {
            return appendix.element
        }
        //=--------------------------------------=
        let major = base[base.index(base.startIndex, offsetBy: quotient)]
        let shift = Base.Element(load: UX(bitPattern: remainder)) &<< Base.Element(load: Element.bitWidth.count(0, option: .ascending).load(as: UX.self))
        return Element.tokenized(load: major &>> shift)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Major
//=----------------------------------------------------------------------------=

extension ExchangeInt.Major where Element == Element.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func element(_ index: Int, base: Base, appendix: Bit.Extension<Element>) -> Element {
        //=--------------------------------------=
        precondition(ExchangeInt.comparison == Signum.more, String.unreachable())
        //=--------------------------------------=
        var major = 0 as Element
        var shift = 0 as Element.Magnitude
        let minor = self.ratio * index
        
        if  minor < base.count {
            var   baseIndex = base.index(base.startIndex, offsetBy: minor)
            while baseIndex < base.endIndex, shift < Element.bitWidth {
                major = major | Element.tokenized(load: Base.Element.Magnitude(bitPattern: base[baseIndex])) &<< Element(bitPattern: shift)
                shift = shift + Element.Magnitude(load: UX(bitWidth: Base.Element.self))
                base.formIndex(after: &baseIndex)
            }
        }
        
        return shift >= Element.bitWidth ? major : major | appendix.element &<< Element(bitPattern: shift)
    }
}
