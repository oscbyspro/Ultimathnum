//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Doublet x Bit
//*============================================================================*

extension Doublet {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func complement() -> Self {
        self.complement(true).value
    }
    
    @inlinable public consuming func complement(_ increment: consuming Bool) -> Fallible<Self> {
        increment = self.low [{ $0.complement(increment) }]
        increment = self.high[{ $0.complement(increment) }]
        return Fallible(self, error: increment)
    }
    
    @inlinable public consuming func magnitude() -> Magnitude {
        Magnitude(raw: self.high.isNegative ? self.complement() : self)
    }
}
