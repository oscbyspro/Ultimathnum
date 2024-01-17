//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int x Shift
//*============================================================================*

extension CoreInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func  <<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base  << rhs.base)
    }
    
    @inlinable public static func &<<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base &<< rhs.base)
    }
    
    @inlinable public static func  >>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base  >> rhs.base)
    }
    
    @inlinable public static func &>>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base &>> rhs.base)
    }
}
