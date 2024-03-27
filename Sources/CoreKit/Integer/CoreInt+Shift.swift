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

extension CoreInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func  <<(instance: consuming Self, shift: borrowing Self) -> Self {
        Self(instance.base  << shift.base)
    }
    
    @inlinable public static func &<<(instance: consuming Self, shift: borrowing Self) -> Self {
        Self(instance.base &<< shift.base)
    }
    
    @inlinable public static func  >>(instance: consuming Self, shift: borrowing Self) -> Self {
        Self(instance.base  >> shift.base)
    }
    
    @inlinable public static func &>>(instance: consuming Self, shift: borrowing Self) -> Self {
        Self(instance.base &>> shift.base)
    }
}
