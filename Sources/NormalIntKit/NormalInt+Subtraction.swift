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
// MARK: * Normal Int x Subtraction x Unsigned
//*============================================================================*

extension NormalInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> Overflow<Self> {
        fatalError("TODO")
    }
    
    @inlinable public consuming func decremented(by decrement: borrowing Self) -> Overflow<Self> {
        fatalError("TODO")
    }
}