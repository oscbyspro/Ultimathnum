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
        
        if  result.overflow {
            throw Overflow()
        }
        
        return Self(result.partialValue)
    }
    
    @inlinable public consuming func remainder(divisor: Self) throws -> Self {
        let result = self.base.remainderReportingOverflow(dividingBy: divisor.base)
        
        if  result.overflow {
            throw Overflow()
        }
        
        return Self(result.partialValue)
    }
    
    @inlinable public consuming func divided(by divisor: Self) throws -> Division<Self, Self> {
        let quotient  = try (copy    self) .quotient (divisor: divisor)
        let remainder = try (consume self) .remainder(divisor: divisor)
        return Division(quotient: quotient, remainder: remainder)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 vs 1
    //=------------------------------------------------------------------------=
    
    @inlinable public static func dividing(_ dividend: consuming Doublet<Self>, by divisor: Self) throws -> Division<Self, Self> {
        let lhsIsLessThanZero = dividend.high/**/.isLessThanZero
        let rhsIsLessThanZero = divisor/*------*/.isLessThanZero
        let minus: Bool = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        var result = Division<Self, Self>(bitPattern: try Magnitude._dividing(TBI.magnitude(of: dividend), by: divisor.magnitude))
        //=--------------------------------------=
        if  minus {
            Overflow.ignore(&result.quotient,  map:{ try $0.negated() })
        }
        
        if  lhsIsLessThanZero {
            Overflow.ignore(&result.remainder, map:{ try $0.negated() })
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
    
    @inline(__always) @inlinable static func _dividing(_ dividend: consuming Doublet<Self>, by divisor: borrowing Self) throws -> Division<Self, Self> {
        if  divisor == 0 {
            throw Overflow()
        }   else if divisor <= dividend.high {
            throw Overflow()
        }   else {
            let result = divisor.base.dividingFullWidth((high: dividend.high.base, low: dividend.low.base))
            return Division(quotient: Self(result.quotient), remainder: Self(result.remainder))
        }
    }
}
