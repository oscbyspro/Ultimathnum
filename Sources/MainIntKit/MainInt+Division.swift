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
        let _qro = Magnitude.dividingAsUnsignedCodeBlock(dividend.magnitude, by: divisor.magnitude)
        var  qro = Overflow(Division(quotient: Self(bitPattern: _qro.value.quotient), remainder: Self(bitPattern: _qro.value.remainder)), overflow: _qro.overflow)
        //=--------------------------------------=
        if  minus {
            qro.value.quotient  = qro.value.quotient .negated().value
        }
        
        if  lhsIsLessThanZero {
            qro.value.remainder = qro.value.remainder.negated().value
        }
        
        if  minus != qro.value.quotient.isLessThanZero {
            qro.overflow = qro.overflow || !(minus && qro.value.quotient == 0)
        }
        //=--------------------------------------=
        return qro as Overflow<Division<Self>>
    }
}

//*============================================================================*
// MARK: * Main Int x Division x Unsigned
//*============================================================================*

extension MainInt where Self == Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static func dividingAsUnsignedCodeBlock(_ dividend: Doublet<Self>, by divisor: Self) -> Overflow<Division<Self>> {
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  divisor == 0 {
            let quotient = Self(bitPattern: dividend.low), remainder = Self(bitPattern: dividend.low)
            return Overflow(Division(quotient: consume quotient, remainder: consume remainder), overflow: true)
        //=--------------------------------------=
        // quotient does not fit in two halves
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
