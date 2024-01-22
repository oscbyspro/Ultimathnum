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
// MARK: * Minimi Int x Addition x Signed
//*============================================================================*

extension MinimiInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func plus(_ increment: Self) throws -> Self {
        try Overflow.resolve(self ^ increment, overflow: self & increment != 0)
    }
}

//*============================================================================*
// MARK: * Minimi Int x Addition x Unsigned
//*============================================================================*

extension MinimiInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func plus(_ increment: Self) throws -> Self {
        try Overflow.resolve(self ^ increment, overflow: self & increment != 0)
    }
}
