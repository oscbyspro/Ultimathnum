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
    
    /// Returns the trapping `quotient` of `lhs` divided by `rhs`.
    @inlinable public static func /(lhs: consuming Self, rhs: Self) -> Self {
        lhs.quotient (Divisor(rhs)).unwrap()
    }
    
    /// Returns the trapping `remainder` of `lhs` divided by `rhs`.
    @inlinable public static func %(lhs: consuming Self, rhs: Self) -> Self {
        lhs.remainder(Divisor(rhs))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    /// Forms the trapping `quotient` of `lhs` divided by `rhs`.
    @inlinable public static func /=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs / rhs
    }

    /// Forms the trapping `remainder` of `lhs` divided by `rhs`.
    @inlinable public static func %=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs % rhs
    }
}
