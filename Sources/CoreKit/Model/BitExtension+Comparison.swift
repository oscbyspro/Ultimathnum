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

extension BitExtension {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func compared(to other: borrowing Self) -> Signum {
        self.element.compared(to: other.element)
    }
    
    @inlinable public static func ==(lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.element == rhs.element
    }
    
    @inlinable public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.element <  rhs.element
    }
}
