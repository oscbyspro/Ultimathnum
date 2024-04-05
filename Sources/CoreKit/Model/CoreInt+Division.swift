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
    
    @inlinable public consuming func quotient (_ divisor: borrowing Self) -> Fallible<Self> {
        var result = self.base.dividedReportingOverflow(by: divisor.base)
        //=--------------------------------------=
        // Ultimathnum: custom division semantics
        //=--------------------------------------=
        if  result.overflow {
            result.partialValue &*= divisor.base
        }
        //=--------------------------------------=
        return Self(result.partialValue).combine(result.overflow)
    }
    
    @inlinable public consuming func remainder(_ divisor: borrowing Self) -> Fallible<Self> {
        let result = self.base.remainderReportingOverflow(dividingBy: divisor.base)
        return Self(result.partialValue).combine(result.overflow)
    }
    
    @inlinable public consuming func division (_ divisor: borrowing Self) -> Fallible<Division<Self, Self>> {
        let quotient  = (copy    self).quotient (divisor)
        let remainder = (consume self).remainder(divisor)
        return Division(quotient: quotient.value, remainder: remainder.value).combine(quotient.error || remainder.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public static func division(_ dividend: consuming Doublet<Self>, by divisor: Self) -> Fallible<Division<Self, Self>> {
        //=--------------------------------------=
        let lhsIsLessThanZero = dividend.high.isLessThanZero
        let rhsIsLessThanZero = divisor/*--*/.isLessThanZero
        //=--------------------------------------=
        var result = Fallible<Division<Self, Self>>(
            bitPattern: Magnitude.division(dividend.magnitude(), by: divisor.magnitude())
        )
        
        var suboverflow  = Bit( result.value.quotient.isLessThanZero)
        if  lhsIsLessThanZero != rhsIsLessThanZero {
            suboverflow &= Bit(!result.value.quotient.capture({ $0.complement(true) }))
        }
        
        if  lhsIsLessThanZero {
            result.value.remainder = result.value.remainder.complement()
        }
        
        return result.combine(Bool(suboverflow))
    }
}

//*============================================================================*
// MARK: * Core Int x Division x Unsigned
//*============================================================================*

extension CoreInt where Self == Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable static func division(_ dividend: consuming Doublet<Self>, by divisor: borrowing Self) -> Fallible<Division<Self, Self>> {
        //=--------------------------------------=
        if  divisor == 0 {
            return Fallible.failure(Division(quotient: 0, remainder: dividend.low))
        }
        //=--------------------------------------=
        var overflow = false
        //=--------------------------------------=
        if  divisor <= dividend.high {
            overflow = true
            dividend.high.capture(divisor, map:{ $0.remainder($1).assert() })
        }
        //=--------------------------------------=
        let result = divisor.base.dividingFullWidth((high: dividend.high.base, low: dividend.low.base))
        return Division(quotient: Self(result.quotient), remainder: Self(result.remainder)).combine(overflow)
    }
}
