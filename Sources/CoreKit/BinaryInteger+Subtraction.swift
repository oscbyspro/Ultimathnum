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
        return result.value.combine(result.error == Self.isSigned)
    }
    
    @inlinable public consuming func minus(_ decrement: borrowing Fallible<Self>) -> Fallible<Self> {
        self.minus(decrement.value).combine(decrement.error)
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
    
    @inlinable public consuming func minus(_ decrement: borrowing Self, plus extra: consuming Bool) -> Fallible<Self> {
        //=--------------------------------------=
        // performance: consume instance then bit
        //=--------------------------------------=
        let error: Bool
        (self, error) = self.minus(decrement).components()
        (self, extra) = self.minus(Self(Bit(extra))).components()
        return self.combine(error != extra)
    }
}
