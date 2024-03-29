//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Arithmetic Result x Division
//*============================================================================*

extension ArithmeticResult where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient (_ divisor: borrowing Value) -> Self {
        self.value.quotient (divisor).combine(self.error)
    }
    
    @inlinable public consuming func quotient (_ divisor: borrowing Self ) -> Self {
        self.value.quotient (divisor).combine(self.error)
    }
    
    @inlinable public consuming func remainder(_ divisor: borrowing Value) -> Self {
        self.value.remainder(divisor).combine(self.error)
    }
    
    @inlinable public consuming func remainder(_ divisor: borrowing Self ) -> Self {
        self.value.remainder(divisor).combine(self.error)
    }
    
    @inlinable public consuming func division (_ divisor: borrowing Value) -> ArithmeticResult<Division<Value, Value>> {
        self.value.division (divisor).combine(self.error)
    }
    
    @inlinable public consuming func division (_ divisor: borrowing Self ) -> ArithmeticResult<Division<Value, Value>> {
        self.value.division (divisor).combine(self.error)
    }
}
