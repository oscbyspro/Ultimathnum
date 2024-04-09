//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Memory Int x Comparison
//*============================================================================*

extension MemoryInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable package static func signum(of instance: Self, isSigned: Bool) -> Signum {
        //=--------------------------------------=
        // comparison: appendix
        //=--------------------------------------=
        if  Bool(instance.appendix) {
            return Signum.one(Sign(bitPattern: isSigned))
        }
        //=--------------------------------------=
        // comparison: succinct count
        //=--------------------------------------=
        let body = UnsafeBufferPointer(start: instance.body.start, count: Int(instance.body.count))
        return Signum(Bit(!body.allSatisfy({ $0 == 0 })))
    }
    
    @inlinable package static func compare(
        lhs: consuming Self, lhsIsSigned: Bool,
        rhs: consuming Self, rhsIsSigned: Bool
    )   -> Signum {
        //=--------------------------------------=
        // comparison: appendix
        //=--------------------------------------=
        if  lhs.appendix != rhs.appendix {
            return Signum.one(Sign(bitPattern: Bool(lhs.appendix) ? lhsIsSigned : !rhsIsSigned))
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        lhs = lhs.normalized()
        rhs = rhs.normalized()
        //=--------------------------------------=
        // comparison: count
        //=--------------------------------------=
        if  lhs.body.count != rhs.body.count {
            return Signum.one(Sign(bitPattern: lhs.appendix == Bit(lhs.body.count > rhs.body.count)))
        }
        //=--------------------------------------=
        // comparison: body
        //=--------------------------------------=
        var index = lhs.body.count; while index > IX.zero {
            index = index - 1
            
            let lhsElement: Element = lhs.body.start[Int(index)]
            let rhsElement: Element = rhs.body.start[Int(index)]
            
            if  lhsElement != rhsElement {
                return Signum.one(Sign(bitPattern: lhsElement < rhsElement))
            }
        }
        //=--------------------------------------=
        // comparison: same
        //=--------------------------------------=
        return Signum.same as Signum as Signum as Signum
    }
}
