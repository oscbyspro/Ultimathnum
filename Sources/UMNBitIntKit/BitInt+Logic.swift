//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import UMNCoreKit

//*============================================================================*
// MARK: * Bit Int x Logic x Signed
//*============================================================================*

extension BitInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(operand: consuming Self) -> Self {
        Self(bitPattern: ~operand.bitPattern)
    }
    
    @inlinable public static func &(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(bitPattern: lhs.bitPattern & rhs.bitPattern)
    }
    
    @inlinable public static func |(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(bitPattern: lhs.bitPattern | rhs.bitPattern)
    }
    
    @inlinable public static func ^(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(bitPattern: lhs.bitPattern ^ rhs.bitPattern)
    }
}

//*============================================================================*
// MARK: * Bit Int x Logic x Unsigned
//*============================================================================*

extension BitInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(operand: consuming Self) -> Self {
        Self(bitPattern: ~operand.bitPattern)
    }
    
    @inlinable public static func &(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(bitPattern: lhs.bitPattern & rhs.bitPattern)
    }
    
    @inlinable public static func |(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(bitPattern: lhs.bitPattern | rhs.bitPattern)
    }
    
    @inlinable public static func ^(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(bitPattern: lhs.bitPattern ^ rhs.bitPattern)
    }
}
