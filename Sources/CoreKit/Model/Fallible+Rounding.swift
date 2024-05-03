//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Fallible x Rounding
//*============================================================================*

extension Fallible {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func ceil<Quotient, Remainder>() -> Fallible<Quotient> where Value == Division<Quotient, Remainder> {
        self.value.ceil().combine(self.error)
    }
    
    @inlinable public consuming func floor<Quotient, Remainder>() -> Fallible<Quotient> where Value == Division<Quotient, Remainder> {
        self.value.floor().combine(self.error)
    }    
}
