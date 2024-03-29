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
// MARK: * Double Int x Subtraction
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> Fallible<Self> {
        let overflow: Bool = self.capture({ (~$0).plus(1) })
        return Fallible(self, error: Self.isSigned == overflow)
    }
    
    @inlinable public consuming func minus(_ decrement: Self) -> Fallible<Self> {
        var overflow = self.low.capture {
            $0.minus(decrement.low)
        }
        
        overflow = overflow && self.high.capture {
            $0.decremented()
        }
        
        overflow = overflow != self.high.capture {
            $0.minus(decrement.high)
        }
        
        return Fallible(self, error: overflow)
    }
}
