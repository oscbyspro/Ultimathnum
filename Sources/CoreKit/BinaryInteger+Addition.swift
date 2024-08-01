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
    
    /// Returns the trapping result of `0 - instance`.
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
    
    /// Returns the result of `0 - self` that fits.
    @inlinable public consuming func negated() -> Fallible<Self> {
        let result: Fallible<Self> = self.complement(true)
        return result.value.veto(result.error == Self.isSigned)
    }
    
    /// Returns the result of `self + increment`.
    @inlinable public consuming func plus(_ increment: Bool) -> Fallible<Self> {
        switch Self.isSigned {
        case true : self.minus(Self(repeating: Bit(increment)))
        case false: self.plus (Self(           Bit(increment)))
        }
    }
    
    /// Returns the result of `self - increment`.
    @inlinable public consuming func minus(_ decrement: Bool) -> Fallible<Self> {
        switch Self.isSigned {
        case true : self.plus (Self(repeating: Bit(decrement)))
        case false: self.minus(Self(           Bit(decrement)))
        }
    }
    
    /// The next value in arithmetic progression.
    @inlinable public consuming func incremented() -> Fallible<Self> {
        self.plus(true)
    }
    
    /// The next value in arithmetic progression.
    @inlinable public consuming func decremented() -> Fallible<Self> {
        self.minus(true)
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
    
    /// Returns the result of `0 - self`.
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
    
    /// Returns the result of `self + other`.
    @inlinable public consuming func plus(_ other: Bool) -> Fallible<Value> {
        self.value.plus(other).veto(self.error)
    }
    
    /// Returns the result of `self - other`.
    @inlinable public consuming func minus(_ other: Bool) -> Fallible<Value> {
        self.value.minus(other).veto(self.error)
    }
    
    /// Returns the next value in arithmetic progression.
    @inlinable public consuming func incremented() -> Fallible<Value> {
        self.plus(true)
    }
    
    /// Returns the previous value in arithmetic progression.
    @inlinable public consuming func decremented() -> Fallible<Value> {
        self.minus(true)
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
        let a: Bool, b: Bool
        
        (self, a) = self.plus(other).components()
        (self, b) = self.plus((bit)).components()
        
        return self.veto(a != b)
    }
    
    /// Returns the result of `self` - (`other` + `bit`).
    @inlinable public consuming func minus(_ other: borrowing Self, plus bit: Bool) -> Fallible<Self> {
        let a: Bool, b: Bool
        
        (self, a) = self.minus(other).components()
        (self, b) = self.minus((bit)).components()
        
        return self.veto(a != b)
    }
}
