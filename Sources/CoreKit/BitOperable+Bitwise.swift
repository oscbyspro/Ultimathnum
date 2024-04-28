//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Operable x Bitwise
//*============================================================================*

extension BitOperable {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating  func toggle() {
        self = ~self
    }
    
    @inlinable public consuming func toggled() -> Self {
        ~self
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    @inlinable public static func &=(lhs: inout Self, rhs: Self) {
        lhs = lhs & rhs
    }

    @inlinable public static func |=(lhs: inout Self, rhs: Self) {
        lhs = lhs | rhs
    }
    
    @inlinable public static func ^=(lhs: inout Self, rhs: Self) {
        lhs = lhs ^ rhs
    }
}
