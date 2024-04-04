//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Systems Integer x Addition
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func minus(_ decrement: borrowing Self, carrying extra: consuming Bool) -> Fallible<Self> {
        let error: Bool
        (self, error) = self.minus(decrement).components
        (self, extra) = self.minus(Element(Bit(bitPattern: extra))).components
        return self.combine(error != extra)
    }
}
