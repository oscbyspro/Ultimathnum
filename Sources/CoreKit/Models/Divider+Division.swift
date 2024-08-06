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
    
    /// Returns the `quotient` of dividing the `dividend` by the `divisor`.
    @inlinable public borrowing func quotient(dividing dividend: borrowing Value) -> Value {
        if  Value.size < UX.size {
            var quotient = UX(load: dividend)
            quotient   &*= UX(load: self.multiplier)
            quotient   &+= UX(load: self.increment )
            quotient     = quotient.down(Shift(unchecked: Count(raw: UX(load: self.shift))))
            return Value.init(load: quotient)
            
        }   else {
            return dividend.multiplication(self.multiplier, plus: self.increment).high &>> self.shift
        }
    }
    
    /// Returns the `quotient` and `remainder` of dividing the `dividend` by the `divisor`.
    @inlinable public borrowing func division(dividing dividend: borrowing Value) -> Division<Value, Value> {
        let quotient  = self.quotient(dividing: dividend)
        let remainder = (copy dividend).minus(quotient.times(self.divisor)).unchecked()
        return Division(quotient: quotient, remainder: remainder)
    }
}
