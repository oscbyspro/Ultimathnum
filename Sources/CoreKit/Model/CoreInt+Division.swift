//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int x Division
//*============================================================================*

extension CoreInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient (_ divisor: borrowing Divisor<Self>) -> Fallible<Self> {
        let result = self.base.dividedReportingOverflow(by: divisor.value.base)
        return Self(result.partialValue).combine(result.overflow)
    }
    
    @inlinable public consuming func remainder(_ divisor: borrowing Divisor<Self>) -> Self {
        let result = self.base.remainderReportingOverflow(dividingBy: divisor.value.base)
        return Self(result.partialValue)
    }
    
    @inlinable public consuming func division (_ divisor: borrowing Divisor<Self>) -> Fallible<Division<Self, Self>> {
        let quotient  = (copy    self).quotient (divisor)
        let remainder = (consume self).remainder(divisor)
        return Division(quotient: quotient.value, remainder: remainder).combine(quotient.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public static func division(_ dividend: consuming Doublet<Self>, by divisor: Divisor<Self>) -> Fallible<Division<Self, Self>> {
        //=--------------------------------------=
        let lhsIsNegative = dividend.high.isNegative
        let rhsIsNegative = divisor.value.isNegative
        //=--------------------------------------=
        var division = Fallible<Division<Self, Self>>(
            raw: Magnitude.division(dividend.magnitude(), by: divisor.magnitude())
        )
        
        var suboverflow  = Bit( division.value.quotient.isNegative)
        if  lhsIsNegative  != rhsIsNegative {
            suboverflow &= Bit(!division.value.quotient[{ $0.complement(true) }])
        }
        
        if  lhsIsNegative {
            division.value.remainder = division.value.remainder.complement()
        }
        
        return division.combine(Bool(suboverflow))
    }
}

//*============================================================================*
// MARK: * Core Int x Division x Unsigned
//*============================================================================*

extension CoreInt where Self == Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable static func division(_ dividend: consuming Doublet<Self>, by divisor: Divisor<Self>) -> Fallible<Division<Self, Self>> {
        //=--------------------------------------=
        var overflow = false
        //=--------------------------------------=
        if  divisor.value <= dividend.high {
            overflow = true
            dividend.high[{ $0.remainder(divisor) }]
        }
        //=--------------------------------------=
        let result = divisor.value.base.dividingFullWidth((high: dividend.high.base, low: dividend.low.base))
        return Division(quotient: Self(result.quotient), remainder: Self(result.remainder)).combine(overflow)
    }
}
