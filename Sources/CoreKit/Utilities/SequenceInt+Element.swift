//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Sequence Int x Element
//*============================================================================*

extension SequenceInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The element at the given index.
    ///
    /// Its elements are ordered from least significant to most, with infinite sign extension.
    ///
    @inlinable public subscript(index: Int) -> Element {
        Self.element(index, base: self.base, sign: self.extension.element)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func element(_ index: Int, base: Base, sign: Element) -> Element {
        switch comparison {
        case Signum.same: return Equal.element(index, base: base, sign: sign)
        case Signum.less: return Minor.element(index, base: base, sign: sign)
        case Signum.more: return Major.element(index, base: base, sign: sign)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Equal
//=----------------------------------------------------------------------------=

extension SequenceInt.Equal {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func element(_ index: Int, base: Base, sign: Element) -> Element {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.same, String.unreachable())
        //=--------------------------------------=
        if  index >= base.count { return sign }
        //=--------------------------------------=
        return PBI.bitCastOrLoad(base[base.index(base.startIndex, offsetBy: index)], as: Element.self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Minor
//=----------------------------------------------------------------------------=

extension SequenceInt.Minor {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func element(_ index: Int, base: Base, sign: Element) -> Element {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.less, String.unreachable())
        //=--------------------------------------=
        precondition(index >= 0 as Int, String.indexOutOfBounds())
        let quotient  = index &>> self.ratio.trailingZeroBitCount
        let remainder = index &  (self.ratio - 1)
        //=--------------------------------------=
        if  quotient >= base.count { return sign }
        //=--------------------------------------=
        let major = base[base.index(base.startIndex, offsetBy: quotient)]
        let shift = Base.Element(load: UX(bitPattern: remainder)) &<< Base.Element(load: Element.bitWidth.count(0, option: .ascending).load(as: UX.self))
        return PBI.load(major &>> shift, as: Element.self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Major
//=----------------------------------------------------------------------------=

extension SequenceInt.Major {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func element(_ index: Int, base: Base, sign: Element) -> Element {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.more, String.unreachable())
        //=--------------------------------------=
        var major = 0 as Element
        var shift = 0 as Element.Magnitude
        let minor = self.ratio * index
        
        if  minor < base.count {
            var   baseIndex = base.index(base.startIndex, offsetBy: minor)
            while baseIndex < base.endIndex, shift < Element.bitWidth {
                major = major | PBI.load(Base.Element.Magnitude(bitPattern: base[baseIndex]), as: Element.self) &<< Element(bitPattern: shift)
                shift = shift + Element.Magnitude(load: Base.Element.bitWidth.load(as: UX.self))
                base.formIndex(after: &baseIndex)
            }
        }
        
        return shift >= Element.bitWidth ? major : major | sign &<< Element(bitPattern: shift)
    }
}