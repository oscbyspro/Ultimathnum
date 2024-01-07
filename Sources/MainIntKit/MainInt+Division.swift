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
// MARK: * Main Int x Division
//*============================================================================*

extension MainInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(divisor: borrowing Self) -> Overflow<Self> {
        let result = self.base.dividedReportingOverflow(by: divisor.base)
        return Overflow(Self(result.partialValue), overflow: result.overflow)
    }
    
    @inlinable public consuming func remainder(divisor: borrowing Self) -> Overflow<Self> {
        let result = self.base.remainderReportingOverflow(dividingBy: divisor.base)
        return Overflow(Self(result.partialValue), overflow: result.overflow)
    }
    
    @inlinable public consuming func divided(by divisor: borrowing Self) -> Overflow<Division<Self>> {
        let quotient  = (copy    self).quotient (divisor: divisor)
        let remainder = (consume self).remainder(divisor: divisor)
        let overflow  = quotient.overflow || remainder.overflow
        return Overflow(Division(quotient: quotient.value, remainder: remainder.value), overflow: overflow)
    }
    
    @inlinable public static func dividing(_ dividend: consuming FullWidth<Self, Magnitude>, by divisor: borrowing Self) -> Overflow<Division<Self>> {
        fatalError("TOOD")
    }
    
}
