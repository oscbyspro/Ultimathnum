//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Division x Rounding
//*============================================================================*

extension Division where Quotient: BinaryInteger, Remainder: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Increments the `quotient` if the `remainder` is positive.
    @inlinable public consuming func ceil() -> Fallible<Quotient> {
        let instance: Self = consume self
        let increment: Quotient = instance.remainder > 0 ? 1 : 0
        return instance.quotient.plus(increment)
    }
    
    /// Decrements the `quotient` if the `remainder` is negative.
    @inlinable public consuming func floor() -> Fallible<Quotient> {
        let instance: Self = consume self
        let increment: Quotient = instance.remainder.isNegative ? 1 : 0
        return instance.quotient.minus(increment)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

extension Fallible {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func ceil<Quotient, Remainder>() -> Fallible<Quotient> where Value == Division<Quotient, Remainder> {
        self.value.ceil().veto(self.error)
    }
    
    @inlinable public consuming func floor<Quotient, Remainder>() -> Fallible<Quotient> where Value == Division<Quotient, Remainder> {
        self.value.floor().veto(self.error)
    }
}
