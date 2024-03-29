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
    
    @inlinable public consuming func negated() -> Self {
        self.value.negated().combine(self.error)
    }
    
    @inlinable public consuming func minus(_ other: borrowing Value) -> Self {
        self.value.minus(other).combine(self.error)
    }
    
    @inlinable public consuming func minus(_ other: borrowing Self ) -> Self {
        self.value.minus(other).combine(self.error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Stride by 1
//=----------------------------------------------------------------------------=

extension ArithmeticResult where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// The previous value in arithmetic progression.
    ///
    /// - Note: It works with **0-bit** and **1-bit** integers.
    ///
    @inlinable public consuming func decremented() -> Self {
        self.value.decremented().combine(self.error)
    }
}
