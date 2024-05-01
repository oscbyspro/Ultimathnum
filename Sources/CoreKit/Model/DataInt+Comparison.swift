//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Comparison
//*============================================================================*

extension DataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable package static func signum(of instance: Self, isSigned: Bool) -> Signum {
        //=--------------------------------------=
        // comparison: appendix
        //=--------------------------------------=
        if  Bool(instance.appendix) {
            return Signum.one(Sign(raw: isSigned))
        }
        //=--------------------------------------=
        // comparison: body
        //=--------------------------------------=
        return Signum(Bit(instance.body.isZero))
    }
    
    @inlinable package static func compare(
        lhs: consuming Self, lhsIsSigned: Bool,
        rhs: consuming Self, rhsIsSigned: Bool
    )   -> Signum {
        //=--------------------------------------=
        // comparison: appendix
        //=--------------------------------------=
        if  lhs.appendix != rhs.appendix {
            return Signum.one(Sign(raw: Bool(lhs.appendix) ? lhsIsSigned : !rhsIsSigned))
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
            return Signum.one(Sign(raw: lhs.appendix == Bit(lhs.body.count > rhs.body.count)))
        }
        //=--------------------------------------=
        // comparison: body
        //=--------------------------------------=
        var index = lhs.body.count; while index > IX.zero {
            index = index - 1
            
            let lhsElement: Element = lhs.body[unchecked: index]
            let rhsElement: Element = rhs.body[unchecked: index]
            
            if  lhsElement != rhsElement {
                return Signum.one(Sign(raw: lhsElement < rhsElement))
            }
        }
        //=--------------------------------------=
        // comparison: same
        //=--------------------------------------=
        return Signum.same as Signum as Signum as Signum
    }
}

//*============================================================================*
// MARK: * Data Int x Comparison x Body
//*============================================================================*

extension SomeDataIntBody {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var isZero: Bool {
        self.buffer().allSatisfy({ $0 == Element.zero })
    }
    
    @inlinable public func compared(to other: some SomeDataIntBody<Element>) -> Signum {
        DataInt.compare(
            lhs: DataInt(self),
            lhsIsSigned: false,
            rhs: DataInt(other),
            rhsIsSigned: false
        )
    }
}
