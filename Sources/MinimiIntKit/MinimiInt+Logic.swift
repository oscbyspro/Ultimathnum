//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Minimi Int x Logic x Signed
//*============================================================================*

extension MinimiInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: consuming Self) -> Self {
        Self(bitPattern: ~instance.base)
    }
    
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        Self(bitPattern: lhs.base & rhs.base)
    }
    
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        Self(bitPattern: lhs.base | rhs.base)
    }
    
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        Self(bitPattern: lhs.base ^ rhs.base)
    }
}

//*============================================================================*
// MARK: * Minimi Int x Logic x Unsigned
//*============================================================================*

extension MinimiInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: consuming Self) -> Self {
        Self(bitPattern: ~instance.base)
    }
    
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        Self(bitPattern: lhs.base & rhs.base)
    }
    
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        Self(bitPattern: lhs.base | rhs.base)
    }
    
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        Self(bitPattern: lhs.base ^ rhs.base)
    }
}
