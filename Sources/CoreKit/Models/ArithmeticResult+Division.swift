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
    
    @inlinable public consuming func quotient ( divisor: borrowing Value) -> Self {
        self.value.quotient (divisor: divisor).combine(self.error)
    }
    
    @inlinable public consuming func quotient ( divisor: borrowing Self ) -> Self {
        self.value.quotient (divisor: divisor).combine(self.error)
    }
    
    @inlinable public consuming func remainder( divisor: borrowing Value) -> Self {
        self.value.remainder(divisor: divisor).combine(self.error)
    }
    
    @inlinable public consuming func remainder( divisor: borrowing Self ) -> Self {
        self.value.remainder(divisor: divisor).combine(self.error)
    }
    
    @inlinable public consuming func divided(by divisor: borrowing Value) -> ArithmeticResult<Division<Value, Value>> {
        self.value.divided(by: divisor).combine(self.error)
    }
    
    @inlinable public consuming func divided(by divisor: borrowing Self ) -> ArithmeticResult<Division<Value, Value>> {
        self.value.divided(by: divisor).combine(self.error)
    }
}
