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

extension _CoreInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func  <<(instance: Self, distance: Self) -> Self {
        Self(instance.base  << distance.base)
    }
    
    @inlinable public static func &<<(instance: Self, distance: Self) -> Self {
        Self(instance.base &<< distance.base)
    }
    
    @inlinable public static func &<<(instance: Self, distance: Shift<Self>) -> Self {
        Self(instance.base &<< distance.value.base) // there are no unchecked shifts in Swift
    }
    
    @inlinable public static func  >>(instance: Self, distance: Self) -> Self {
        Self(instance.base  >> distance.base)
    }
    
    @inlinable public static func &>>(instance: Self, distance: Self) -> Self {
        Self(instance.base &>> distance.base)
    }
    
    @inlinable public static func &>>(instance: Self, distance: Shift<Self>) -> Self {
        Self(instance.base &>> distance.value.base) // there are no unchecked shifts in Swift
    }
}
