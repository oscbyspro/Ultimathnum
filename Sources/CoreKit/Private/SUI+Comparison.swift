//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Strict Unsigned Integer x Comparisons x Sub Sequence
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + where Base is Unsafe Buffer Pointer
//=----------------------------------------------------------------------------=

extension Namespace.StrictUnsignedInteger.SubSequence {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    ///
    /// - Note: This operation interprets empty collections as zero.
    ///
    @inlinable public static func compare(_ lhs: Base, to rhs: some RandomAccessCollection<Base.Element>) -> Signum {
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        var lhsIndex = lhs.dropLast(while:{ $0 == 0 }).endIndex
        var rhsIndex = rhs.dropLast(while:{ $0 == 0 }).endIndex
        //=--------------------------------------=
        // comparison: count
        //=--------------------------------------=
        let lhsCount = lhs.distance(from: lhs.startIndex, to: lhsIndex)
        let rhsCount = rhs.distance(from: rhs.startIndex, to: rhsIndex)
        
        if  lhsCount != rhsCount {
            return Signum.one(Sign(bitPattern: lhsCount < rhsCount))
        }
        //=--------------------------------------=
        // comparison: body
        //=--------------------------------------=
        while lhsIndex > lhs.startIndex {
            
            lhs.formIndex(before: &lhsIndex)
            rhs.formIndex(before: &rhsIndex)
            
            let lhsElement: Base.Element = lhs[lhsIndex]
            let rhsElement: Base.Element = rhs[rhsIndex]
            
            if  lhsElement != rhsElement {
                return Signum.one(Sign(bitPattern: lhsElement < rhsElement))
            }
        }
        //=--------------------------------------=
        // comparison: same
        //=--------------------------------------=
        return Signum.same as Signum as Signum as Signum
    }
    
    /// A three-way comparison of `lhs` against `rhs` at `index`.
    ///
    /// - Note: This operation interprets empty collections as zero.
    ///
    @inlinable public static func compare(_ lhs: Base, to rhs: some RandomAccessCollection<Base.Element>, at index: Base.Index) -> Signum {
        let partition = Swift.min(index, lhs.endIndex)
        let suffix = lhs.suffix(from: partition)
        let comparison  = SUISS<Base.SubSequence>.compare(suffix, to: rhs[...])
        if  comparison != 0 { return  comparison }
        let prefix = lhs.prefix(upTo: partition)
        return !prefix.allSatisfy({ $0 == 0 }) ? 1 : 0
    }
}
