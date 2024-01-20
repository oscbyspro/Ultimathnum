//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Double Int x Shift
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func <<(lhs: consuming Self, rhs: Self) -> Self {
        if  rhs.isLessThanZero {
            return lhs >> -rhs
        }   else if Self.bitWidth  <= Magnitude(bitPattern: rhs) {
            return Self(repeating: U1())
        }   else {
            return lhs &>> rhs
        }
    }
    
    @inlinable public static func >>(lhs: consuming Self, rhs: Self) -> Self {
        if  rhs.isLessThanZero {
            return lhs << -rhs
        }   else if Self.bitWidth  <= Magnitude(bitPattern: rhs) {
            return Self(repeating: U1(bitPattern: lhs.isLessThanZero))
        }   else {
            return lhs &<< rhs
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func &<<(lhs: consuming Self, rhs: borrowing Self) -> Self {
        fatalError("TODO")
    }
    
    @inlinable public static func &>>(lhs: consuming Self, rhs: borrowing Self) -> Self {
        fatalError("TODO")
    }
}
