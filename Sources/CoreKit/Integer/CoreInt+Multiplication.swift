//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int x Multiplication
//*============================================================================*

extension CoreInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func squared() throws -> Self {
        try self.times(copy self)
    }
    
    @inlinable public consuming func times(_ multiplier: borrowing Self) throws -> Self {
        let result = self.base.multipliedReportingOverflow(by: multiplier.base)
        return try Overflow.resolve(Self(result.partialValue), overflow: result.overflow)
    }
    
    @inlinable public static func multiplying(_ multiplicand: consuming Self, by multiplier: borrowing Self) -> Doublet<Self> {
        let result = multiplicand.base.multipliedFullWidth(by: multiplier.base)
        return Doublet(high: Self(result.high), low: Magnitude(result.low))
    }
}
