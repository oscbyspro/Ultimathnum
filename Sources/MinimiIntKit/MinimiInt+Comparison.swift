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
// MARK: * Minimi Int x Comparison
//*============================================================================*

extension MinimiInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.base == rhs.base
    }
    
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        (lhs, rhs) == (Self(bitPattern: Self.isSigned), Self(bitPattern: !Self.isSigned))
    }
    
    @inlinable public func compared(to other: Self) -> Signum {
        self == other ? Signum.same : Signum.one(Sign(bitPattern: Self.isSigned == Bool(bitPattern: self)))
    }
}
