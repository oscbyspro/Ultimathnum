//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int x Subtraction
//*============================================================================*

extension CoreInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func minus(_ decrement: Self) -> Fallible<Self> {
        let result = self.base.subtractingReportingOverflow(decrement.base)
        return Self(result.partialValue).veto(result.overflow)
    }
}
