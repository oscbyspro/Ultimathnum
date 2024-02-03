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
// MARK: * Double Int x Division
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(divisor: Self) throws -> Self {
        let result = Overflow.capture({ try self.divided(by: divisor) })
        return try Overflow.resolve(result.value.quotient, overflow: result.overflow)
    }
    
    @inlinable public consuming func remainder(divisor: Self) throws -> Self {
        let result = Overflow.capture({ try self.divided(by: divisor) })
        return try Overflow.resolve(result.value.remainder, overflow: result.overflow)
    }
    
    @inlinable public func divided(by divisor: Self) throws -> Division<Self> {
        let lhsIsLessThanZero: Bool = self.isLessThanZero
        let rhsIsLessThanZero: Bool = divisor.isLessThanZero
        let minus = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        var result = Overflow<Division<Self>>.Result(bitPattern: Magnitude._divide2222(self.magnitude, by: divisor.magnitude))
        //=--------------------------------------=
        if  minus {
            result.value.quotient  = ~result.value.quotient  &+ 1
        }

        if  lhsIsLessThanZero {
            result.value.remainder = ~result.value.remainder &+ 1
        }
        
        if  lhsIsLessThanZero && rhsIsLessThanZero && result.value.quotient.isLessThanZero {
            result.overflow = true
        }
        //=--------------------------------------=
        return try result.resolve() as Division<Self>
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func dividing(_ dividend: consuming Doublet<Self>, by divisor: Self) throws -> Division<Self> {
        let lhsIsLessThanZero: Bool = dividend.high.isLessThanZero
        let rhsIsLessThanZero: Bool = (((divisor))).isLessThanZero
        let minus = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        var result = Division<Self>(bitPattern: try Magnitude._divide4222(TBI.magnitude(of: dividend), by: divisor.magnitude))
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
        return result as Division<Self>
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
    @inlinable static func _divide2222(_ lhs: Self, by rhs: Self) -> Overflow<Division<Self>>.Result {
        let shift = rhs.count(0, option: .descending)
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  shift.load(as: UX.self) == Self.bitWidth.load(as: UX.self) {
            return Overflow.Result(Division(quotient: lhs, remainder: lhs), overflow: true)
        }
        //=--------------------------------------=
        return Overflow.Result(Self._divide2222(lhs, by: rhs, shift: shift), overflow: false)
    }
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable static func _divide2222(_ lhs: Self, by rhs: Self, shift: Self) -> Division<Self> {
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
            let result = try! lhs.low.divided(by: rhs.low)
            return Division(quotient: Self(low: result.quotient), remainder: Self(low: result.remainder))
        }
        //=--------------------------------------=
        // division: 2121
        //=--------------------------------------=
        if  shift.load(as: UX.self) >= Base.bitWidth.load(as: UX.self) {
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
    @inlinable static func _divide4222(_ lhs: Doublet<Self>, by rhs: Self) throws -> Division<Self> {
        let shift = rhs.count(0, option: .descending)
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  shift.load(as: UX.self) == Self.bitWidth.load(as: UX.self) {
            throw Overflow()
        }
        //=--------------------------------------=
        // quotient does not fit in two halves
        //=--------------------------------------=
        if  rhs <= lhs.high {
            throw Overflow()
        }
        //=--------------------------------------=
        return Self._divide4222(lhs, by: rhs, shift: shift)
    }
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable static func _divide4222(_ lhs: Doublet<Self>, by rhs: Self, shift: Self) -> Division<Self> {
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
        if  shift.load(as: UX.self) >= Base.bitWidth.load(as: UX.self) {
            Swift.assert(lhs.high.high == 0, "quotient must fit in two halves") // lhs.high < rhs && rhs.high == 0
            let result = Self._divide3121(Triplet(low: lhs.low.low, mid: lhs.low.high, high: lhs.high.low), by: rhs.low)
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
        if  lhs.high.high == 0, rhs > Self(high: lhs.high.low, low: lhs.low.high) {
            let result = Self._divide3212MSB(Triplet(low: lhs.low.low, mid: lhs.low.high, high: lhs.high.low), by: rhs)
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
    
    @inlinable static func _divide2121(_ lhs: Self, by rhs: Base) -> (quotient: Self, remainder: Base) {
        let x = try! lhs.high.divided(by: rhs)
        let y = x.remainder == 0 ? try! lhs.low.divided(by: rhs) : try! Base.dividing(Doublet(low: lhs.low, high: x.remainder), by: rhs)
        return (quotient: Self(high: x.quotient, low: y.quotient), remainder: y.remainder)
    }
    
    @inlinable static func _divide3121(_ lhs: Triplet<Base>, by rhs: Base) -> (quotient: Self, remainder: Base) {
        Swift.assert(rhs > lhs.high, "quotient must fit in two halves")
        let x = try! Base.dividing(Doublet(low: lhs.mid, high: lhs.high), by: rhs)
        let y = x.remainder == 0 ? try! lhs.low.divided(by: rhs) : try! Base.dividing(Doublet(low: lhs.low, high: x.remainder), by: rhs)
        return (quotient: Self(high: x.quotient, low: y.quotient), remainder: y.remainder)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Special x Normalized
    //=------------------------------------------------------------------------=
    
    /// Divides 3 halves by 2 normalized halves, assuming the quotient fits in 1 half.
    @inlinable static func _divide3212MSB(_ lhs: Triplet<Base>, by rhs: Self) -> (quotient: Base, remainder: Self) {
        var remainder = lhs as Triplet<Base>
        let quotient  = TUI.formRemainderWithQuotient3212MSB(dividing: &remainder, by: rhs.storage)
        return (quotient, Self(high: remainder.mid, low: remainder.low))
    }
    
    /// Divides 4 halves by 2 normalized halves, assuming the quotient fits in 2 halves.
    @inlinable static func _divide4222MSB(_ lhs: Doublet<Self>, by rhs: Self) -> (quotient: Self, remainder: Self) {
        let x = Self._divide3212MSB(Triplet(low: lhs.low.high, mid:    lhs.high.low, high:    lhs.high.high), by: rhs)
        let y = Self._divide3212MSB(Triplet(low: lhs.low.low , mid: x.remainder.low, high: x.remainder.high), by: rhs)
        return (quotient: Self(high: x.quotient, low: y.quotient), remainder: y.remainder)
    }
}
