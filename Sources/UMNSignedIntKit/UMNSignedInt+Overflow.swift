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
// MARK: * UMN x Signed Int x Overflow
//*============================================================================*

extension UMNOverflow {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<Magnitude>(sign: consuming UMNSign, magnitude: consuming UMNOverflow<Magnitude>) where Value == UMNSignedInt<Magnitude> {
        self.init(Value(sign: sign, magnitude: magnitude.value), overflow: magnitude.overflow)
    }
}

