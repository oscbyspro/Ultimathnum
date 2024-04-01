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
        typealias T = Fallible<Division<Self, Self>>
        //=--------------------------------------=
        let lhsIsLessThanZero: Bool = self   .isLessThanZero
        let rhsIsLessThanZero: Bool = divisor.isLessThanZero
        let minus = (lhsIsLessThanZero) != rhsIsLessThanZero
        //=--------------------------------------=
        var result = T(bitPattern: Magnitude._divide2222(self.magnitude, by: divisor.magnitude))
        //=--------------------------------------=
        if  minus {
            result.value.quotient .capture({ $0.negated().value })
        }
        
        if  lhsIsLessThanZero {
            result.value.remainder.capture({ $0.negated().value })
        }
        
        let overflow = lhsIsLessThanZero && rhsIsLessThanZero && result.value.quotient.isLessThanZero
        //=--------------------------------------=
        return result.combine(overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func division(_ dividend: consuming DoubleIntLayout<Self>, by divisor: Self) -> Fallible<Division<Self, Self>> {
        typealias T = Fallible<Division<Self, Self>>
        //=--------------------------------------=
        let lhsIsLessThanZero: Bool = dividend.high.isLessThanZero
        let rhsIsLessThanZero: Bool = divisor/*--*/.isLessThanZero
        let minus: Bool = (lhsIsLessThanZero) != rhsIsLessThanZero
        //=--------------------------------------=
        var result = T(bitPattern: Magnitude._divide4222(TBI.magnitude(of: dividend), by: (copy divisor).magnitude))
        //=--------------------------------------=
        if  minus {
            result.value.quotient .capture({ $0.negated().value })
        }
        
        if  lhsIsLessThanZero {
            result.value.remainder.capture({ $0.negated().value })
        }
        
        let overflow = minus != result.value.quotient.isLessThanZero && !(minus && result.value.quotient == 0)
        //=--------------------------------------=
        return result.combine(overflow)
    }
}

//*============================================================================*
// MARK: * Double Int x Division x Unsigned
//*============================================================================*

extension DoubleInt where Base == Base.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2222
    //=------------------------------------------------------------------------=
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable static func _divide2222(_ lhs: consuming Self, by rhs: borrowing Self) -> Fallible<Division<Self, Self>> {
        let shift = rhs.count(0, option: .descending)
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  shift.load(as: UX.self) == UX(bitWidth: Self.self) {
            return Fallible.failure(Division(quotient: 0, remainder: lhs))
        }
        //=--------------------------------------=
        return Fallible.success(Self._divide2222(lhs, by: rhs, shift: shift))
    }
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable static func _divide2222(_ lhs: consuming Self, by rhs: Self, shift: consuming Self) -> Division<Self, Self> {
        Swift.assert(rhs != 0, "must not divide by zero")
        Swift.assert(rhs.count(0, option: .descending) == shift, "save shift distance")
        //=--------------------------------------=
        // divisor is greater than or equal
        //=--------------------------------------=
        switch rhs.compared(to: lhs) {
        case Signum.less: break
        case Signum.same: return Division(quotient: 1, remainder: 000)
        case Signum.more: return Division(quotient: 0, remainder: lhs)
        }
        //=--------------------------------------=
        // division: 1111
        //=--------------------------------------=
        if  lhs.high == 0 {
            Swift.assert(rhs.high == 0, "divisors greater than or equal should go fast path")
            let result = lhs.low.division(rhs.low).unwrap()
            return Division(quotient: Self(low: result.quotient), remainder: Self(low: result.remainder))
        }
        //=--------------------------------------=
        // division: 2121
        //=--------------------------------------=
        if  shift.load(as: UX.self) >= UX(bitWidth: Base.self) {
            let result = Self._divide2121(lhs, by: rhs.low)
            return Division(quotient: result.quotient, remainder: Self(low: result.remainder))
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        let lhs = TUI.bitShiftL23(lhs.storage, by: shift.low)
        let rhs = TUI.bitShiftL22(rhs.storage, by: shift.low)
        //=--------------------------------------=
        // division: 3212 (normalized)
        //=--------------------------------------=
        let result = Self._divide3212MSB(lhs, by: Self(rhs))
        return Division(quotient: Self(low: result.quotient), remainder: result.remainder &>> shift)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 4222
    //=------------------------------------------------------------------------=
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable static func _divide4222(_ lhs: consuming DoubleIntLayout<Self>, by rhs: borrowing Self) -> Fallible<Division<Self, Self>> {
        let shift = rhs.count(0, option: .descending)
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  shift.load(as: UX.self) == UX(bitWidth: Self.self) {
            return Fallible.failure(Division(quotient: 0, remainder: lhs.low))
        }
        //=--------------------------------------=
        var overflow = false
        //=--------------------------------------=
        // quotient does not fit in two halves
        //=--------------------------------------=
        if  rhs <= lhs.high {
            overflow = true
            lhs.high = Self._divide2222(lhs.high, by: rhs, shift: shift).remainder
        }
        //=--------------------------------------=
        return Fallible(Self._divide4222(lhs, by: rhs, shift: shift), error: overflow)
    }
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable static func _divide4222(_ lhs: consuming DoubleIntLayout<Self>, by rhs: Self, shift: consuming Self) -> Division<Self, Self> {
        Swift.assert(rhs != 0, "must not divide by zero")
        Swift.assert(rhs.count(0, option: .descending) == shift, "save shift distance")
        Swift.assert(rhs > lhs.high, "quotient must fit in two halves")
        //=--------------------------------------=
        // division: 2222
        //=--------------------------------------=
        if  lhs.high == 0 {
            return Self._divide2222(lhs.low, by: rhs, shift: shift)
        }
        //=--------------------------------------=
        // division: 3121
        //=--------------------------------------=
        if  shift.load(as: UX.self) >= UX(bitWidth: Base.self) {
            Swift.assert(lhs.high.high == 0, "quotient must fit in two halves") // lhs.high < rhs && rhs.high == 0
            let result = Self._divide3121(TripleIntLayout(low: lhs.low.low, mid: lhs.low.high, high: lhs.high.low), by: rhs.low)
            return Division(quotient: result.quotient, remainder: Self(low: result.remainder))
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        let lhs = TUI.bitShiftL22(lhs, by: shift)
        let rhs = TUI.bitShiftL11(rhs, by: shift)
        //=--------------------------------------=
        // division: 3212 (normalized)
        //=--------------------------------------=
        if  lhs.high.high == 0, rhs > Self(low: lhs.low.high, high: lhs.high.low) {
            let result = Self._divide3212MSB(TripleIntLayout(low: lhs.low.low, mid: lhs.low.high, high: lhs.high.low), by: rhs)
            return Division(quotient: Self(low: result.quotient), remainder: result.remainder &>> shift)
        }
        //=--------------------------------------=
        // division: 4222 (normalized)
        //=--------------------------------------=
        let result = Self._divide4222MSB(lhs, by: rhs)
        return Division(quotient: result.quotient, remainder: result.remainder &>> shift)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Special
    //=------------------------------------------------------------------------=
    
    @inlinable static func _divide2121(_ lhs: consuming Self, by rhs: borrowing Base) -> Division<Self, Base> {
        let x1 = lhs.high.division(rhs).unwrap()
        let x0 = x1.remainder == 0 ? lhs.low.division(rhs).unwrap() : Base.division(DoubleIntLayout(low: lhs.low, high: x1.remainder), by: rhs).unwrap()
        return Division(quotient: Self(low: x0.quotient, high: x1.quotient), remainder: x0.remainder)
    }
    
    @inlinable static func _divide3121(_ lhs: consuming TripleIntLayout<Base>, by rhs: Base) -> Division<Self, Base> {
        Swift.assert(rhs > lhs.high, "quotient must fit in two halves")
        let x1 = Base.division(DoubleIntLayout(low: lhs.mid, high: lhs.high), by: rhs).unwrap()
        let x0 = x1.remainder == 0 ? lhs.low.division(rhs).unwrap() : Base.division(DoubleIntLayout(low: lhs.low, high: x1.remainder), by: rhs).unwrap()
        return Division(quotient: Self(low: x0.quotient, high: x1.quotient), remainder: x0.remainder)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Special x Normalized
    //=------------------------------------------------------------------------=
    
    /// Divides 3 halves by 2 normalized halves, assuming the quotient fits in 1 half.
    @inlinable static func _divide3212MSB(_ lhs: consuming TripleIntLayout<Base>, by rhs: borrowing Self) -> Division<Base, Self> {
        Division(bitPattern: TBI.division3212MSB(dividing: lhs, by: rhs.storage))
    }
    
    /// Divides 4 halves by 2 normalized halves, assuming the quotient fits in 2 halves.
    @inlinable static func _divide4222MSB(_ lhs: consuming DoubleIntLayout<Self>, by rhs: borrowing Self) -> Division<Self, Self> {
        let x1 = Self._divide3212MSB(TripleIntLayout(low: lhs.low.high, mid: /**/lhs.high.low, high: /**/lhs.high.high), by: rhs)
        let x0 = Self._divide3212MSB(TripleIntLayout(low: lhs.low.low,  mid: x1.remainder.low, high: x1.remainder.high), by: rhs)
        return Division(quotient: Self(low: x0.quotient, high: x1.quotient), remainder: x0.remainder)
    }
}
