//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Sequence Int x Count
//*============================================================================*

extension SequenceInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func count(of base: Base) -> Int {
        switch comparison {
        case Signum.same: return Equal.count(of: base)
        case Signum.less: return Minor.count(of: base)
        case Signum.more: return Major.count(of: base)
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
    
    @inlinable internal static func count(of base: some Collection<Base.Element>) -> Int {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.same, String.unreachable())
        //=--------------------------------------=
        return base.count as Int as Int as Int
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Minor
//=----------------------------------------------------------------------------=

extension SequenceInt.Minor {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable internal static func count(of base: some Collection<Base.Element>) -> Int {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.less, String.unreachable())
        //=--------------------------------------=
        return base.count * self.ratio as Int
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Major
//=----------------------------------------------------------------------------=

extension SequenceInt.Major {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func count(of base: some Collection<Base.Element>) -> Int {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.more, String.unreachable())
        //=--------------------------------------=
        let dividend  = base.count
        let quotient  = dividend &>> self.ratio.trailingZeroBitCount
        let remainder = dividend &  (self.ratio - 1)
        return quotient + (remainder > 0 ? 1 : 0)
    }
}
