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

extension CoreInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func squared() -> Fallible<Self> {
        self.times(self)
    }
    
    @inlinable public func times(_ multiplier: Self) -> Fallible<Self> {
        let result = self.base.multipliedReportingOverflow(by: multiplier.base)
        return Self(result.partialValue).veto(result.overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public func multiplication(_  multiplier: Self) -> Doublet<Self> {
        let result = self.base.multipliedFullWidth(by: multiplier.base)
        return Doublet(low: Magnitude(result.low), high: Self(result.high))
    }
}
