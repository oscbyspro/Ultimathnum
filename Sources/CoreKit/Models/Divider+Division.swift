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
    @inlinable public borrowing func division(dividing dividend: consuming Value) -> Division<Value, Value> {
        let quotient  = self.quotient(dividing: dividend)
        let remainder = dividend.minus(quotient.times(self.divisor)).unchecked()
        return Division(quotient: quotient, remainder: remainder)
    }
}

//*============================================================================*
// MARK: * Divider x Division x 2 by 1
//*============================================================================*

extension Divider21 {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` of dividing the `dividend` by the `divisor`.
    ///
    /// ### Development
    ///
    /// - TODO: Consider DoubleableInteger deduplication.
    ///
    @inlinable public borrowing func quotient(dividing dividend: borrowing Doublet<Value>) -> Fallible<Value> {
        //=--------------------------------------=
        var ax = dividend.low .multiplication(self.multiplier.low )
        let ay = dividend.low .multiplication(self.multiplier.high)
        let bx = dividend.high.multiplication(self.multiplier.low )
        var by = dividend.high.multiplication(self.multiplier.high)
        //=--------------------------------------=
        var overflow: (Bool, Bool)
        //=--------------------------------------=
        (ax.high, overflow.0) = ax.high.plus(ay.low ).components()
        (ax.high, overflow.1) = ax.high.plus(bx.low ).components()
        let az =  Value(Bit(overflow.0)) &+ Value(Bit(overflow.1))
        //=--------------------------------------=
        (by.low,  overflow.0) = by.low .plus(ay.high).components()
        (by.low,  overflow.1) = by.low .plus(bx.high).components()
        let bz =  Value(Bit(overflow.0)) &+ Value(Bit(overflow.1))
        //=--------------------------------------=
        (by.low,  overflow.0) = by.low .plus(az).components()
        (by.high, overflow.0) = by.high.plus(bz, plus: overflow.0).components()
        //=--------------------------------------=
        (ax.low,  overflow.0) = ax.low .plus(self.increment.low ).components()
        (ax.high, overflow.0) = ax.high.plus(self.increment.high, plus: overflow.0).components()
        (by.low,  overflow.0) = by.low .incremented((overflow.0)).components()
        (by.high, overflow.0) = by.high.incremented((overflow.0)).components()
        //=--------------------------------------=
        by = by.down(Shift<Value>(masking: self.shift))
        return Fallible(by.low, error: !by.high.isZero)
    }
    
    /// Returns the `quotient` and `remainder` of dividing the `dividend` by the `divisor`.
    @inlinable public borrowing func division(dividing dividend: consuming Doublet<Value>) -> Fallible<Division<Value, Value>> {
        let quotient  = self.quotient(dividing: dividend)
        let remainder = dividend.low.minus(quotient.value.times(self.divisor).value).value
        return Division(quotient: quotient.value,remainder: remainder).veto(quotient.error)
    }
}
