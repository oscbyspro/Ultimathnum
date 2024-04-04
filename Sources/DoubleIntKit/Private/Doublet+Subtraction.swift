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
// MARK: * Doublet x Subtraction
//*============================================================================*

extension Doublet {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> Fallible<Self> {
        var error = true
        (self.low,  error) = (~self.low ).incremented(error).components
        (self.high, error) = (~self.high).incremented(error).components
        return Fallible(self, error: error == Self.isSigned)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1
    //=------------------------------------------------------------------------=
        
    @inlinable public consuming func minus(_ decrement: Base) -> Fallible<Self> {
        let appendix = High.init(repeating: decrement.appendix)
        let low  = self.low .minus(Low(bitPattern: decrement))
        let high = self.high.minus(appendix, carrying: low.error)
        return Fallible(Self(low: low.value, high: high.value), error: high.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2
    //=------------------------------------------------------------------------=
    
    @inlinable package consuming func minus(_ decrement: borrowing Self) -> Fallible<Self> {
        let low  = self.low .minus(decrement.low)
        let high = self.high.minus(decrement.high, carrying: low.error)
        return Fallible(Self(low: low.value, high: high.value), error: high.error)
    }
}
