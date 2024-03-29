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
// MARK: * Double Int x Addition
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable public consuming func plus(_ increment: Self) -> Fallible<Self> {
        var overflow = self.low.capture {
            $0.plus(increment.low)
        }
        
        overflow = overflow && self.high.capture {
            $0.incremented()
        }
        
        overflow = overflow != self.high.capture {
            $0.plus(increment.high)
        }
        
        return Fallible(self, error: overflow)
    }
}
