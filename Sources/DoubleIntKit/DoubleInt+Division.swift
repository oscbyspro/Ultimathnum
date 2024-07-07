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

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(_  divisor: Divisor<Self>) -> Fallible<Self> {
        self.division(divisor).map({ $0.quotient })
    }
    
    @inlinable public consuming func remainder(_ divisor: Divisor<Self>) -> Self {
        self.division(divisor).value.remainder
    }
    
    @inlinable public consuming func division(_  divisor: Divisor<Self>) -> Fallible<Division<Self, Self>> {
        //=--------------------------------------=
        let lhsIsNegative = /*-----*/self.isNegative
        let rhsIsNegative = divisor.value.isNegative
        //=--------------------------------------=
        // error: quotient > U.max
        // error: quotient < U.max.times(-1)
        //=--------------------------------------=
        var division = Division<Self, Self>(
            raw: self.magnitude().division2222(divisor.magnitude())
        )
        //=--------------------------------------=
        // suberror: quotient > S.max or
        // suberror: quotient < S.min
        // negative: quotient > S.max or
        // negative: quotient < S.max.times(-1)
        // negative: case is S.min.division(±1)
        //=--------------------------------------=
        var suberror = lhsIsNegative == rhsIsNegative
        if  suberror {
            suberror = (division).quotient.isNegative
        }   else {
            division.quotient = division.quotient.complement()
        }
        
        if  lhsIsNegative {
            division.remainder = division.remainder.complement()
        }
        
        return division.veto(suberror)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Composition
    //=------------------------------------------------------------------------=
    
    @inlinable public static func division(_ dividend: consuming Doublet<Self>, by divisor: Divisor<Self>) -> Fallible<Division<Self, Self>> {
        //=--------------------------------------=
        let lhsIsNegative = dividend.high.isNegative
        let rhsIsNegative = divisor.value.isNegative
        //=--------------------------------------=
        // error: quotient > U.max or
        // error: quotient < U.max.times(-1)
        //=--------------------------------------=
        var division = Fallible<Division<Self, Self>>(
            raw: Magnitude.division4222(
                dividend.magnitude(), by: divisor.magnitude()
            )
        )
        //=--------------------------------------=
        // suberror: quotient > S.max or
        // suberror: quotient < S.min
        // negative: quotient > S.max or
        // negative: quotient < S.max.times(-1)
        //=--------------------------------------=
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
// MARK: * Double Int x Division x Unsigned
//*============================================================================*

extension DoubleInt where Base == Base.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1
    //=------------------------------------------------------------------------=
    
    @inlinable internal consuming func division2121(unchecked divisor: Divisor<Base>) -> Division<Self, Base> {
        let high = self.high.division(divisor).unchecked()
        let low  = Base.division(Doublet(low:   self.low, high: high.remainder), by: divisor).unchecked()
        return Division(quotient: Self(low: low.quotient, high: high.quotient), remainder: low.remainder)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2
    //=------------------------------------------------------------------------=
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable internal consuming func division2222(_ divisor: consuming Divisor<Self>) -> Division<Self, Self> {
        self.division2222(divisor, normalization: Shift(unchecked: divisor.value.descending(Bit.zero)))
    }
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable internal consuming func division2222(_ divisor: consuming Divisor<Self>, normalization: Shift<Self>) -> Division<Self, Self> {
        //=--------------------------------------=
        Swift.assert(!divisor .value.isZero, "must not divide by zero")
        Swift.assert((divisor).value.descending(Bit.zero) == normalization.value, "save shift distance")
        //=--------------------------------------=
        // divisor is greater than or equal
        //=--------------------------------------=
        switch divisor.value.compared(to: self) {
        case Signum.less: break
        case Signum.same: return Division(quotient: Self(low: 1), remainder: Self(low: 0))
        case Signum.more: return Division(quotient: Self(low: 0), remainder: self)
        }
        //=--------------------------------------=
        // division: 1111
        //=--------------------------------------=
        if  self.high.isZero {
            Swift.assert(self.high.isZero, "dividend must fit in one half")
            Swift.assert(divisor.value.high.isZero, "divisor must fit in one half")
            let result: Division<Base, Base> = self.low.division(Divisor(unchecked: divisor.value.low)).unchecked()
            return Division(quotient: Self(low: result.quotient), remainder: Self(low: result.remainder))
        }
        //=--------------------------------------=
        // division: 2121
        //=--------------------------------------=
        guard let normalization = Shift<Base>(exactly: normalization.value) else {
            Swift.assert(divisor.value.high.isZero, "divisor must fit in one half")
            let result: Division<Self, Base> = self.division2121(unchecked: Divisor(unchecked: divisor.value.low))
            return Division(quotient: result.quotient, remainder: Self(low: result.remainder))
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        let top = normalization.inverse().map({ self.high.down($0) }) ?? Base.zero
        let lhs = TripleInt(low: self.up(normalization).storage, high: consume top)
        let rhs = Divisor(unchecked: divisor.value.up(normalization))
        //=--------------------------------------=
        // division: 3212 (normalized)
        //=--------------------------------------=
        let result: Division<Base, Self> =  lhs.division3212(normalized: rhs)
        return Division(quotient: Self(low: result.quotient), remainder: result.remainder.down(normalization))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 4 by 2 (nonrecursive)
    //=------------------------------------------------------------------------=
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable internal static func division4222(_ lhs: consuming Doublet<Self>, by rhs: Divisor<Self>) -> Fallible<Division<Self, Self>> {
        //=--------------------------------------=
        let normalization = Shift<Self>(unchecked: rhs.value.descending(Bit.zero))
        //=--------------------------------------=
        // if quotient does not fit in two halves
        //=--------------------------------------=
        let overflow = lhs.high >= rhs.value
        if  overflow {
            lhs.high = Self(lhs.high.division2222( rhs, normalization: normalization).remainder)
        }
        //=--------------------------------------=
        return Fallible(Self.division4222(lhs, by: rhs, normalization: normalization), error: overflow)
    }
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable internal static func division4222(_ lhs: consuming Doublet<Self>, by rhs: consuming Divisor<Self>, normalization: Shift<Self>) -> Division<Self, Self> {
        //=--------------------------------------=
        Swift.assert(rhs.value > lhs.high, "quotient must fit in two halves")
        Swift.assert(rhs.value.descending(Bit.zero) == normalization.value, "save shift distance")
        //=--------------------------------------=
        // division: 2222
        //=--------------------------------------=
        if  lhs.high.isZero {
            Swift.assert(lhs.high.isZero, "dividend must fit in two halves")
            return lhs.low.division2222(rhs, normalization: normalization)
        }
        //=--------------------------------------=
        // division: 3121
        //=--------------------------------------=
        guard let normalization = Shift<Base>(exactly: normalization.value) else {
            Swift.assert(rhs.value.high.isZero,  "divisor must fit in one half")
            Swift.assert(lhs.high .high.isZero, "quotient must fit in two halves")
            let result = TripleInt(low: lhs.low.storage, high: lhs.high.low).division3121(unchecked: Divisor(unchecked: rhs.value.low))
            return Division(quotient: Self(result.quotient), remainder: Self(low: result.remainder))
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        let lhs = lhs .up(Shift(unchecked:  normalization.value))
        let rhs = Divisor(unchecked: rhs.value.up(normalization))
        //=--------------------------------------=
        // division: 3212 (normalized)
        //=--------------------------------------=
        if  lhs.high.high.isZero, rhs.value > Self(low: lhs.low.high, high: lhs.high.low) {
            Swift.assert(lhs.high .high.isZero, "dividend must fit in three halves")
            Swift.assert(rhs.value.high >= Base.msb, "divisor must be normalized")
            Swift.assert(rhs.value > Self(low: lhs.low.high, high: lhs.high.low), "quotient must fit in one half")
            let result = TripleInt(low: lhs.low.storage, high: lhs.high.low).division3212(normalized: rhs)
            return Division(quotient: Self(low: result.quotient), remainder: result.remainder.down(normalization))
        }
        //=--------------------------------------=
        // division: 4222 (normalized)
        //=--------------------------------------=
        always: do {
            Swift.assert(rhs.value.high >= Base.msb, "divisor must be normalized")
            let high = TripleInt(low: lhs.low.high, high: lhs .high     .storage).division3212(normalized: rhs)
            let low  = TripleInt(low: lhs.low.low,  high: high.remainder.storage).division3212(normalized: rhs)
            return Division(quotient: Self(low: low.quotient, high: high.quotient), remainder: low.remainder.down(normalization))
        }
    }
}
