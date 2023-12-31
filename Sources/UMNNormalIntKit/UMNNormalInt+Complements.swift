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
// MARK: * UMN x Normal Int x Complements
//*============================================================================*

extension UMNNormalInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func standard() -> UMNStandardInt<Self> {
        UMNStandardInt(self)
    }
    
    @inlinable public consuming func magnitude() -> Self {
        self
    }
    
    @inlinable public consuming func onesComplement() -> Self {
        fatalError("TODO")
    }
    
    @inlinable public consuming func twosComplement() -> UMNOverflow<Self> {
        fatalError("TODO")
    }
    
    @inlinable public consuming func words() -> Words {
        Words(self)
    }
}
