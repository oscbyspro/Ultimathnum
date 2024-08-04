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
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func times(_ result: borrowing Fallible<Self>) -> Fallible<Self> {
        self.times(result.value).veto(result.error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

extension Fallible where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func squared() -> Self {
        self.value.squared().veto(self.error)
    }
    
    @inlinable public consuming func times(_ other: borrowing Value) -> Self {
        self.value.times(other).veto(self.error)
    }
    
    @inlinable public consuming func times(_ other: borrowing Fallible<Value>) -> Self {
        self.value.times(other).veto(self.error)
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
    @inlinable public borrowing func multiplication(_ multiplier: Self, plus increment: Magnitude) -> Doublet<Self> {
        let bit: Bool; var   product = self.multiplication(multiplier)
        (product.low, bit) = product.low .plus(increment).components()
        (product.high)     = product.high.incremented(bit).unchecked()
        return product
    }
}
