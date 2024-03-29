//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Division
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func /(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.quotient (divisor: rhs).unwrap()
    }
    
    @inlinable public static func %(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.remainder(divisor: rhs).unwrap()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    @inlinable public static func /=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs / rhs
    }

    @inlinable public static func %=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs % rhs
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Result
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient ( divisor: borrowing ArithmeticResult<Self>) -> ArithmeticResult<Self> {
        self.quotient (divisor: divisor.value).combine(divisor.error)
    }
    
    @inlinable public consuming func remainder( divisor: borrowing ArithmeticResult<Self>) -> ArithmeticResult<Self> {
        self.remainder(divisor: divisor.value).combine(divisor.error)
    }
    
    @inlinable public consuming func divided(by divisor: borrowing ArithmeticResult<Self>) -> ArithmeticResult<Division<Self, Self>> {
        self.divided(by: divisor.value).combine(divisor.error)
    }
}
