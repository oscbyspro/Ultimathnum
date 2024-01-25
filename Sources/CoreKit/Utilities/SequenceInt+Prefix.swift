//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Sequence Int x Prefix
//*============================================================================*

extension SequenceInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func prefix(_ count: Int) -> Self {
        precondition(count >= 0, String.indexOutOfBounds())
        self.count = count
        return consume self
    }
    
    @inlinable consuming public func prefix(minLength: Int) -> Self {
        self.count = Swift.max(self.count,  minLength)
        return consume self
    }
    
    @inlinable consuming public func prefix(maxLength: Int) -> Self {
        self.count = Swift.min(self.count,  maxLength)
        return consume self
    }
    
    @inlinable public func succinct() -> Self {
        self.prefix(Self.count(trimming: self.base, repeating: self.extension.bit))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func count(trimming base: Base, repeating bit: Bit) -> Int {
        switch comparison {
        case Signum.same: return Equal.count(trimming: base, repeating: bit)
        case Signum.less: return Minor.count(trimming: base, repeating: bit)
        case Signum.more: return Major.count(trimming: base, repeating: bit)
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
    
    @inlinable internal static func count(trimming base: Base, repeating bit: Bit) -> Int {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.same, String.unreachable())
        //=--------------------------------------=
        let sign = Base.Element(repeating: bit)
        return self.count(of: base.reversed().trimmingPrefix(while:{ $0 == sign }))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Minor
//=----------------------------------------------------------------------------=

extension SequenceInt.Minor {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func count(trimming base: Base, repeating bit: Bit) -> Int {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.less, String.unreachable())
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

extension SequenceInt.Major {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func count(trimming base: Base, repeating bit: Bit) -> Int {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.more, String.unreachable())
        //=--------------------------------------=
        let sign = Base.Element(repeating: bit)
        return self.count(of: base.reversed().trimmingPrefix(while:{ $0 == sign }))
    }
}
