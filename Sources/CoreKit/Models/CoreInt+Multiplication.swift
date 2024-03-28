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
    
    @inlinable public consuming func squared() -> ArithmeticResult<Self> {
        self.times(copy self)
    }
    
    @inlinable public consuming func times(_ multiplier: borrowing Self) -> ArithmeticResult<Self> {
        let result = self.base.multipliedReportingOverflow(by: multiplier.base)
        return ArithmeticResult(Self(result.partialValue), error: result.overflow)
    }
    
    @inlinable public static func multiplying(_ multiplicand: consuming Self, by multiplier: borrowing Self) -> DoubleIntLayout<Self> {
        let result = multiplicand.base.multipliedFullWidth(by: multiplier.base)
        return DoubleIntLayout(high: Self(result.high), low: Magnitude(result.low))
    }
}
