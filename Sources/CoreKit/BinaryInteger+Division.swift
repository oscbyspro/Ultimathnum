//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Division
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func /(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.quotient (Divisor(copy rhs)!).unwrap()
    }
    
    @inlinable public static func %(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.remainder(Divisor(copy rhs)!)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    @inlinable public static func /=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs / rhs
    }

    @inlinable public static func %=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs % rhs
    }
}
