//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Exchange Int x Prefix
//*============================================================================*

extension ExchangeInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func succinct() -> Prefix {
        self.prefix(Self.count(trimming: self.base, repeating: self.extension.bit))
    }
    
    @inlinable internal static func count(trimming base: Base, repeating bit: Bit) -> Int {
        switch comparison {
        case Signum.same: Equal.count(trimming: base, repeating: bit)
        case Signum.less: Minor.count(trimming: base, repeating: bit)
        case Signum.more: Major.count(trimming: base, repeating: bit)
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
    
    @inlinable internal static func count(trimming base: Base, repeating bit: Bit) -> Int {
        //=--------------------------------------=
        precondition(ExchangeInt.comparison == Signum.same, String.unreachable())
        //=--------------------------------------=
        let sign = Base.Element(repeating: bit)
        return self.count(of: base.reversed().trimmingPrefix(while:{ $0 == sign }))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Minor
//=----------------------------------------------------------------------------=

extension ExchangeInt.Minor {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func count(trimming base: Base, repeating bit: Bit) -> Int {
        //=--------------------------------------=
        precondition(ExchangeInt.comparison == Signum.less, String.unreachable())
        //=--------------------------------------=
        let sign = Base.Element(repeating: bit)
        let majorSuffix = base.reversed().prefix(while:{ $0 == sign })
        let minorSuffix = base.dropLast(majorSuffix.count).last?.count(bit, option: Bit.Selection.descending) ?? (00000)
        let totalSuffix = majorSuffix.count *  Base.Element.bitWidth.load(as: Int.self) + minorSuffix.load(as: Int.self)
        return self.count(of: base) - totalSuffix / Element.bitWidth.load(as: Int.self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Major
//=----------------------------------------------------------------------------=

extension ExchangeInt.Major {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func count(trimming base: Base, repeating bit: Bit) -> Int {
        //=--------------------------------------=
        precondition(ExchangeInt.comparison == Signum.more, String.unreachable())
        //=--------------------------------------=
        let sign = Base.Element(repeating: bit)
        return self.count(of: base.reversed().trimmingPrefix(while:{ $0 == sign }))
    }
}
