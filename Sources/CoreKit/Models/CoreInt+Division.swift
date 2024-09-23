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

extension CoreInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func quotient (_ divisor: Nonzero<Self>) -> Fallible<Self> {
        Swift.assert(!divisor.value.isZero, String.brokenInvariant())
        let result = self.stdlib().dividedReportingOverflow(by: divisor.value.stdlib())
        return Self(result.partialValue).veto(Self.isSigned && result.overflow)
    }
    
    @inlinable public func remainder(_ divisor: Nonzero<Self>) -> Self {
        Swift.assert(!divisor.value.isZero, String.brokenInvariant())
        let result = self.stdlib().remainderReportingOverflow(dividingBy: divisor.value.stdlib())
        return Self(result.partialValue)
    }
    
    @inlinable public func division (_ divisor: Nonzero<Self>) -> Fallible<Division<Self, Self>> {
        let quotient  = self.quotient (divisor)
        let remainder = self.remainder(divisor)
        let division  = Division(quotient: quotient.value, remainder: remainder)
        return Fallible(division,   error: quotient.error)
    }
}

//*============================================================================*
// MARK: * Core Int x Division x Signed
//*============================================================================*

extension CoreInteger where Self: SignedInteger, Stdlib: Swift.SignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func division(_ dividend: Doublet<Self>, by divisor: Nonzero<Self>) -> Fallible<Division<Self, Self>> {
        //=--------------------------------------=
        // error...: quotient ∉ [-U.max, U.max]
        // suberror: quotient ∉ [ S.min, S.max]
        // negative: quotient ∉ [-S.max, S.max]
        //=--------------------------------------=
        let lhsIsNegative = dividend.high.isNegative
        let rhsIsNegative = divisor.value.isNegative
        
        var division = Fallible<Division<Self, Self>>(
            raw: Magnitude.division(
                dividend.magnitude(), by: divisor.magnitude()
            )
        )
        
        var suberror = division.value.quotient.isNegative
        if  lhsIsNegative != rhsIsNegative {
            let complement = division.value.quotient.complement(true)
            suberror = !complement.error && suberror
            division.value.quotient = complement.value
        }
        
        if  lhsIsNegative {
            division.value.remainder = division.value.remainder.complement()
        }
        
        return division.veto(suberror)
    }
}

//*============================================================================*
// MARK: * Core Int x Division x Unsigned
//*============================================================================*

extension CoreInteger where Self: UnsignedInteger, Stdlib: Swift.UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func division(_ dividend: Doublet<Self>, by divisor: Nonzero<Self>) -> Fallible<Division<Self, Self>> {
        //=--------------------------------------=
        var dividend = dividend // consuming fix
        //=--------------------------------------=
        let overflow = dividend.high >= divisor.value
        if  overflow {
            dividend.high = dividend.high.remainder(divisor)
        }
        //=--------------------------------------=
        // TODO: custom 2-by-1 division algorithm
        //=--------------------------------------=
        let result = divisor.value.stdlib().dividingFullWidth((high: dividend.high.stdlib(), low: dividend.low.stdlib()))
        return Division(quotient: Self(result.quotient), remainder: Self(result.remainder)).veto(overflow)
    }
}
