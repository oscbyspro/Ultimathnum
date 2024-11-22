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
// MARK: * Adapter Integer x Addition
//*============================================================================*

extension AdapterInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func +(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(Base(lhs) + rhs.base)
    }
    
    @inlinable public static func +=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs + rhs
    }
    
    @inlinable public static func -(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(Base(lhs) - rhs.base)
    }
    
    @inlinable public static func -=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs - rhs
    }
}

//*============================================================================*
// MARK: * Adapter Integer x Addition x Signed
//*============================================================================*

extension AdapterInteger where Self: Swift.SignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func negate() {
        self = -self
    }
    
    @inlinable public static prefix func -(instance: consuming Self) -> Self {
        Self(-Base(instance))
    }
}
