//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Exchange Int x Count
//*============================================================================*

extension ExchangeInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func source() -> Prefix {
        self.prefix(Self.count(of: self.base))
    }
    
    @inlinable internal static func count(of base: Base) -> Int {
        switch comparison {
        case Signum.same: Equal.count(of: base)
        case Signum.less: Minor.count(of: base)
        case Signum.more: Major.count(of: base)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Equal
//=----------------------------------------------------------------------------=

extension ExchangeInt.Equal {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func count(of base: some Collection<Base.Element>) -> Int {
        //=--------------------------------------=
        precondition(ExchangeInt.comparison == Signum.same, String.unreachable())
        //=--------------------------------------=
        return base.count as Int as Int as Int
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Minor
//=----------------------------------------------------------------------------=

extension ExchangeInt.Minor {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable internal static func count(of base: some Collection<Base.Element>) -> Int {
        //=--------------------------------------=
        precondition(ExchangeInt.comparison == Signum.less, String.unreachable())
        //=--------------------------------------=
        return base.count * self.ratio as Int
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Major
//=----------------------------------------------------------------------------=

extension ExchangeInt.Major {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func count(of base: some Collection<Base.Element>) -> Int {
        //=--------------------------------------=
        precondition(ExchangeInt.comparison == Signum.more, String.unreachable())
        //=--------------------------------------=
        let dividend  = base.count
        let quotient  = dividend &>> self.ratio.trailingZeroBitCount
        let remainder = dividend &  (self.ratio - 1)
        return quotient + (remainder > 0 ? 1 : 0)
    }
}
