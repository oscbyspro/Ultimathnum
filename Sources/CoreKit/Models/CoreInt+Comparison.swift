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
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.stdlib() == rhs.stdlib()
    }
    
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.stdlib() <  rhs.stdlib()
    }
    
    @inlinable public func compared(to other: Self) -> Signum {
        if  self < other {
            Signum.negative
            
        }   else if self == other {
            Signum.zero
            
        }   else {
            Signum.positive
        }
    }
}
