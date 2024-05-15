//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Subtraction
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the trapping result of `0 - instance`.
    @inlinable public static prefix func -(instance: consuming Self) -> Self {
        instance.negated().unwrap()
    }
    
    /// Returns the trapping result of `lhs - rhs`.
    @inlinable public static func -(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.minus(rhs).unwrap()
    }
    
    /// Returns the wrapping result of `lhs - rhs`.
    @inlinable public static func &-(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.minus(rhs).value
    }
    
    /// Forms the trapping result of `lhs - rhs`.
    @inlinable public static func -=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs - rhs
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
        let result: Fallible<Self> =  self.complement(true)
        return result.value.veto(result.error == Self.isSigned)
    }
    
    /// The next value in arithmetic progression.
    @inlinable public consuming func decremented() -> Fallible<Self> {
        self.minus(true)
    }
    
    /// Returns the result of `self - increment`.
    @inlinable public consuming func minus(_ decrement: Bool) -> Fallible<Self> {
        switch Self.isSigned {
        case true : self.plus (Self(repeating: Bit(decrement)))
        case false: self.minus(Self(/*------*/ Bit(decrement)))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Fallible
//=----------------------------------------------------------------------------=

extension BinaryInteger {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the result of `self - decrement` that fits.
    @inlinable public consuming func minus(_ decrement: borrowing Fallible<Self>) -> Fallible<Self> {
        self.minus(decrement.value).veto(decrement.error)
    }
}

//*============================================================================*
// MARK: * Binary Integer x Addition x Systems
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the result of `self` - (`other` + `bit`).
    @inlinable public consuming func minus(_ other: borrowing Self, plus bit: Bool) -> Fallible<Self> {
        let a: Bool, b: Bool
        
        (self, a) = self.minus(other).components()
        (self, b) = self.minus((bit)).components()
        
        return self.veto(a != b)
    }
}
