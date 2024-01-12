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
// MARK: * Signed Int x Multiplication
//*============================================================================*

extension SignedInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable public consuming func squared() throws -> Self {
        try Self(sign: Sign.plus, magnitude:{ try self.magnitude.squared() })
    }
    
    @inlinable public consuming func times(_  multiplier: Self) throws -> Self {
        try Self(sign: self.sign ^ multiplier.sign, magnitude:{ try self.magnitude.times(multiplier.magnitude) })
    }
}
