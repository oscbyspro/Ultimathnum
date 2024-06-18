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
    
    @inlinable public consuming func upshift(_ distance: Shift<Self>) -> Self {
        Self(self.base &<< distance.value.base) // no unchecked shifts in Swift
    }
    
    @inlinable public consuming func downshift(_ distance: Shift<Self>) -> Self {
        Self(self.base &>> distance.value.base) // no unchecked shifts in Swift
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Systems Integer
    //=------------------------------------------------------------------------=
    
    @inlinable public static func &<<(instance: Self, distance: Self) -> Self {
        Self(instance.base &<< distance.base)
    }
    
    @inlinable public static func &>>(instance: Self, distance: Self) -> Self {
        Self(instance.base &>> distance.base)
    }
}
