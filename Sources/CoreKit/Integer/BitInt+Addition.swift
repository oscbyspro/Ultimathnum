//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Int x Addition x Signed
//*============================================================================*

extension BitInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ increment: borrowing Self) throws -> Self {
        try Overflow.resolve(Self(bitPattern: (copy self).bitPattern ^ increment.bitPattern), overflow: self & increment != 0)
    }
}

//*============================================================================*
// MARK: * Bit Int x Addition x Unsigned
//*============================================================================*

extension BitInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ increment: borrowing Self) throws -> Self {
        try Overflow.resolve(Self(bitPattern: (copy self).bitPattern ^ increment.bitPattern), overflow: self & increment != 0)
    }
}
