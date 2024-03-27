//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Extension x Comparison
//*============================================================================*

extension Bit.Extension {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func compared(to other: Self) -> Signum {
        self.element.compared(to: other.element)
    }
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.element == rhs.element
    }
    
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.element <  rhs.element
    }
}
