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
    
    /// Returns `lhs ✕ rhs` by trapping on `error`.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public static func *(lhs: borrowing Self, rhs: borrowing Self) -> Self {
        lhs.times(rhs).unwrap()
    }
    
    /// Returns `lhs ✕ rhs` by wrapping on `error`.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public static func &*(lhs: borrowing Self, rhs: borrowing Self) -> Self {
        lhs.times(rhs).value
    }
    
    /// Forms `lhs ✕ rhs` by trapping on `error`.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public static func *=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs * rhs
    }

    /// Forms `lhs ✕ rhs` by wrapping on `error`.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
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
    
    /// Returns `self ✕ other` and an `error` indicator.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public consuming func times(_ other: borrowing Fallible<Self>) -> Fallible<Self> {
        self.times(other.value).veto(other.error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

extension Fallible where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns `self ✕ self` and an `error` indicator.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public consuming func squared() -> Self {
        self.value.squared().veto(self.error)
    }
    
    /// Returns `self ✕ other` and an `error` indicator.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public consuming func times(_ other: borrowing Value) -> Self {
        self.value.times(other).veto(self.error)
    }
    
    /// Returns `self ✕ other` and an `error` indicator.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
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
    
    /// Returns the `high` and `low` part of `self ✕ other + increment`.
    @inlinable public borrowing func multiplication(_ other: Self, plus increment: Magnitude) -> Doublet<Self> {
        let bit: Bool; var   product = self.multiplication(other)
        (product.low, bit) = product.low .plus(increment).components()
        (product.high)     = product.high.incremented(bit).unchecked()
        return product
    }
}
