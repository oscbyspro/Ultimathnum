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

extension Division {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Increments the `quotient` when the `remainder` is positive.
    @inlinable public consuming func ceil() -> Fallible<Quotient> {
        self.quotient.incremented(self.remainder.isPositive)
    }
    
    /// Decrements the `quotient` when the `remainder` is negative.
    @inlinable public consuming func floor() -> Fallible<Quotient> {
        self.quotient.decremented(self.remainder.isNegative)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

extension Fallible {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Increments the `quotient` when the `remainder` is positive.
    @inlinable public consuming func ceil<Quotient, Remainder>() -> Fallible<Quotient> where Value == Division<Quotient, Remainder> {
        self.value.ceil().veto(self.error)
    }
    
    /// Decrements the `quotient` when the `remainder` is negative.
    @inlinable public consuming func floor<Quotient, Remainder>() -> Fallible<Quotient> where Value == Division<Quotient, Remainder> {
        self.value.floor().veto(self.error)
    }
}
