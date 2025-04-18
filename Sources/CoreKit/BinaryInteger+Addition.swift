//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Addition
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the additive inverse of `instance` by trapping on `error`.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public static prefix func -(instance: consuming Self) -> Self {
        instance.negated().unwrap()
    }
    
    /// Returns `lhs + rhs` by trapping on `error`.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public static func +(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.plus(rhs).unwrap()
    }
    
    /// Returns `lhs - rhs` by trapping on `error`.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public static func -(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.minus(rhs).unwrap()
    }
    
    /// Returns `lhs + rhs` by wrapping on `error`.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public static func &+(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.plus(rhs).value
    }
    
    /// Returns `lhs - rhs` by wrapping on `error`.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public static func &-(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.minus(rhs).value
    }
    
    /// Forms `lhs + rhs` by trapping on `error`.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public static func +=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs + rhs
    }
    
    /// Forms `lhs - rhs` by trapping on `error`.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public static func -=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs - rhs
    }
    
    /// Forms `lhs + rhs` by wrapping on `error`.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public static func &+=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs &+ rhs
    }
    
    /// Forms `lhs - rhs` by wrapping on `error`.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public static func &-=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs &- rhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the additive inverse of `self` and an `error` indicator.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public mutating func negate() -> Fallible<Void> {
        let error: Bool
        (self, error) = self.negated().components()
        return Fallible(Void(), error: error)
    }
    
    /// Returns the additive inverse of `self` and an `error` indicator.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public consuming func negated() -> Fallible<Self> {
        let result: Fallible<Self> = self.complement(true)
        return result.value.veto(result.error == Self.isSigned)
    }
    
    /// Returns `self` or `self + 1` and an `error` indicator.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public consuming func incremented(_ condition: Bool = true) -> Fallible<Self> {
        self.plus(Self(Bit(condition)))
    }
    
    /// Returns `self` or `self - 1` and an `error` indicator.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public consuming func decremented(_ condition: Bool = true) -> Fallible<Self> {
        self.minus(Self(Bit(condition)))
    }
    
    /// Returns `self + self` and an `error` indicator.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public consuming func doubled() -> Fallible<Self> {
        if !Self.isArbitrary {
            return self.times(2)
            
        }   else {
            let error: Bool = ((self.isInfinite))
            return self.up(Shift.one).veto(error)
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Addition x Lenient
//*============================================================================*

extension BinaryInteger where Self: ArbitraryInteger & SignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the additive inverse of `self`.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public mutating func negate() {
        self.negate().unchecked()
    }
    
    /// Returns the additive inverse of `self`.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public consuming func negated() -> Self {
        self.negated().unchecked()
    }
    
    /// Returns `self + other`.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public consuming func plus(_ other: borrowing Self) -> Self {
        self.plus(other).unchecked()
    }
    
    /// Returns `self - other`.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public consuming func minus(_ other: borrowing Self) -> Self {
        self.minus(other).unchecked()
    }
    
    /// Returns `self` or `self + 1`.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public consuming func incremented(_ condition: Bool = true) -> Self {
        self.incremented(condition).unchecked()
    }
    
    /// Returns `self` or `self - 1`.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public consuming func decremented(_ condition: Bool = true) -> Self {
        self.decremented(condition).unchecked()
    }
        
    /// Returns `self + self`.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public consuming func doubled() -> Self {
        self.doubled().unchecked()
    }
}

//*============================================================================*
// MARK: * Binary Integer x Addition x Systems
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns `self + (other + bit)` and an `error` indicator.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public consuming func plus(_ other: borrowing Self, plus bit: Bool) -> Fallible<Self> {
        //  TODO: await consuming fixes
        let (a, x) = self.plus((other)).components()
        let (b, y) = a.incremented(bit).components()
        return b.veto(x != y)
    }
    
    /// Returns `self - (other + bit)` and an `error` indicator.
    ///
    /// ### Addition & Subtraction
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public consuming func minus(_ other: borrowing Self, plus bit: Bool) -> Fallible<Self> {
        //  TODO: await consuming fixes
        let (a, x) = self .minus(other).components()
        let (b, y) = a.decremented(bit).components()
        return b.veto(x != y)
    }
}
