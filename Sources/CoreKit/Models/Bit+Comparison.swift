//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit x Comparison
//*============================================================================*

extension Bit {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==(lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.base == rhs.base
    }
    
    @inlinable public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        (lhs.base, rhs.base) == (false, true)
    }
    
    /// Indicates whether this value is equal to zero.
    @inlinable public var isZero: Bool {
        !self.base
    }
    
    /// Performs a three-way comparison of `self` versus `other`.
    @inlinable public func compared(to other: Self) -> Signum {        
        if  self == other {
            Signum.zero
            
        }   else if other.base {
            Signum.negative
            
        }   else {
            Signum.positive
        }
    }
}
