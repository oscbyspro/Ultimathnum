//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Doublet x Bitwise
//*============================================================================*

extension Doublet {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func complement() -> Self {
        self.complement(true).value
    }
    
    @inlinable public consuming func complement(_ increment: Bool) -> Fallible<Self> {
        let low  = self.low .complement(increment)
        let high = self.high.complement(low.error)
        return Fallible(Self(low: low.value, high: high.value), error: high.error)
    }
    
    @inlinable public consuming func magnitude() -> Magnitude {
        Magnitude(raw: self.high.isNegative ? self.complement() : self)
    }
}
