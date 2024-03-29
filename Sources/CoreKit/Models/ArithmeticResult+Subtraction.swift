//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Arithmetic Result x Subtraction
//*============================================================================*

extension ArithmeticResult where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func minus(_ other: borrowing Value) -> Self {
        self.value.minus(other).combine(self.error)
    }
    
    @inlinable public consuming func minus(_ other: borrowing Self ) -> Self {
        self.value.minus(other).combine(self.error)
    }
}
