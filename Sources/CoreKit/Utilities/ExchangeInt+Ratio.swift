//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Exchange Int x Ratio
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Minor
//=----------------------------------------------------------------------------=

extension ExchangeInt.Minor where Element == Element.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static var ratio: Int {
        //=--------------------------------------=
        precondition(ExchangeInt.comparison == Signum.less, String.unreachable())
        //=--------------------------------------=
        let major = Base.Element.bitWidth
        let minor = Base.Element.Magnitude(load: Element.bitWidth.load(as: UX.self))
        let value = major &>> minor.count(0, option: Bit.Selection.ascending)
        return value.load(as: IX.self).stdlib
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Major
//=----------------------------------------------------------------------------=

extension ExchangeInt.Major where Element == Element.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static var ratio: Int {
        //=--------------------------------------=
        precondition(ExchangeInt.comparison == Signum.more, String.unreachable())
        //=--------------------------------------=
        let major = Element.bitWidth
        let minor = Element.Magnitude(load: Base.Element.bitWidth.load(as: UX.self))
        let value = major &>> minor.count(0, option: Bit.Selection.ascending)
        return value.load(as: IX.self).stdlib
    }
}
