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
    @inlinable public static prefix func -(instance: consuming Self) -> Self {
        instance.negated().unwrap()
    }
    
    /// Returns the trapping result of `lhs + rhs`.
    @inlinable public static func +(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.plus(rhs).unwrap()
    }
    
    /// Returns the trapping result of `lhs - rhs`.
    @inlinable public static func -(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.minus(rhs).unwrap()
    }
    
    /// Returns the wrapping result of `lhs + rhs`.
    @inlinable public static func &+(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.plus(rhs).value
    }
    
    /// Returns the wrapping result of `lhs - rhs`.
    @inlinable public static func &-(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.minus(rhs).value
    }
    
    /// Forms the trapping result of `lhs + rhs`.
    @inlinable public static func +=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs + rhs
    }
    
    /// Forms the trapping result of `lhs - rhs`.
    @inlinable public static func -=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs - rhs
    }
    
    /// Forms the wrapping result of `lhs + rhs`.
    @inlinable public static func &+=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs &+ rhs
    }
    
    /// Forms the wrapping result of `lhs - rhs`.
    @inlinable public static func &-=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs &- rhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the additive inverse of `self` and an `error` indicator.
    @inlinable public mutating func negate() -> Fallible<Void> {
        let error: Bool
        (self, error) = self.negated().components()
        return Fallible(Void(), error: error)
    }
    
    /// Returns the additive inverse of `self` and an `error` indicator.
    @inlinable public consuming func negated() -> Fallible<Self> {
        let result: Fallible<Self> = self.complement(true)
        return result.value.veto(result.error == Self.isSigned)
    }
    
    /// The next value in arithmetic progression.
    @inlinable public consuming func incremented(_ condition: Bool = true) -> Fallible<Self> {
        self.plus(Self(Bit(condition)))
    }
    
    /// The next value in arithmetic progression.
    @inlinable public consuming func decremented(_ condition: Bool = true) -> Fallible<Self> {
        self.minus(Self(Bit(condition)))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the result of `self + other` that fits.
    @inlinable public consuming func plus(_ other: borrowing Fallible<Self>) -> Fallible<Self> {
        self.plus(other.value).veto(other.error)
    }
    
    /// Returns the result of `self - other` that fits.
    @inlinable public consuming func minus(_ other: borrowing Fallible<Self>) -> Fallible<Self> {
        self.minus(other.value).veto(other.error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

extension Fallible where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the additive inverse of `self` and an `error` indicator.
    @inlinable public consuming func negated() -> Self {
        self.value.negated().veto(self.error)
    }
    
    /// Returns the result of `self + other`.
    @inlinable public consuming func plus(_ other: borrowing Value) -> Self {
        self.value.plus(other).veto(self.error)
    }
    
    /// Returns the result of `self - other`.
    @inlinable public consuming func minus(_ other: borrowing Value) -> Self {
        self.value.minus(other).veto(self.error)
    }
    
    /// Returns the result of `self + other`.
    @inlinable public consuming func plus(_ other: borrowing Fallible<Value>) -> Self {
        self.value.plus(other).veto(self.error)
    }
    
    /// Returns the result of `self - other`.
    @inlinable public consuming func minus(_ other: borrowing Fallible<Value>) -> Self {
        self.value.minus(other).veto(self.error)
    }
    
    /// Returns the next value in arithmetic progression.
    @inlinable public consuming func incremented(_ condition: Bool = true) -> Fallible<Value> {
        self.value.incremented(condition).veto(self.error)
    }
    
    /// Returns the previous value in arithmetic progression.
    @inlinable public consuming func decremented(_ condition: Bool = true) -> Fallible<Value> {
        self.value.decremented(condition).veto(self.error)
    }
}

//*============================================================================*
// MARK: * Binary Integer x Addition x Systems
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the result of `self` + (`other` + `bit`).
    @inlinable public consuming func plus(_ other: borrowing Self, plus bit: Bool) -> Fallible<Self> {
        //  TODO: await consuming fixes
        let (a, x) = self.plus((other)).components()
        let (b, y) = a.incremented(bit).components()
        return b.veto(x != y)
    }
    
    /// Returns the result of `self` - (`other` + `bit`).
    @inlinable public consuming func minus(_ other: borrowing Self, plus bit: Bool) -> Fallible<Self> {
        //  TODO: await consuming fixes
        let (a, x) = self .minus(other).components()
        let (b, y) = a.decremented(bit).components()
        return b.veto(x != y)
    }
}
