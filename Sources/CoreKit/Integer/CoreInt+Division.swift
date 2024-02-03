//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
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
    
    @inlinable public consuming func quotient(divisor: Self) throws -> Self {
        let result = self.base.dividedReportingOverflow(by: divisor.base)
        return try Overflow.resolve(Self(result.partialValue), overflow: result.overflow)
    }
    
    @inlinable public consuming func remainder(divisor: Self) throws -> Self {
        let result = self.base.remainderReportingOverflow(dividingBy: divisor.base)
        return try Overflow.resolve(Self(result.partialValue), overflow: result.overflow)
    }
    
    @inlinable public consuming func divided(by divisor: Self) throws -> Division<Self, Self> {
        let quotient  = Overflow.capture({ try self.quotient (divisor: divisor) })
        let remainder = Overflow.capture({ try self.remainder(divisor: divisor) })
        return try Overflow.resolve(Division(quotient: quotient.value, remainder: remainder.value), overflow: quotient.overflow || remainder.overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 vs 1
    //=------------------------------------------------------------------------=
    
    @inlinable public static func dividing(_ dividend: Doublet<Self>, by divisor: Self) throws -> Division<Self, Self> {
        let lhsIsLessThanZero = dividend.high/**/.isLessThanZero
        let rhsIsLessThanZero = divisor/*------*/.isLessThanZero
        let minus: Bool = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        var result = Division<Self, Self>(bitPattern: try Magnitude._dividing(TBI.magnitude(of: dividend), by: divisor.magnitude))
        //=--------------------------------------=
        if  minus {
            result.quotient  = Overflow.ignore({ try result.quotient .negated() })
        }
        
        if  lhsIsLessThanZero {
            result.remainder = Overflow.ignore({ try result.remainder.negated() })
        }
        
        if  minus != result.quotient.isLessThanZero, !(minus && result.quotient == 0) {
            throw Overflow()
        }
        //=--------------------------------------=
        return result as Division<Self, Self>
    }
}

//*============================================================================*
// MARK: * Core Int x Division x Unsigned
//*============================================================================*

extension CoreInt where Self == Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inline(__always) @inlinable static func _dividing(_ dividend: Doublet<Self>, by divisor: Self) throws -> Division<Self, Self> {
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  divisor == 0 {
            throw Overflow()
        //=--------------------------------------=
        // quotient does not fit in one part
        //=--------------------------------------=
        }   else if divisor <= dividend.high {
            throw Overflow()
        //=--------------------------------------=
        // quotient does fit in one part
        //=--------------------------------------=
        }   else {
            let (quotient, remainder) = divisor.base.dividingFullWidth((high: dividend.high.base, low: dividend.low.base))
            return Division(quotient: Self(quotient), remainder: Self(remainder))
        }
    }
}
