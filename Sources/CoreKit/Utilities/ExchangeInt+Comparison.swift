//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Exchange Int x Comparison
//*============================================================================*

extension ExchangeInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==<T, U>(lhs: Self, rhs: ExchangeInt<T, U>) -> Bool {
        lhs.compared(to: rhs) == Signum.same
    }
    
    @inlinable public static func < <T, U>(lhs: Self, rhs: ExchangeInt<T, U>) -> Bool {
        lhs.compared(to: rhs) == Signum.less
    }
    
    @inlinable public func compared<T, U>(to other: ExchangeInt<T, U>) -> Signum {
        BitPattern.compare(self.bitPattern, isSigned: Self.isSigned, to: other.chunked(), isSigned: ExchangeInt<T, U>.isSigned)
    }
}

//*============================================================================*
// MARK: * Exchange Int x Comparison x Bit Pattern
//*============================================================================*

extension ExchangeInt where Element == Element.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inline(never) @inlinable internal static func compare<T>(
    _  lhs: Self, isSigned lhsIsSigned: Bool,
    to rhs: ExchangeInt<T, Element>, isSigned rhsIsSigned: Bool) -> Signum {
        //=--------------------------------------=
        typealias LHS = Self
        typealias RHS = ExchangeInt<T, Element>
        //=--------------------------------------=
        let lhsAppendix = Bool(bitPattern: lhs.extension.bit)
        let rhsAppendix = Bool(bitPattern: rhs.extension.bit)
        //=--------------------------------------=
        // comparison: appendix
        //=--------------------------------------=
        if  lhsAppendix != rhsAppendix {
            return Signum.one(Sign(bitPattern: lhsAppendix && lhsIsSigned || rhsAppendix && rhsIsSigned))
        }
        //=--------------------------------------=
        // comparison: succinct count
        //=--------------------------------------=
        let lhsSuccinctCount  = LHS.count(trimming: lhs.base, repeating: Bit(bitPattern: lhsAppendix))
        let rhsSuccinctCount  = RHS.count(trimming: rhs.base, repeating: Bit(bitPattern: rhsAppendix))
        //=--------------------------------------=
        if  lhsSuccinctCount != rhsSuccinctCount {
            return Signum.one(Sign(bitPattern: lhsAppendix == ((lhsSuccinctCount) > (rhsSuccinctCount))))
        }
        //=--------------------------------------=
        // comparison: elements, back to front
        //=--------------------------------------=
        for index in (Int.zero ..< lhsSuccinctCount).reversed() {
            
            let lhsElement: Element = lhs[index]
            let rhsElement: Element = rhs[index]
            
            if  lhsElement != rhsElement {
                return Signum.one(Sign(bitPattern: lhsElement < rhsElement))
            }
        }
        //=--------------------------------------=
        // comparison: now we know they are equal
        //=--------------------------------------=
        return Signum.same as Signum as Signum as Signum
    }
}
