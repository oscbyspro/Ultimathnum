//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Exchange Int x Succinct x Bit Pattern
//*============================================================================*

extension ExchangeInt where Element == Element.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func succinct() -> Prefix {
        self.prefix(BitPattern.count(trimming: self.base, repeating: self.extension.bit))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
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

extension ExchangeInt.Equal where Element == Element.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func count(trimming base: Base, repeating bit: Bit) -> Int {
        //=--------------------------------------=
        precondition(ExchangeInt.comparison == Signum.same, String.unreachable())
        //=--------------------------------------=
        let sign = Base.Element(repeating: bit)
        return self.count(chunking: base.reversed().trimmingPrefix(while:{ $0 == sign }))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Minor
//=----------------------------------------------------------------------------=

extension ExchangeInt.Minor where Element == Element.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func count(trimming base: Base, repeating bit: Bit) -> Int {
        //=--------------------------------------=
        precondition(ExchangeInt.comparison == Signum.less, String.unreachable())
        //=--------------------------------------=
        let sign = Base.Element(repeating: bit)
        let majorSuffix = base.reversed().prefix(while:{ $0 == sign })
        let minorSuffix = base.dropLast(majorSuffix.count).last?.count(bit, option: Bit.Selection.descending) ?? (0000)
        let totalSuffix = IX(majorSuffix.count) * Base.Element.bitWidth.load(as: IX.self) + minorSuffix.load(as: IX.self)
        return (IX(self.count(chunking: base)) - totalSuffix / Element.bitWidth.load(as: IX.self)).stdlib
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Major
//=----------------------------------------------------------------------------=

extension ExchangeInt.Major where Element == Element.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func count(trimming base: Base, repeating bit: Bit) -> Int {
        //=--------------------------------------=
        precondition(ExchangeInt.comparison == Signum.more, String.unreachable())
        //=--------------------------------------=
        let sign = Base.Element(repeating: bit)
        return self.count(chunking: base.reversed().trimmingPrefix(while:{ $0 == sign }))
    }
}
