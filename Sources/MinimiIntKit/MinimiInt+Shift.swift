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
// MARK: * Minimi Int x Shift
//*============================================================================*

extension MinimiInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func  <<(lhs: consuming Self, rhs: Self) -> Self {
        Self.isSigned || rhs == 0 ? lhs : 0
    }
    
    @inlinable public static func &<<(lhs: consuming Self, rhs: Self) -> Self {
        lhs
    }
    
    @inlinable public static func  >>(lhs: consuming Self, rhs: Self) -> Self {
        rhs == 0 ? lhs : 0
    }
    
    @inlinable public static func &>>(lhs: consuming Self, rhs: Self) -> Self {
        lhs
    }
}
