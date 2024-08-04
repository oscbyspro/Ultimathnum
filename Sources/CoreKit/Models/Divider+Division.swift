//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Divider x Division
//*============================================================================*

extension Divider {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func quotient(dividing dividend: borrowing Value) -> Value {
        dividend.multiplication(self.multiplier, plus: self.increment).high.down(self.shift)
    }
    
    @inlinable public borrowing func division(dividing dividend: borrowing Value) -> Division<Value, Value> {
        let quotient  = self.quotient(dividing: dividend)
        let remainder = (copy dividend).minus(quotient.times(self.divisor.value)).unchecked()
        return Division(quotient: quotient, remainder: remainder)
    }
}
