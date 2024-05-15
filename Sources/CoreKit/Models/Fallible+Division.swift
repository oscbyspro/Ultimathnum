//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Fallible x Division
//*============================================================================*

extension Fallible where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient (_ divisor: borrowing Divisor<Value>) -> Self {
        self.value.quotient (divisor).veto(self.error)
    }
    
    @inlinable public consuming func remainder(_ divisor: borrowing Divisor<Value>) -> Self {
        self.value.remainder(divisor).veto(self.error)
    }
    
    @inlinable public consuming func division (_ divisor: borrowing Divisor<Value>) -> Fallible<Division<Value, Value>> {
        self.value.division (divisor).veto(self.error)
    }
}
