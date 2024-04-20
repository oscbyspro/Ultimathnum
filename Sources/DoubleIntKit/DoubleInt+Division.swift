//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Double Int x Division
//*============================================================================*
//=----------------------------------------------------------------------------=
// TODO: * Moar tests. Moar overflow tests. Moar!
//=----------------------------------------------------------------------------=

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient (_ divisor: Self) -> Fallible<Self> {
        self.division(divisor).map({ $0.quotient  })
    }
    
    @inlinable public consuming func remainder(_ divisor: Self) -> Fallible<Self> {
        self.division(divisor).map({ $0.remainder })
    }
    
    @inlinable public consuming func division (_ divisor: Self) -> Fallible<Division<Self, Self>> {
        Fallible(bitPattern: self.storage.division2222(divisor.storage))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public static func division(_ dividend: consuming Doublet<Self>, by divisor: Self) -> Fallible<Division<Self, Self>> {
        //=--------------------------------------=
        let lhsIsLessThanZero = dividend.high.isNegative
        let rhsIsLessThanZero = divisor/*--*/.isNegative
        //=--------------------------------------=
        var result = Fallible<Division<Self, Self>>(
            bitPattern: Magnitude.division4222(
                dividend.magnitude(), by: divisor.magnitude()
            )
        )
        
        var suboverflow  = Bit( result.value.quotient.high.isNegative)
        if  lhsIsLessThanZero != rhsIsLessThanZero {
            suboverflow &= Bit(!result.value.quotient[{ $0.complement(true) }])
        }
        
        if  lhsIsLessThanZero {
            result.value.remainder = result.value.remainder.complement()
        }
        
        return result.combine(Bool(suboverflow)) as Fallible<Division<Self, Self>>
    }
}

//*============================================================================*
// MARK: * Double Int x Division x Unsigned
//*============================================================================*

extension DoubleInt where Base == Base.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable static func division4222(_ lhs: consuming Doublet<Self>, by rhs: borrowing Self) -> Fallible<Division<Self, Self>> {
        let normalization = rhs.count(0, where: .descending)
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  normalization.load(as: UX.self) == UX(size: Self.self) {
            return Fallible.failure(Division(quotient: 0, remainder: lhs.low))
        }
        //=--------------------------------------=
        var overflow = false
        //=--------------------------------------=
        // quotient does not fit in two halves
        //=--------------------------------------=
        if  rhs <= lhs.high {
            overflow = true
            lhs.high = Self(lhs.high.storage.division2222(rhs.storage, normalization: normalization.storage).remainder)
        }
        //=--------------------------------------=
        return Self.division4222(lhs, by: rhs, normalization: Shift(unchecked: normalization)).combine(overflow)
    }
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable static func division4222(_ lhs: consuming Doublet<Self>, by rhs: Self, normalization: Shift<Self>) -> Division<Self, Self> {
        Swift.assert(rhs > lhs.high, "must not divide by zero and quotient must fit in two halves")
        Swift.assert(rhs.count(0, where: .descending) == normalization.value, "save shift distance")
        //=--------------------------------------=
        // division: 2222
        //=--------------------------------------=
        if  lhs.high == 0 {
            return Division(bitPattern: lhs.low.storage.division2222(rhs.storage, normalization: normalization.value.storage))
        }
        //=--------------------------------------=
        // division: 3121
        //=--------------------------------------=
        if  normalization.value.load(as: UX.self) >= UX(size: Base.self) {
            Swift.assert(lhs.high.high == 0, "quotient must fit in two halves")
            let result = Triplet(low: lhs.low.storage, high: lhs.high.low).division3121(unchecked: rhs.low)
            return Division(quotient: Self(result.quotient), remainder: Self(low: result.remainder))
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        let lhs = lhs.upshift(unchecked: normalization.value)
        let rhs = rhs &<< normalization
        //=--------------------------------------=
        // division: 3212 (normalized)
        //=--------------------------------------=
        if  lhs.high.high == 0, rhs > Self(low: lhs.low.high, high: lhs.high.low) {
            let result = Triplet(low: lhs.low.storage, high: lhs.high.low).division3212(normalized: rhs.storage)
            return Division(quotient: Self(low: result.quotient), remainder: Self(result.remainder) &>> normalization)
        }
        //=--------------------------------------=
        // division: 4222 (normalized)
        //=--------------------------------------=
        let high = Triplet(low: lhs.low.high, high: lhs.high.storage).division3212(normalized: rhs.storage)
        let low  = Triplet(low: lhs.low.low,  high: (high).remainder).division3212(normalized: rhs.storage)
        return Division(quotient: Self(low: low.quotient, high: high.quotient), remainder: Self(low.remainder) &>> normalization)
    }
}
