//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Exchange Int x Source x Bit Pattern
//*============================================================================*

extension ExchangeInt where Element == Element.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func source() -> Prefix {
        self.prefix(BitPattern.count(chunking: self.base))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func count(chunking base: Base) -> Int {
        switch comparison {
        case Signum.same: Equal.count(chunking: base)
        case Signum.less: Minor.count(chunking: base)
        case Signum.more: Major.count(chunking: base)
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
    
    @inlinable internal static func count(chunking base: some Collection<Base.Element>) -> Int {
        //=--------------------------------------=
        precondition(ExchangeInt.comparison == Signum.same, String.unreachable())
        //=--------------------------------------=
        return base.count as Int as Int as Int
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Minor
//=----------------------------------------------------------------------------=

extension ExchangeInt.Minor where Element == Element.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable internal static func count(chunking base: some Collection<Base.Element>) -> Int {
        //=--------------------------------------=
        precondition(ExchangeInt.comparison == Signum.less, String.unreachable())
        //=--------------------------------------=
        return base.count * self.ratio as Int
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Major
//=----------------------------------------------------------------------------=

extension ExchangeInt.Major where Element == Element.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func count(chunking base: some Collection<Base.Element>) -> Int {
        //=--------------------------------------=
        precondition(ExchangeInt.comparison == Signum.more, String.unreachable())
        //=--------------------------------------=
        let dividend  = base.count
        let quotient  = dividend &>> self.ratio.trailingZeroBitCount
        let remainder = dividend &  (self.ratio - 1)
        //=--------------------------------------=
        return quotient + (remainder > 0 as Int ? 1 as Int : 0 as Int)
    }
}
