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
    
    @inlinable public consuming func negated() throws -> Self {
        let result = Overflow.capture({ try (~self).incremented(by: 1) })
        return try Overflow.resolve(result.value, overflow: result.overflow == Self.isSigned)
    }
    
    @inlinable public consuming func decremented(by decrement: borrowing Self) throws -> Self {
        let result = self.base.subtractingReportingOverflow(decrement.base)
        return try Overflow.resolve(Self(result.partialValue), overflow: result.overflow)
    }
}
