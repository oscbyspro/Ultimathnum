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
// MARK: * Doublet x Division
//*============================================================================*

extension Doublet {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1
    //=------------------------------------------------------------------------=
    
    @inlinable package consuming func division2111(_ divisor: Base) -> Fallible<Division<Base, Base>> {
        Base.division(self, by: divisor)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2
    //=------------------------------------------------------------------------=
    
    @inlinable package consuming func division2222(_ divisor: Self) -> Fallible<Division<Self, Self>> {
        //=--------------------------------------=
        let lhsIsLessThanZero = self   .high.isNegative
        let rhsIsLessThanZero = divisor.high.isNegative
        //=--------------------------------------=
        var result = Fallible<Division<Self, Self>>(
            bitPattern: self.magnitude().division2222(divisor.magnitude())
        )
        
        var suboverflow  = Bit( result.value.quotient.high.isNegative)
        if  lhsIsLessThanZero != rhsIsLessThanZero {
            suboverflow &= Bit(!result.value.quotient[{ $0.complement(true) }])
        }
        
        if  lhsIsLessThanZero {
            result.value.remainder = result.value.remainder.complement()
        }
        
        return result.combine(Bool(suboverflow))
    }
}

//*============================================================================*
// MARK: * Double x Division x Unsigned
//*============================================================================*

extension Doublet where Base == Base.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func division2121(unchecked divisor: Base) -> Division<Self, Base> {
        Swift.assert(divisor != 0, "must not divide by zero")
        let high = self.high.division(divisor).assert()
        let low  = Self(low: self.low, high: high.remainder).division2111(divisor).assert()
        return Division(quotient: Self(low: low.quotient, high: high.quotient), remainder: low.remainder)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2
    //=------------------------------------------------------------------------=
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable consuming func division2222(_ divisor: borrowing Self) -> Fallible<Division<Self, Self>> {
        let normalization = divisor.count(0, where: .descending)
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  normalization.load(as: UX.self) == Self.size.load(as: UX.self) {
            return Fallible.failure(Division(quotient: Self(low: 0, high: 0), remainder: self))
        }
        //=--------------------------------------=
        return Fallible.success(self.division2222(divisor, normalization: normalization))
    }
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable consuming func division2222(_ divisor: Self, normalization: consuming Self) -> Division<Self, Self> {
        Swift.assert(divisor != Self(low: 0, high: 0), "must not divide by zero")
        Swift.assert(divisor.count(0, where: .descending) == normalization, "save shift distance")
        //=--------------------------------------=
        // divisor is greater than or equal
        //=--------------------------------------=
        switch divisor.compared(to: self) {
        case Signum.less: break
        case Signum.same: return Division(quotient: Self(low: 1, high: 0), remainder: Self(low: 0, high: 0))
        case Signum.more: return Division(quotient: Self(low: 0, high: 0), remainder: self)
        }
        //=--------------------------------------=
        // division: 1111
        //=--------------------------------------=
        if  self.high == 0 {
            let result: Division<Base, Base> = self.low.division(divisor.low).assert()
            return Division(quotient: Self(low: result.quotient, high: 0), remainder: Self(low: result.remainder, high: 0))
        }
        //=--------------------------------------=
        // division: 2121
        //=--------------------------------------=
        if  normalization.load(as: UX.self) >= UX(size: Base.self) {
            let result: Division<Self, Base> = self.division2121(unchecked: divisor.low)
            return Division(quotient: result.quotient, remainder: Self(low: result.remainder, high: 0))
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        let top = normalization.low == 0 ? 0 : self.high &>> normalization.low.complement()
        let lhs = self   .upshift(unchecked: normalization)
        let rhs = divisor.upshift(unchecked: normalization)
        //=--------------------------------------=
        // division: 3212 (normalized)
        //=--------------------------------------=
        let result: Division<Base, Self> = Triplet(low: lhs, high: top).division3212(normalized: rhs)
        return Division(quotient: Self(low: result.quotient, high: 0), remainder: result.remainder.downshift(unchecked: normalization))
    }
}
