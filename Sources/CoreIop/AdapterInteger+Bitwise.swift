//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Adapter Integer x Bitwise
//*============================================================================*

extension AdapterInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: consuming Self) -> Self {
        Self(~Base(instance))
    }
    
    @inlinable public static func &(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(Base(lhs) & rhs.base)
    }
    
    @inlinable public static func &=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs & rhs
    }
    
    @inlinable public static func |(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(Base(lhs) | rhs.base)
    }
    
    @inlinable public static func |=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs | rhs
    }
    
    @inlinable public static func ^(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(Base(lhs) ^ rhs.base)
    }
    
    @inlinable public static func ^=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs ^ rhs
    }
}
