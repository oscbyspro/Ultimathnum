//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Sequence Int x Ratio
//*============================================================================*

extension SequenceInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static var comparison: Signum {
        Element.bitWidth.load(as: UX.self).compared(to: Base.Element.bitWidth.load(as: UX.self))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Minor
//=----------------------------------------------------------------------------=

extension SequenceInt.Minor {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static var ratio: Int {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.less, String.unreachable())
        //=--------------------------------------=
        let major = Base.Element.bitWidth
        let minor = Base.Element.Magnitude(load: Element.bitWidth.load(as: UX.self))
        return (major &>> minor.count(0, option: .ascending)).load(as: Int.self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Major
//=----------------------------------------------------------------------------=

extension SequenceInt.Major {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static var ratio: Int {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.more, String.unreachable())
        //=--------------------------------------=
        let major = Element.bitWidth
        let minor = Element.Magnitude(load: Base.Element.bitWidth.load(as: UX.self))
        return (major &>> minor.count(0, option: .ascending)).load(as: Int.self)
    }
}
