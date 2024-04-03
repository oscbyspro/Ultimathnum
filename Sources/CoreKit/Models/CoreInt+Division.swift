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
        return Fallible(Self(result.partialValue), error: result.overflow)
    }
    
    @inlinable public consuming func remainder(_ divisor: borrowing Self) -> Fallible<Self> {
        let result = self.base.remainderReportingOverflow(dividingBy: divisor.base)
        return Fallible(Self(result.partialValue), error: result.overflow)
    }
    
    @inlinable public consuming func division (_ divisor: borrowing Self) -> Fallible<Division<Self, Self>> {
        let quotient  = (copy    self).quotient (divisor)
        let remainder = (consume self).remainder(divisor)
        return Fallible(Division(quotient: quotient.value, remainder: remainder.value), error: quotient.error || remainder.error)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public static func division(_ dividend: consuming Doublet<Self>, by divisor: Self) -> Fallible<Division<Self, Self>> {
        typealias T = Fallible<Division<Self, Self>>
        //=--------------------------------------=
        let lhsIsLessThanZero: Bool = dividend.high.isLessThanZero
        let rhsIsLessThanZero: Bool = divisor/*--*/.isLessThanZero
        let minus: Bool = (lhsIsLessThanZero) != rhsIsLessThanZero
        //=--------------------------------------=
        var result = T(bitPattern: Magnitude._division(dividend.magnitude, by: divisor.magnitude))
        //=--------------------------------------=
        if  minus {
            result.value.quotient .capture({ $0.complement })
        }
        
        if  lhsIsLessThanZero {
            result.value.remainder.capture({ $0.complement })
        }
        
        let overflow = minus != result.value.quotient.isLessThanZero && !(minus && result.value.quotient == 0)
        //=--------------------------------------=
        return result.combine(overflow)
    }
}

//*============================================================================*
// MARK: * Core Int x Division x Unsigned
//*============================================================================*

extension CoreInt where Self == Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inline(__always) @inlinable static func _division(_ dividend: consuming Doublet<Self>, by divisor: borrowing Self) -> Fallible<Division<Self, Self>> {
        //=--------------------------------------=
        if  divisor == 0 {
            return Fallible.failure(Division(quotient: 0, remainder: dividend.low))
        }
        //=--------------------------------------=
        var overflow = false
        //=--------------------------------------=
        if  divisor <= dividend.high {
            overflow = true
            dividend.high = dividend.high.remainder(divisor).assert()
        }
        //=--------------------------------------=
        let result = divisor.base.dividingFullWidth((high: dividend.high.base, low: dividend.low.base))
        return Fallible(Division(quotient: Self(result.quotient), remainder: Self(result.remainder)), error: overflow)
    }
}
