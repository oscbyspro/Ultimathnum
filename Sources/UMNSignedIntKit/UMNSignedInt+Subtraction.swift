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
// MARK: * UMN x Signed Int x Subtraction
//*============================================================================*

extension UMNSignedInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> UMNOverflow<Self> {
        fatalError("TODO")
    }
    
    @inlinable public consuming func decremented(by decrement: consuming Self) -> UMNOverflow<Self> {
        fatalError("TODO")
    }
}
