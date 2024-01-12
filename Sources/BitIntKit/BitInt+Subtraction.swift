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
// MARK: * Bit Int x Subtraction x Signed
//*============================================================================*

extension BitInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() throws -> Self {
        try Overflow.resolve(self, overflow: self != 0)
    }
    
    @inlinable public consuming func minus(_ decrement: borrowing Self) throws -> Self {
        try Overflow.resolve(Self(bitPattern: (copy self).bitPattern ^ decrement.bitPattern), overflow: self > decrement)
    }
}

//*============================================================================*
// MARK: * Bit Int x Subtraction x Unsigned
//*============================================================================*

extension BitInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() throws -> Self {
        try Overflow.resolve(self, overflow: self != 0)
    }
    
    @inlinable public consuming func minus(_ decrement: borrowing Self) throws -> Self {
        try Overflow.resolve(Self(bitPattern: (copy self).bitPattern ^ decrement.bitPattern), overflow: self < decrement)
    }
}
