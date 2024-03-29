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
    
    @inlinable public static func +(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.plus(rhs).unwrap()
    }
    
    @inlinable public static func &+(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.plus(rhs).value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    @inlinable public static func +=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs + rhs
    }
    
    @inlinable public static func &+=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs &+ rhs
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Result
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ result: borrowing ArithmeticResult<Self>) -> ArithmeticResult<Self> {
        self.plus(result.value).combine(result.error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Stride by 1
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// The next value in arithmetic progression.
    ///
    /// - Note: It works with **0-bit** and **1-bit** integers.
    ///
    @inlinable public consuming func incremented() -> ArithmeticResult<Self> {
        if  let positive = Self.exactly(1).optional() {
            return self.plus (positive)
        }   else if let negative = Self.exactly(-1).optional() {
            return self.minus(negative)
        }   else {
            return ArithmeticResult.failure(self)
        }
    }
}
