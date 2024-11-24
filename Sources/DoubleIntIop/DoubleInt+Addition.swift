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
// MARK: * Double Int x Addition x Stdlib
//*============================================================================*

extension DoubleInt.Stdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func +(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base + rhs.base)
    }
    
    @inlinable public static func +=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs + rhs
    }
    
    @inlinable public static func -(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base - rhs.base)
    }
    
    @inlinable public static func -=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs - rhs
    }
}

//*============================================================================*
// MARK: * Double Int x Addition x Stdlib x Swift Fixed Width Integer
//*============================================================================*

extension DoubleInt.Stdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func addingReportingOverflow(
        _ other: borrowing Self
    )   -> (partialValue:  Self, overflow: Bool) {
        
        let (value, error) = self.base.plus(other.base).components()
        return (partialValue: value.stdlib(), overflow: error)
    }
    
    @inlinable public consuming func subtractingReportingOverflow(
        _ other: borrowing Self
    )   -> (partialValue:  Self, overflow: Bool) {
        
        let (value, error) = self.base.minus(other.base).components()
        return (partialValue: value.stdlib(), overflow: error)
    }
}

//*============================================================================*
// MARK: * Double Int x Addition x Stdlib x Swift Signed Integer
//*============================================================================*

extension DoubleInt.Stdlib where Self: Swift.SignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func negate() {
        self = -self
    }
    
    @inlinable public static prefix func -(instance: consuming Self) -> Self {
        Self(-instance.base)
    }
}
