//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Int x Logic x Signed
//*============================================================================*

extension BitInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: consuming Self) -> Self {
        Self(bitPattern: !instance.bitPattern)
    }
    
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        Self(bitPattern: lhs.bitPattern == rhs.bitPattern ? lhs.bitPattern : false)
    }
    
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        Self(bitPattern: lhs.bitPattern == rhs.bitPattern ? lhs.bitPattern : true )
    }
    
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        Self(bitPattern: lhs.bitPattern != rhs.bitPattern)
    }
}

//*============================================================================*
// MARK: * Bit Int x Logic x Unsigned
//*============================================================================*

extension BitInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: consuming Self) -> Self {
        Self(bitPattern: !instance.bitPattern)
    }
    
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        Self(bitPattern: lhs.bitPattern == rhs.bitPattern ? lhs.bitPattern : false)
    }
    
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        Self(bitPattern: lhs.bitPattern == rhs.bitPattern ? lhs.bitPattern : true )
    }
    
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        Self(bitPattern: lhs.bitPattern != rhs.bitPattern)
    }
}