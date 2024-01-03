//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import UMNCoreKit

//*============================================================================*
// MARK: * UNM x Signed Int x Multiplication
//*============================================================================*

extension UMNSignedInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable public consuming func squared() -> UMNOverflow<Self> {
        UMNOverflow(sign: UMNSign.plus, magnitude: self.magnitude.squared())
    }
    
    @inlinable public consuming func multiplied(by multiplier: borrowing Self) -> UMNOverflow<Self> {
        UMNOverflow(sign: self.sign ^ multiplier.sign, magnitude: self.magnitude.multiplied(by: multiplier.magnitude))
    }
}