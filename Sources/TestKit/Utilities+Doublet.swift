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
// MARK: * Utilities x Doublet
//*============================================================================*

extension Doublet where Base: SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ other: borrowing Self) -> Fallible<Self> {
        let low  = self.low .plus(other.low)
        let high = self.high.plus(other.high, plus: low.error)
        return Fallible(Self(low: low.value, high: high.value), error: high.error)
    }
    
    @inlinable public consuming func minus(_ other: borrowing Self) -> Fallible<Self> {
        let low  = self.low .minus(other.low)
        let high = self.high.minus(other.high, plus: low.error)
        return Fallible(Self(low: low.value, high: high.value), error: high.error)
    }
}
