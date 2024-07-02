//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Count x Comparison
//*============================================================================*

extension Count {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.base == rhs.base
    }
    
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        Layout.Magnitude(raw: lhs.base) < Layout.Magnitude(raw: rhs.base)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var isZero: Bool {
        self.base.isZero
    }
    
    @inlinable public var isInfinite: Bool {
        Bool(self.base.appendix)
    }
}
