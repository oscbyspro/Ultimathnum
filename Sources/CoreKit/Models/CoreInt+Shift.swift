//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int x Shift
//*============================================================================*

extension CoreInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func up(_ distance: Shift<Magnitude>) -> Self {
        Self(self.base &<< distance.value.base.base)
    }
    
    @inlinable public consuming func down(_ distance: Shift<Magnitude>) -> Self {
        Self(self.base &>> distance.value.base.base)
    }
}
