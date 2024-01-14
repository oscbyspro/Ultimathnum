//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer
//*============================================================================*

/// A binary integer.
///
/// ### Binary
///
/// Its signedness is with respect to un/signed two's complement.
///
/// - Requires: Negative values must use binary two's complement form.
///
public protocol BinaryInteger: Integer where Magnitude: BinaryInteger { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable public static func &+(lhs: consuming Self, rhs: Self) -> Self {
        Overflow.ignore({ try lhs.plus(rhs) })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable public static func &-(lhs: consuming Self, rhs: Self) -> Self {
        Overflow.ignore({ try lhs.minus(rhs) })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable public static func &*(lhs: consuming Self, rhs: Self) -> Self {
        Overflow.ignore({ try lhs.times(rhs) })
    }
}
