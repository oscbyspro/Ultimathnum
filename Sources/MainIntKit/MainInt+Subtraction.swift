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
// MARK: * Main Int x Subtraction
//*============================================================================*

extension MainInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> Overflow<Self> {
        let result = (~self).incremented(by: 1)
        return Overflow(result.value, overflow: result.overflow == Self.isSigned)
    }
    
    @inlinable public consuming func decremented(by decrement: borrowing Self) -> Overflow<Self> {
        let result = self.base.subtractingReportingOverflow(decrement.base)
        return Overflow(Self(result.partialValue), overflow: result.overflow)
    }
}
