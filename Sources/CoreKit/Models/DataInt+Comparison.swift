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
    
    /// Performs a three-way comparson of `instance` versus `zero` where the mode
    /// of the `instance` is determined by `isSigned`.
    ///
    @inline(never) @inlinable public static func signum(of instance: Self, isSigned: Bool) -> Signum {
        //=--------------------------------------=
        // comparison: appendix
        //=--------------------------------------=
        if  Bool(instance.appendix) {
            return Signum.one(Sign(raw: isSigned))
        }
        //=--------------------------------------=
        // comparison: body
        //=--------------------------------------=
        return instance.body.signum()
    }
    
    /// Performs a three-way comparson of `lhs` versus `rhs` where the mode
    /// of each instance is determined by `lhsIsSigned` and `rhsIsSigned`.
    ///
    @inline(never) @inlinable public static func compare(
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
        // comparison: size
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
        // comparison: negative vs infinite
        //=--------------------------------------=
        if  lhsIsSigned != rhsIsSigned && Bool(lhs.appendix) {
            return Signum.one(Sign(lhsIsSigned))
        }
        //=--------------------------------------=
        // comparison: same
        //=--------------------------------------=
        return Signum.same as Signum as Signum as Signum
    }
}

//*============================================================================*
// MARK: * Data Int x Comparison x Read|Body
//*============================================================================*

extension DataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var isZero: Bool {
        self.buffer().allSatisfy({ $0 == Element.zero })
    }
    
    @inlinable public func signum() -> Signum {
        Signum(Bit(!self.isZero))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func compared(to other: Self) -> Signum {
        DataInt.compare(
            lhs: DataInt(self ), lhsIsSigned: false,
            rhs: DataInt(other), rhsIsSigned: false
        )
    }
    
    @inlinable public func compared(to other: Mutable) -> Signum {
        self.compared(to: Self(other))
    }
}

//*============================================================================*
// MARK: * Data Int x Comparison x Read|Write|Body
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var isZero: Bool {
        Immutable(self).isZero
    }
        
    @inlinable public func signum() -> Signum {
        Immutable(self).signum()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func compared(to other: Self) -> Signum {
        self.compared(to: Immutable(other))
    }
    
    @inlinable public func compared(to other: Immutable) -> Signum {
        Immutable(self).compared(to: other)
    }
}
