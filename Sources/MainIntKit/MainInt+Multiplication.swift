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
// MARK: * Main Int x Multiplication
//*============================================================================*

extension MainInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func squared() -> Overflow<Self> {
        self.multiplied(by: copy self)
    }
    
    @inlinable public consuming func multiplied(by multiplier: borrowing Self) -> Overflow<Self> {
        let result = self.base.multipliedReportingOverflow(by: multiplier.base)
        return Overflow(Self(result.partialValue), overflow: result.overflow)
    }
    
    @inlinable public static func multiplying(_ multiplicand: consuming Self, by multiplier: borrowing Self) -> Doublet<Self> {
        let result = multiplicand.base.multipliedFullWidth(by: multiplier.base)
        return Doublet(high: Self(result.high), low: Magnitude(result.low))
    }
}
