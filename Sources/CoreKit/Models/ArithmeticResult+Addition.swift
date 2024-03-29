//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Arithmetic Result x Addition
//*============================================================================*

extension ArithmeticResult where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ other: borrowing Value) -> Self {
        self.value.plus(other).combine(self.error)
    }
    
    @inlinable public consuming func plus(_ other: borrowing Self ) -> Self {
        self.value.plus(other).combine(self.error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Stride by 1
//=----------------------------------------------------------------------------=

extension ArithmeticResult where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// The next value in arithmetic progression.
    ///
    /// - Note: It works with **0-bit** and **1-bit** integers.
    ///
    @inlinable public consuming func incremented() -> Self {
        self.value.incremented().combine(self.error)
    }
}
