//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Extension x Logic
//*============================================================================*

extension Bit.Extension {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: consuming Self) -> Self {
        Self(unchecked: ~instance.element)
    }
    
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        Self(unchecked: lhs.element & rhs.element)
    }
    
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        Self(unchecked: lhs.element | rhs.element)
    }
    
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        Self(unchecked: lhs.element | rhs.element)
    }
}
