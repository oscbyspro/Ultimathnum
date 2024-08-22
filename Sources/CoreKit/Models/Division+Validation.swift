//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Division x Validation
//*============================================================================*

extension Division {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` and an `error` indicator.
    ///
    /// The `error` is set when the `remainder` is nonzero.
    ///
    @inlinable public consuming func exactly() -> Fallible<Quotient> {
        self.quotient.veto(!self.remainder.isZero)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

extension Fallible {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` and an `error` indicator.
    ///
    /// The `error` is set when the `remainder` is nonzero.
    ///
    @inlinable public consuming func exactly<Quotient, Remainder>() -> Fallible<Quotient> where Value == Division<Quotient, Remainder> {
        self.value.exactly().veto(self.error)
    }
}
