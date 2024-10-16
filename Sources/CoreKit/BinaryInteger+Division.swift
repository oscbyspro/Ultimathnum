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
    
    /// Returns the trapping `quotient` of `lhs` divided by `rhs`.
    @inlinable public static func /(lhs: consuming Self, rhs: Self) -> Self {
        lhs.quotient (Nonzero(rhs)).unwrap()
    }
    
    /// Returns the trapping `remainder` of `lhs` divided by `rhs`.
    @inlinable public static func %(lhs: consuming Self, rhs: Self) -> Self {
        lhs.remainder(Nonzero(rhs))
    }
    
    /// Forms the trapping `quotient` of `lhs` divided by `rhs`.
    @inlinable public static func /=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs / rhs
    }

    /// Forms the trapping `remainder` of `lhs` divided by `rhs`.
    @inlinable public static func %=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs % rhs
    }
}

//*============================================================================*
// MARK: * Binary Integer x Division x Natural
//*============================================================================*

extension BinaryInteger where Self: SystemsInteger & UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(_ divisor: borrowing Nonzero<Self>) -> Self {
        Natural(unchecked: self).quotient(divisor)
    }
    
    @inlinable public consuming func division(_ divisor: borrowing Nonzero<Self>) -> Division<Self, Self> {
        Natural(unchecked: self).division(divisor)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Divider
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func quotient(_ divider: borrowing Divider<Self>) -> Self {
        divider.quotient(dividing: self)
    }
    
    @inlinable public consuming func division(_ divider: borrowing Divider<Self>) -> Division<Self, Self> {
        divider.division(dividing: self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Guarantee
//=----------------------------------------------------------------------------=

extension Natural where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(_ divisor: borrowing Nonzero<Value>) -> Value {
        self.value.quotient(divisor).unchecked()
    }
    
    @inlinable public consuming func division(_ divisor: borrowing Nonzero<Value>) -> Division<Value, Value> {
        self.value.division(divisor).unchecked()
    }
}
