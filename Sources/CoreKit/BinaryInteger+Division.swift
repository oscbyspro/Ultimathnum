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

//=----------------------------------------------------------------------------=
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

extension Fallible where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient (_ divisor: borrowing Nonzero<Value>) -> Fallible<Value> {
        self.value.quotient (divisor).veto(self.error)
    }
    
    @inlinable public consuming func remainder(_ divisor: borrowing Nonzero<Value>) -> Fallible<Value> {
        self.value.remainder(divisor).veto(self.error)
    }
    
    @inlinable public consuming func division (_ divisor: borrowing Nonzero<Value>) -> Fallible<Division<Value, Value>> {
        self.value.division (divisor).veto(self.error)
    }
}

//*============================================================================*
// MARK: * Binary Integer x Division x Systems x Unsigned
//*============================================================================*

extension BinaryInteger where Self: SystemsInteger & UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient (_ divisor: borrowing Nonzero<Self>) -> Self {
        self.quotient(divisor).unchecked("SystemsInteger & UnsignedInteger")
    }
    
    @inlinable public consuming func division (_ divisor: borrowing Nonzero<Self>) -> Division<Self, Self> {
        self.division(divisor).unchecked("SystemsInteger & UnsignedInteger")
    }
}
