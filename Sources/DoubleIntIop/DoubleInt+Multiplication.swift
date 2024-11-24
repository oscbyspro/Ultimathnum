//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit

//*============================================================================*
// MARK: * Double Int x Multiplication x Stdlib
//*============================================================================*

extension DoubleInt.Stdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func *=(lhs: inout Self, rhs: borrowing Self) {
        lhs.base *= rhs.base
    }
    
    @inlinable public static func *(lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(lhs.base * rhs.base)
    }
}

//*============================================================================*
// MARK: * Double Int x Multiplication x Stdlib x Swift Fixed Width Integer
//*============================================================================*

extension DoubleInt.Stdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func multipliedReportingOverflow(
        by other: borrowing Self
    )   -> (partialValue: Self, overflow: Bool) {
        
        let (value, error) = self.base.times(other.base).components()
        return (partialValue: value.stdlib(), overflow: error)
    }
    
    @inlinable public borrowing func multipliedFullWidth(
        by other: Self
    )   -> (high: Self, low: Magnitude) {
        
        let (low, high) = self.base.multiplication(other.base).components()
        return (high: high.stdlib(), low: low.stdlib())
    }
}
