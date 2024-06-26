//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int x Comparison
//*============================================================================*

extension CoreInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func compared(to other: Self) -> Signum {
        self < other ? -1 : self == other ? 0 : 1
    }
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.base == rhs.base
    }
    
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.base <  rhs.base
    }
}
