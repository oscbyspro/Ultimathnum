//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int x Bitwise
//*============================================================================*

extension CoreInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: Self) -> Self {
        Self(~instance.base)
    }
    
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        Self(lhs.base & rhs.base)
    }
    
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        Self(lhs.base | rhs.base)
    }
    
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        Self(lhs.base ^ rhs.base)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func reversed(_ type: U8.Type) -> Self {
        Self(self.base.byteSwapped)
    }
    
    @inlinable public func complement(_ increment: Bool) -> Fallible<Self> {
        (~self).incremented(increment)
    }
}
