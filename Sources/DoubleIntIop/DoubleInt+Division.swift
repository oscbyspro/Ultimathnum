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
// MARK: * Double Int x Division x Stdlib
//*============================================================================*

extension DoubleInt.Stdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func /(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(lhs.base / rhs.base)
    }
    
    @inlinable public static func /=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs / rhs
    }
    
    @inlinable public static func %(lhs: consuming Self, rhs: borrowing Self) -> Self {
        let result = lhs.remainderReportingOverflow(dividingBy: rhs)
        return Fallible(result.partialValue, error: result.overflow).unwrap()
    }
    
    @inlinable public static func %=(lhs: inout Self, rhs: borrowing Self) {
        lhs = lhs % rhs
    }
    
    @inlinable public consuming func quotientAndRemainder(
        dividingBy divisor: borrowing  Self
    )   -> (quotient: Self, remainder: Self) {
        
        let division: Division = self.base.division(divisor.base).unwrap().unwrap()
        return (quotient: Self(division.quotient), remainder: Self(division.remainder))
    }
}

//*============================================================================*
// MARK: * Double Int x Division x Stdlib x Swift Fixed Width Integer
//*============================================================================*

extension DoubleInt.Stdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func dividedReportingOverflow(
        by other: borrowing Self
    )   -> (partialValue: Self, overflow: Bool) {
        
        if  let result = self.base.quotient(other.base) {
            return (partialValue: result.value.stdlib(), overflow: result.error)
        }   else {
            return (partialValue: self, overflow: true)
        }
    }
    
    @inlinable public consuming func remainderReportingOverflow(
        dividingBy other: borrowing Self
    )   -> (partialValue: Self, overflow: Bool) {
        
        if  let divisor =  Nonzero(exactly: other.base) {
            //=----------------------------------=
            // note: standard library semantics
            //=----------------------------------=
            let overflow:  Bool = Self.isSigned && self == Self.min && divisor.value == -1
            let remainder: Base = self.base.remainder(divisor)
            return (partialValue: remainder.stdlib(), overflow: overflow)
            
        }   else {
            return (partialValue: self, overflow: true)
        }
    }
    
    @inlinable public borrowing func dividingFullWidth(
        _ dividend: consuming (high: Self, low: Magnitude)
    )   -> (quotient: Self, remainder: Self) {
        
        let dividend = Doublet(low: dividend.low.base, high: dividend.high.base)
        let division = Base.division(dividend, by: Nonzero(self.base)).unwrap()
        return (quotient: division.quotient.stdlib(), remainder: division.remainder.stdlib())
    }
}
