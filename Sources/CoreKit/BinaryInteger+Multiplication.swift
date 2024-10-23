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

//*============================================================================*
// MARK: * Binary Integer x Multiplication x Lenient
//*============================================================================*

extension BinaryInteger where Self: ArbitraryInteger & SignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns `self ✕ self`.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public borrowing func squared() -> Self {
        self.squared().unchecked()
    }
    
    /// Returns `self ✕ other`.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public borrowing func times(_ other: borrowing Self) -> Self {
        self.times(other).unchecked()
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
        let bit: Bool
        var product = self.multiplication(other)
        (product.low, bit) = product.low .plus(increment).components()
        (product.high)     = product.high.incremented(bit).unchecked()
        return product
    }
}
