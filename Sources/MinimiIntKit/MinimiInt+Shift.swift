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
// MARK: * Minimi Int x Shift x Signed
//*============================================================================*

extension MinimiInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func  <<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs
    }
    
    @inlinable public static func &<<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs
    }
    
    @inlinable public static func  >>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        rhs == 0 ? lhs : 0
    }
    
    @inlinable public static func &>>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs
    }
}

//*============================================================================*
// MARK: * Minimi Int x Shift x Unsigned
//*============================================================================*

extension MinimiInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func  <<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        rhs == 0 ? lhs : 0
    }
    
    @inlinable public static func &<<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs
    }
    
    @inlinable public static func  >>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        rhs == 0 ? lhs : 0
    }
    
    @inlinable public static func &>>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs
    }
}
