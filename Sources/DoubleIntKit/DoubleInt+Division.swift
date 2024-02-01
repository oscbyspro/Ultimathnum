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
            result.value.quotient  = ~result.value.quotient &+ 1
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
        var result = Overflow<Division<Self>>.Result(bitPattern: Magnitude._divide4222(TBI.magnitude(of: dividend), by: divisor.magnitude))
        //=--------------------------------------=
        if  minus {
            result.value.quotient  = ~result.value.quotient &+ 1
        }
        
        if  lhsIsLessThanZero {
            result.value.remainder = ~result.value.remainder &+ 1
        }
        
        if  minus != result.value.quotient.isLessThanZero {
            result.overflow = result.overflow || !(minus && result.value.quotient == 0)
        }
        //=--------------------------------------=
        return try result.resolve() as Division<Self>
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
        let comparison: Signum = rhs.compared(to: lhs)
        if  comparison >= 0 {
            switch comparison == Signum.same {
            case  true: return Division(quotient: 1, remainder: 000)
            case false: return Division(quotient: 0, remainder: lhs)
            }
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
    @inlinable static func _divide4222(_ lhs: Doublet<Self>, by rhs: Self) -> Overflow<Division<Self>>.Result {
        let shift = rhs.count(0, option: .descending)
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  shift.load(as: UX.self) == Self.bitWidth.load(as: UX.self) {
            return Overflow.Result(Division(quotient: lhs.low, remainder: lhs.low), overflow: true)
        }
        //=--------------------------------------=
        // quotient does not fit in two halves
        //=--------------------------------------=
        if  rhs <= lhs.high {
            let high = Self._divide2222(lhs.high,  by: rhs, shift: shift)
            let truncated = Doublet<Self>(high: high.remainder, low: lhs.low)
            return Overflow.Result(Self._divide4222(truncated, by: rhs, shift: shift), overflow: true)
        }
        //=--------------------------------------=
        return Overflow.Result(Self._divide4222(lhs, by: rhs, shift: shift), overflow: false)
    }
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable static func _divide4222(_ lhs: Doublet<Self>, by rhs: Self, shift: Self) -> Division<Self> {
        assert(rhs != 0, "must not divide by zero")
        assert(rhs.count(0, option: .descending) == shift, "save shift distance")
        assert(rhs > lhs.high, "quotient must fit in two halves")
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
            assert(lhs.high.high == 0, "quotient must fit in two halves") // because  lhs.high < rhs && rhs.high == 0
            let result = Self._divide3121(Triplet(high: lhs.high.low, mid: lhs.low.high, low: lhs.low.low), by: rhs.low)
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
            let result = Self._divide3212MSB(Triplet(high: lhs.high.low, mid: lhs.low.high, low: lhs.low.low), by: rhs)
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
    
    @inlinable static func _divide2121(_ lhs: Self, by rhs: High) -> (quotient: Self, remainder: High) {
        let (x, a) = try! lhs.high.divided(by: rhs).components
        let (y, b) = a == 0 ? try! lhs.low.divided(by: rhs).components : try! High.dividing(Doublet(high: a, low: lhs.low), by: rhs).components
        return (quotient: Self(high: x, low: y), remainder: b)
    }
    
    @inlinable static func _divide3121(_ lhs: Triplet<High>, by rhs: High) -> (quotient: Self, remainder: High) {
        Swift.assert(rhs > lhs.high, "quotient must fit in two halves")
        let (x, a) = try! High.dividing(Doublet(high: lhs.high, low: lhs.low), by: rhs).components
        let (y, b) = a == 0 ? try! lhs.low.divided(by: rhs).components : try! High.dividing(Doublet(high: a, low: lhs.low), by: rhs).components
        return (quotient: Self(high: x, low: y), remainder: b)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Special x Normalized
    //=------------------------------------------------------------------------=
    
    /// Divides 3 halves by 2 normalized halves, assuming the quotient fits in 1 half.
    @inlinable static func _divide3212MSB(_ lhs: Triplet<High>, by rhs: Self) -> (quotient: High, remainder: Self) {
        var remainder = lhs as Triplet<High>
        let quotient  = TUI.formRemainderWithQuotient3212MSB(dividing: &remainder, by: rhs.storage)
        return (quotient, Self(high: remainder.mid, low: remainder.low))
    }
    
    /// Divides 4 halves by 2 normalized halves, assuming the quotient fits in 2 halves.
    @inlinable static func _divide4222MSB(_ lhs: Doublet<Self>, by rhs: Self) -> (quotient: Self, remainder: Self) {
        let (x, a) =  Self._divide3212MSB(Triplet(high: lhs.high.high, mid: lhs.high.low, low: lhs.low.high), by: rhs)
        let (y, b) =  Self._divide3212MSB(Triplet(high: /*---*/a.high, mid: /*---*/a.low, low: lhs.low.low ), by: rhs)
        return (quotient: Self(high: x, low: y), remainder: b)
    }
}
