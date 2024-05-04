//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Fallible x Multiplication
//*============================================================================*

extension Fallible where Value: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func squared() -> Self {
        self.value.squared().invalidated(self.error)
    }
    
    @inlinable public consuming func times(_ other: borrowing Value) -> Self {
        self.value.times(other).invalidated(self.error)
    }
    
    @inlinable public consuming func times(_ other: borrowing Self ) -> Self {
        self.value.times(other).invalidated(self.error)
    }
}
