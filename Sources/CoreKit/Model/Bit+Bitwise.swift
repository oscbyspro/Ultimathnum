//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit x Bitwise
//*============================================================================*

extension Bit {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: Self) -> Self {
        Self(raw: !instance.base)
    }
    
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        Self(raw: lhs.base == rhs.base ? lhs.base : false)
    }
    
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        Self(raw: lhs.base == rhs.base ? lhs.base : true )
    }
    
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        Self(raw: lhs.base != rhs.base)
    }
}
