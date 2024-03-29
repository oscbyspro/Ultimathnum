//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Multiplication
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func *(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.times(rhs).unwrap()
    }
    
    @inlinable public static func &*(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.times(rhs).value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    @inlinable public static func *=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs * rhs
    }

    @inlinable public static func &*=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs &* rhs
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Result
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func times(_ result: borrowing Fallible<Self>) -> Fallible<Self> {
        self.times(result.value).combine(result.error)
    }
}
