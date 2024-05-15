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
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    /// Forms the trapping result of `lhs - rhs`.
    @inlinable public static func -=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs - rhs
    }

    /// Forms the wrapping result of `lhs - rhs`.
    @inlinable public static func &-=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs &- rhs
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Fallible
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the result of `0 - self` that fits.
    @inlinable public consuming func negated() -> Fallible<Self> {
        let result: Fallible<Self> =  self.complement(true)
        return result.value.veto(result.error == Self.isSigned)
    }
    
    /// Returns the result of `self - decrement` that fits.
    @inlinable public consuming func minus(_ decrement: borrowing Fallible<Self>) -> Fallible<Self> {
        self.minus(decrement.value).veto(decrement.error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Stride by 1
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns previous value in arithmetic progression, or `self`.
    @inlinable public consuming func decremented(_ condition: consuming Bool = true) -> Fallible<Self> {
        switch Self.isSigned {
        case true : self.plus (Self(repeating: Bit(condition)))
        case false: self.minus(Self(/*------*/ Bit(condition)))
        }
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
    @inlinable public consuming func minus(_ other: borrowing Self, plus bit: consuming Bool) -> Fallible<Self> {
        let a: Bool, b: Bool
        
        (self, a) = self.minus(other).components()
        (self, b) = self.decremented(bit).components()
        
        return self.veto(a != b)
    }
}
