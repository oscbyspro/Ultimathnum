//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Minimi Int x Addition
//*============================================================================*

extension MinimiInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func plus(_ increment: borrowing Self) -> Fallible<Self> {
        Fallible(self ^ increment, error: Bool(bitPattern: self & increment))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public func plus(_ increment: borrowing Self, carrying error: consuming Bool) -> Fallible<Self> {
        if  Self.isSigned {
            self.plus(increment).minus(Self(bitPattern: error))
        }   else {
            self.plus(increment).plus (Self(bitPattern: error))
        }
    }
}
