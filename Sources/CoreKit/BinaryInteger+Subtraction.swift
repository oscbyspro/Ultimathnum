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
    
    @inlinable public static prefix func -(instance: consuming Self) -> Self {
        instance.negated().unwrap()
    }
    
    @inlinable public static func -(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.minus(rhs).unwrap()
    }
    
    /// ### Development
    ///
    /// - FIXME: Consuming caues bad accesss (2024-01-13, Swift 5.9).
    ///
    @inlinable public static func &-(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.minus(rhs).value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    @inlinable public static func -=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs - rhs
    }

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
    
    @inlinable public consuming func negated() -> Fallible<Self> {
        let result: Fallible<Self> =  self.complement(true)
        return result.value.veto(result.error == Self.isSigned)
    }
    
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
    
    /// The previous value in arithmetic progression.
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
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    /// Returns the result of `self` - (`other` + `bit`).
    ///
    /// ```
    /// min: -(low:  0, high: 1)
    /// max: +(low: ~0, high: 0)
    /// ```
    ///
    @inlinable public consuming func minus(_ other: borrowing Self, plus bit: consuming Bool) -> Fallible<Self> {
        let a: Bool, b: Bool
        
        (self, a) = self.minus(other).components()
        (self, b) = self.minus(Self(Bit(bit))).components()
        
        return self.veto(a != b)
    }
}
