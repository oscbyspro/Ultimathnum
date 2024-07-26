//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Multiplication
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the trapping result of `self * increment`.
    @inlinable public static func *(lhs: borrowing Self, rhs: borrowing Self) -> Self {
        lhs.times(rhs).unwrap()
    }
    
    /// Returns the wrapping result of `self * increment`.
    @inlinable public static func &*(lhs: borrowing Self, rhs: borrowing Self) -> Self {
        lhs.times(rhs).value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    /// Forms the trapping result of `self * increment`.
    @inlinable public static func *=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs * rhs
    }

    /// Forms the wrapping result of `self * increment`.
    @inlinable public static func &*=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs &* rhs
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Result
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func times(_ result: borrowing Fallible<Self>) -> Fallible<Self> {
        self.times(result.value).veto(result.error)
    }
}

//*============================================================================*
// MARK: * Binary Integer x Multiplication x Systems
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the full result of `self * multiplier + increment`.
    @inlinable public consuming func multiplication(_ multiplier: Self, plus increment: Magnitude) -> Doublet<Self> {
        let bit: Bool
        var product = self.multiplication(multiplier)
        (product.low, bit) = product.low.plus(increment).components()
        (product.high) = product.high.plus(bit).unchecked()
        return product
    }
}
