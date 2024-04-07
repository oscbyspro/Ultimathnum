//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int
//*============================================================================*

extension DataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func signum(of instance: borrowing Self, isSigned: Bool) -> Signum {
        //=--------------------------------------=
        // comparison: appendix
        //=--------------------------------------=
        if  Bool(instance.appendix) {
            return Signum.one(Sign(bitPattern: isSigned))
        }
        //=--------------------------------------=
        // comparison: succinct count
        //=--------------------------------------=
        
        let buffer = UnsafeRawBufferPointer(start: instance.start, count: Int(instance.count))
        return Signum(Bit(!buffer.allSatisfy({ $0 == 0 })))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func comparison(
        lhs: consuming Self, lhsIsSigned: consuming Bool,
        rhs: consuming Self, rhsIsSigned: consuming Bool
    )   -> Signum {
        //=--------------------------------------=
        // comparison: appendix
        //=--------------------------------------=
        if  lhs.appendix != rhs.appendix {
            return Signum.one(Sign(bitPattern: Bool(lhs.appendix) ? lhsIsSigned : !rhsIsSigned))
        }
        //=--------------------------------------=
        return Self.comparisonSameAppendix(
            lhs: lhs, lhsIsSigned: lhsIsSigned,
            rhs: rhs, rhsIsSigned: rhsIsSigned
        )
    }
    
    @inlinable public static func comparisonSameAppendix(
        lhs: consuming Self, lhsIsSigned: consuming Bool,
        rhs: consuming Self, rhsIsSigned: consuming Bool
    )   -> Signum {
        //=--------------------------------------=
        Swift.assert(lhs.appendix == rhs.appendix)
        //=--------------------------------------=
        // comparison: normalized count
        //=--------------------------------------=
        lhs = lhs.normalized()
        rhs = rhs.normalized()
        //=--------------------------------------=
        if  lhs.count != rhs.count {
            return Signum.one(Sign(Bool(lhs.appendix) == (lhs.count > rhs.count)))
        }
        //=--------------------------------------=
        return Self.comparisonSameAppendixSameCount(
            lhs: lhs, lhsIsSigned: lhsIsSigned,
            rhs: rhs, rhsIsSigned: rhsIsSigned
        )
    }
    
    @inlinable public static func comparisonSameAppendixSameCount(
        lhs: consuming Self, lhsIsSigned: consuming Bool,
        rhs: consuming Self, rhsIsSigned: consuming Bool
    )   -> Signum {
        //=--------------------------------------=
        Swift.assert(lhs.appendix == rhs.appendix)
        Swift.assert(lhs.count    == rhs.count   )
        //=--------------------------------------=
        // comparison: elements, back to front
        //=--------------------------------------=
        var index = lhs.count; while index > 0 {
            index = index - 1
            
            let lhsElement: Element = lhs[index]
            let rhsElement: Element = rhs[index]
            
            if  lhsElement != rhsElement {
                return Signum.one(Sign(bitPattern: lhsElement < rhsElement))
            }
        }
        //=--------------------------------------=
        return Signum.same as Signum as Signum
    }
}
