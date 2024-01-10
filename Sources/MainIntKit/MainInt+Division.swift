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
    
    @inlinable public static func dividing(_ dividend: Doublet<Self>, by divisor: Self) -> Overflow<Division<Self>> {
        let lhsIsLessThanZero = dividend.high    .isLessThanZero
        let rhsIsLessThanZero = divisor/*------*/.isLessThanZero
        let minus: Bool = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        var result = Overflow<Division<Self>>(bitPattern: Magnitude._dividing(TBI.magnitude(of: dividend), by: divisor.magnitude))
        //=--------------------------------------=
        if  minus {
            result.value.quotient  = result.value.quotient .negated().value
        }
        
        if  lhsIsLessThanZero {
            result.value.remainder = result.value.remainder.negated().value
        }
        
        if  minus != result.value.quotient.isLessThanZero {
            result.overflow = result.overflow || !(minus && result.value.quotient == 0)
        }
        //=--------------------------------------=
        return result as Overflow<Division<Self>>
    }
}

//*============================================================================*
// MARK: * Main Int x Division x Unsigned
//*============================================================================*

extension MainInt where Self == Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inline(__always) @inlinable static func _dividing(_ dividend: Doublet<Self>, by divisor: Self) -> Overflow<Division<Self>> {
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  divisor == 0 {
            return Overflow(Division(quotient: dividend.low,   remainder: dividend.low),    overflow: true)
        //=--------------------------------------=
        // quotient does not fit in one part
        //=--------------------------------------=
        }   else if divisor <= dividend.high {
            let (quotient, remainder) = divisor.base.dividingFullWidth((high: dividend.high.base % divisor.base, low: dividend.low.base))
            return Overflow(Division(quotient: Self(quotient), remainder: Self(remainder)), overflow: true)
        //=--------------------------------------=
        }   else {
            let (quotient, remainder) = divisor.base.dividingFullWidth((high: dividend.high.base, low: dividend.low.base))
            return Overflow(Division(quotient: Self(quotient), remainder: Self(remainder)), overflow: false)
        }
    }
}
