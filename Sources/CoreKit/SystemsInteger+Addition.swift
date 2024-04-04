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
    
    #warning("consider incrementation(_:_:)")
    @inlinable public consuming func plus(_ increment: borrowing Self, carrying extra: consuming Bool) -> Fallible<Self> {
        let error: Bool
        (self, error) = self.plus(increment).components
        (self, extra) = self.plus(Element(Bit(bitPattern: extra))).components
        return Fallible(self, error: error != extra)
    }
}
