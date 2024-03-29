//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Arithmetic Result x Multiplication
//*============================================================================*

extension ArithmeticResult where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func times(_ other: borrowing Value) -> Self {
        self.value.times(other).combine(self.error)
    }
    
    @inlinable public consuming func times(_ other: borrowing Self ) -> Self {
        self.value.times(other).combine(self.error)
    }
}
