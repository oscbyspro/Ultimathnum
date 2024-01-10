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
    
    @inlinable public consuming func quotient(divisor: Self) throws -> Self {
        let result = self.base.dividedReportingOverflow(by: divisor.base)
        return try Overflow.resolve(Self(result.partialValue), overflow: result.overflow)
    }
    
    @inlinable public consuming func remainder(divisor: Self) throws -> Self {
        let result = self.base.remainderReportingOverflow(dividingBy: divisor.base)
        return try Overflow.resolve(Self(result.partialValue), overflow: result.overflow)
    }
    
    @inlinable public consuming func divided(by divisor: Self) throws -> Division<Self> {
        let quotient  = Overflow.capture({ try self.quotient (divisor: divisor) })
        let remainder = Overflow.capture({ try self.remainder(divisor: divisor) })
        return try Overflow.resolve(Division(quotient: quotient.value, remainder: remainder.value), overflow: quotient.overflow || remainder.overflow)
    }
    
    @inlinable public static func dividing(_ dividend: Doublet<Self>, by divisor: Self) throws -> Division<Self> {
        let lhsIsLessThanZero = dividend.high/**/.isLessThanZero
        let rhsIsLessThanZero = divisor/*------*/.isLessThanZero
        let minus: Bool = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        var result = Overflow<Division<Self>>.Result(bitPattern: Overflow.capture {
            try Magnitude._dividing(TBI.magnitude(of: dividend), by: divisor.magnitude)
        })
        //=--------------------------------------=
        if  minus {
            result.value.quotient  = Overflow.ignore({ try result.value.quotient .negated() })
        }
        
        if  lhsIsLessThanZero {
            result.value.remainder = Overflow.ignore({ try result.value.remainder.negated() })
        }
        
        if  minus != result.value.quotient.isLessThanZero {
            result.overflow = result.overflow || !(minus && result.value.quotient == 0)
        }
        //=--------------------------------------=
        return try result.resolve() as Division<Self>
    }
}

//*============================================================================*
// MARK: * Main Int x Division x Unsigned
//*============================================================================*

extension MainInt where Self == Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inline(__always) @inlinable static func _dividing(_ dividend: Doublet<Self>, by divisor: Self) throws -> Division<Self> {
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  divisor == 0 {
            return try Overflow.resolve(Division(quotient: dividend.low,   remainder: dividend.low),    overflow: true)
        //=--------------------------------------=
        // quotient does not fit in one part
        //=--------------------------------------=
        }   else if divisor <= dividend.high {
            let (quotient, remainder) = divisor.base.dividingFullWidth((high: dividend.high.base % divisor.base, low: dividend.low.base))
            return try Overflow.resolve(Division(quotient: Self(quotient), remainder: Self(remainder)), overflow: true)
        //=--------------------------------------=
        }   else {
            let (quotient, remainder) = divisor.base.dividingFullWidth((high: dividend.high.base, low: dividend.low.base))
            return try Overflow.resolve(Division(quotient: Self(quotient), remainder: Self(remainder)), overflow: false)
        }
    }
}
