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
    
    /// Indicates whether this value is equal to zero.
    ///
    /// - Note: This comparison is performed backwards.
    ///
    @inlinable public var isZero: Bool {
        !Bool(self.appendix) && self.body.isZero
    }
    
    /// Indicates whether the `body` is free of `appendix` extensions.
    @inlinable public var isNormal: Bool {
        self.body.last != self.last
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension DataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Performs a three-way comparson of `instance` versus `zero` where the mode
    /// of the `instance` is determined by `isSigned`.
    ///
    /// ### Development
    ///
    /// - TODO: Consider adding a static or dynamic mode to this model (#104).
    ///
    @inline(never) @inlinable public static func signum(
        of instance: Self, mode signedness: Signedness
    )   -> Signum {
        //=--------------------------------------=
        // comparison: appendix
        //=--------------------------------------=
        if  Bool(instance.appendix) {
            return Signum(Sign(raw: signedness)) // - < 0, ∞ > 0
        }
        //=--------------------------------------=
        // comparison: body
        //=--------------------------------------=
        return instance.body.signum()
    }
    
    /// Performs a three-way comparson of `lhs` versus `rhs` where the mode
    /// of each instance is determined by `lhsSignedness` and `rhsSignedness`.
    ///
    /// ### Development
    ///
    /// - TODO: Consider adding a static or dynamic mode to this model (#104).
    ///
    @inline(never) @inlinable public static func compare(
        lhs: consuming Self, mode lhsSignedness: Signedness,
        rhs: consuming Self, mode rhsSignedness: Signedness
    )   -> Signum {
        //=--------------------------------------=
        // comparison: appendix
        //=--------------------------------------=
        if  lhs.appendix != rhs.appendix {
            let sign = Bool(lhs.appendix)
            ? lhsSignedness ==   .signed // - < ℕ or ∞ > ℕ
            : rhsSignedness == .unsigned // ℕ < ∞ or ℕ > -
            return Signum(Sign(sign))
        }
        //=--------------------------------------=
        // comparison: negative vs infinite
        //=--------------------------------------=
        if  lhsSignedness != rhsSignedness {
            if  Bool(lhs.appendix) {
                return Signum(Sign(raw: lhsSignedness)) // - < ∞ or ∞ > -
            }
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
            //
            //  0|0... is less than 1|0... because (0s)...
            //  0|1... is less than 1|1... because ...(1s)
            //
            let appendix = Bool(lhs.appendix)
            let order = lhs.body.count > rhs.body.count
            return Signum(Sign(appendix == order))
        }
        //=--------------------------------------=
        // comparison: body
        //=--------------------------------------=
        var index = lhs.body.count
        while index > .zero {
            index = index.decremented().unchecked()
            
            let lhsElement: Element = lhs.body[unchecked: index]
            let rhsElement: Element = rhs.body[unchecked: index]
            //
            //  0|0... is less than 1|0... because (0s)...
            //  0|1... is less than 1|1... because ...(1s)
            //
            if  lhsElement != rhsElement {
                return Signum(Sign(lhsElement < rhsElement))
            }
        }
        //=--------------------------------------=
        // comparison: same
        //=--------------------------------------=
        return Signum.zero // as Signum as Signum
    }
    
    /// Performs a three-way comparson of `lhs` versus `rhs` where the mode
    /// of each instance is determined by `lhsSignedness` and `rhsSignedness`.
    ///
    /// ### Development
    ///
    /// - TODO: Consider adding a static or dynamic mode to this model (#104).
    ///
    @inlinable public static func compare<OtherElement>(
        lhs: consuming Self,
        mode lhsSignedness: Signedness,
        rhs: consuming DataInt<OtherElement>,
        mode rhsSignedness: Signedness
    )   -> Signum {
        
        if  Self.Element.size <= OtherElement.size {
            rhs.reinterpret(as:  Self.Element.self) { rhs in
                DataInt<Self.Element>.compare(
                    lhs: lhs, mode: lhsSignedness,
                    rhs: rhs, mode: rhsSignedness
                )
            }
            
        }   else {
            lhs.reinterpret(as:  OtherElement.self) { lhs in
                DataInt<OtherElement>.compare(
                    lhs: lhs, mode: lhsSignedness,
                    rhs: rhs, mode: rhsSignedness
                )
            }
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Comparison x Read|Body
//*============================================================================*

extension DataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Indicates whether this value is equal to zero.
    ///
    /// - Note: This comparison is performed backwards.
    ///
    @inlinable public var isZero: Bool {
        self.buffer().reversed().allSatisfy({ $0.isZero })
    }
    
    /// Indicates whether the `body` is free of `appendix` extensions.
    ///
    /// - Note: The `appendix` of a binary integer `body` is always `zero`.
    ///
    @inlinable public var isNormal: Bool {
        DataInt(self).isNormal
    }
    
    /// Indicates whether this buffer is empty.
    ///
    /// An empty buffer lacks valid subscript arguments.
    ///
    /// - Invariant: `self.isEmpty == self.count.isZero`
    ///
    @inlinable public var isEmpty: Bool {
        self.count.isZero
    }
    
    /// Performs a three-way comparison of `self` versus `zero`.
    @inlinable public func signum() -> Signum {
        Signum(Bit(!self.isZero))
    }
    
    /// Performs a three-way comparison of `self` versus `other`.
    @inlinable public func compared(to other: Self) -> Signum {
        DataInt.compare(
            lhs: DataInt(self ), mode: .unsigned,
            rhs: DataInt(other), mode: .unsigned
        )
    }
    
    /// Performs a three-way comparison of `self` versus `other`.
    @inlinable public func compared(to other: Mutable) -> Signum {
        self.compared(to: Self(other))
    }
}

//*============================================================================*
// MARK: * Data Int x Comparison x Read|Write|Body
//*============================================================================*

extension MutableDataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Indicates whether this value is equal to zero.
    @inlinable public var isZero: Bool {
        Immutable(self).isZero
    }
    
    /// Indicates whether the `body` is free of `appendix` extensions.
    @inlinable public var isNormal: Bool {
        Immutable(self).isNormal
    }
}

//*============================================================================*
// MARK: * Data Int x Comparison x Read|Write|Body
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
        
    /// Indicates whether this value is equal to zero.
    @inlinable public var isZero: Bool {
        Immutable(self).isZero
    }
    
    /// Indicates whether the `body` is free of `appendix` extensions.
    ///
    /// - Note: The `appendix` of a binary integer `body` is always `zero`.
    ///
    @inlinable public var isNormal: Bool {
        Immutable(self).isNormal
    }
    
    /// Indicates whether this buffer is empty.
    ///
    /// An empty buffer lacks valid subscript arguments.
    ///
    /// - Invariant: `self.isEmpty == self.count.isZero`
    ///
    @inlinable public var isEmpty: Bool {
        Immutable(self).isEmpty
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Performs a three-way comparison of `self` versus `zero`.
    @inlinable public func signum() -> Signum {
        Immutable(self).signum()
    }
    
    /// Performs a three-way comparison of `self` versus `other`.
    @inlinable public func compared(to other: Self) -> Signum {
        self.compared(to: Immutable(other))
    }
    
    /// Performs a three-way comparison of `self` versus `other`.
    @inlinable public func compared(to other: Immutable) -> Signum {
        Immutable(self).compared(to: other)
    }
}
