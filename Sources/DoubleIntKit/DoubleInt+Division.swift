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
// TODO: Try using DataInt<Element> division (simpler, one algorithm).
//=----------------------------------------------------------------------------=

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2 as 2 and 2
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient(_  divisor: Nonzero<Self>) -> Optional<Fallible<Self>> {
        self.division(divisor).map({ $0.quotient })
    }
    
    @inlinable public consuming func remainder(_ divisor: Nonzero<Self>) -> Optional<Self> {
        self.division(divisor).value.remainder
    }
    
    @inlinable public consuming func division(_  divisor: Nonzero<Self>) -> Optional<Fallible<Division<Self, Self>>> {
        //=--------------------------------------=
        // error...: quotient ∉ [-U.max, U.max]
        // suberror: quotient ∉ [ S.min, S.max]
        // negative: quotient ∉ [-S.max, S.max]
        //=--------------------------------------=
        // error...: case is unreachable
        // negative: case is S.min.division(±1)
        //=--------------------------------------=
        let lhsIsNegative = /*-----*/self.isNegative
        let rhsIsNegative = divisor.value.isNegative
        
        var division = Division<Self, Self>(
            raw: self.magnitude().division2222(divisor.magnitude())
        )
        
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
    // MARK: Transformations x 4 by 2 as 2 and 2
    //=------------------------------------------------------------------------=
    
    @inlinable public static func division(_ dividend: consuming Doublet<Self>, by divisor: Nonzero<Self>) -> Fallible<Division<Self, Self>> {
        //=--------------------------------------=
        // error...: quotient ∉ [-U.max, U.max]
        // suberror: quotient ∉ [ S.min, S.max]
        // negative: quotient ∉ [-S.max, S.max]
        //=--------------------------------------=
        let lhsIsNegative = dividend.high.isNegative
        let rhsIsNegative = divisor.value.isNegative
        
        var division = Fallible<Division<Self, Self>>(
            raw: Magnitude.division4222(
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
// MARK: * Double Int x Division x Unsigned
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension DoubleInt where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2 as 2 and 2
    //=------------------------------------------------------------------------=
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable internal consuming func division2222(_ divisor: Nonzero<Self>) -> Division<Self, Self> {
        self.division2222(divisor, normalization: Shift(unchecked: divisor.value.descending(Bit.zero)))
    }
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable internal consuming func division2222(_ divisor: Nonzero<Self>, normalization: Shift<Self>) -> Division<Self, Self> {
        Swift.assert(!divisor .value.isZero, "must not divide by zero")
        Swift.assert((divisor).value.descending(Bit.zero) == normalization.value, "save shift distance")
        //=--------------------------------------=
        // division: dividend <= divisor
        //=--------------------------------------=
        switch self.compared(to: divisor.value) {
        case Signum.positive: break
        case Signum.zero:     return Division(quotient: Self(low: 1), remainder: Self(low: 0))
        case Signum.negative: return Division(quotient: Self(low: 0), remainder: self)
        }
        //=--------------------------------------=
        // division: 1111
        //=--------------------------------------=
        if  self.high.isZero {
            Swift.assert(self.high.isZero, "dividend must fit in one half")
            Swift.assert(divisor.value.high.isZero, "divisor must fit in one half")
            let result: Division<High, High> = self.low.division(Nonzero(unchecked:   divisor.value.low))
            return Division(quotient: Self(low: result.quotient), remainder: Self(low: result.remainder))
        }
        //=--------------------------------------=
        // division: 2121
        //=--------------------------------------=
        guard let normalization = Shift<High>(exactly: normalization.value) else {
            Swift.assert(divisor.value.high.isZero, "divisor must fit in one half")
            let divisor = Nonzero(unchecked: divisor.value.low)            
            let high = self.high.division(divisor).components()
            let low  = High.division( Doublet(low:  self.low, high: high.remainder), by: divisor).unchecked()
            return Division(quotient: Self(low: low.quotient, high: high.quotient ), remainder: Self(low: low.remainder))
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        let top = normalization.inverse().map({ self.high.down($0) }) ?? High.zero
        let lhs = self.storage.up(normalization)
        let rhs = Nonzero(unchecked: Self(divisor.value.storage.up(normalization)))
        //=--------------------------------------=
        // division: 3212 (normalized)
        //=--------------------------------------=
        let result: Division<High, Self> = Self.division3212MSB(lhs.low, lhs.high, top, by: rhs.value)
        return Division(quotient: Self(low: result.quotient), remainder: Self(result.remainder.storage.down(normalization)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 4 by 2 as 2 and 2
    //=------------------------------------------------------------------------=
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable internal static func division4222(
        _ lhs: consuming Doublet<Self>, by rhs: Nonzero<Self>
    )   ->  Fallible<Division<Self, Self>> {
        
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
    @inlinable internal static func division4222(
        _ lhs: consuming Doublet<Self>, by rhs: consuming Nonzero<Self>, normalization: Shift<Self>
    )   -> Division<Self, Self> {
        
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
        guard let normalization = Shift<High>(exactly: normalization.value) else {
            Swift.assert(lhs.high .high.isZero, "quotient must fit in two halves")
            Swift.assert(rhs.value.high.isZero,  "divisor must fit in one half")
            Swift.assert(rhs.value.low > lhs.high.low, "quotient must fit in two halves")
            let divisor = Nonzero(unchecked: rhs.value.low)
            let high = High.division(Doublet(low: lhs.low.high, high: lhs.high.low  ), by: divisor).unchecked()
            let low  = High.division(Doublet(low: lhs.low.low,  high: high.remainder), by: divisor).unchecked()
            return Division(quotient:   Self(low: low.quotient, high: high.quotient ), remainder: Self(low: low.remainder))
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        let lhs = lhs.up(Shift(unchecked: normalization.value))
        let rhs = Nonzero(unchecked: Self(rhs.value.storage.up(normalization)))
        //=--------------------------------------=
        // division: 3212 (normalized)
        //=--------------------------------------=
        if  lhs.high.high.isZero, rhs.value > Self(low: lhs.low.high, high: lhs.high.low) {
            Swift.assert(lhs.high .high.isZero, "dividend must fit in three halves")
            Swift.assert(rhs.value.high >= High.msb, "divisor must be normalized")
            Swift.assert(rhs.value > Self(low: lhs.low.high, high: lhs.high.low), "quotient must fit in one half")
            let result = Self.division3212MSB(lhs.low.low, lhs.low.high, lhs.high.low, by: rhs.value)
            return Division(quotient: Self(low: result.quotient), remainder: Self(result.remainder.storage.down(normalization)))
        }
        //=--------------------------------------=
        // division: 4222 (normalized)
        //=--------------------------------------=
        Swift.assert(rhs.value.high >= High.msb, "divisor must be normalized")
        let high = Self.division3212MSB(lhs.low.high,      lhs.high.low,       lhs.high.high, by: rhs.value)
        let low  = Self.division3212MSB(lhs.low.low, high.remainder.low, high.remainder.high, by: rhs.value)
        return Division(quotient: Self(low: low.quotient, high: high.quotient), remainder: Self(low.remainder.storage.down(normalization)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 3 by 2 as 1 and 2
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - Todo: Use 2-by-2 remainder computations instead of 3-by-3.
    ///
    @inlinable internal static func division3212MSB(
        _ low:  consuming Low,
        _ mid:  consuming Low,
        _ high: consuming High,
        by divisor: Self
    )   -> Division<High, Self> {
        
        Swift.assert(divisor.high >= High.msb, "the divisor must be normalized")
        Swift.assert(Self(low: copy mid, high: copy high) < divisor, "the quotient must fit in one half")
        
        var quotient: High = if divisor.high == high {
            High.max // must fit in one part
        }   else {
            High.division(Doublet(low: mid, high: high), by: Nonzero(unchecked: divisor.high)).unchecked().quotient
        }
        
        var error = false
        let divQ0 = divisor.low .multiplication(quotient)
        var divQ1 = divisor.high.multiplication(quotient)
        
        (divQ1.low,   error) = divQ1.low .plus((divQ0.high)).components()
        (divQ1.high,  error) = divQ1.high.incremented(error).components()
        Swift.assert(!error)
        
        (low,  error) = low .minus(divQ0.low).components()
        (mid,  error) = mid .minus(divQ1.low,  plus: error).components()
        (high, error) = high.minus(divQ1.high, plus: error).components()
        
        overestimated: while error {
            quotient = quotient.decremented().unchecked()
            
            error = false
            (low,  error) = low .plus(divisor.low ).components()
            (mid,  error) = mid .plus(divisor.high, plus: error).components()
            (high, error) = high.incremented(error).components()
            error.toggle()
        }
        
        Swift.assert((copy high).isZero, "remainder must fit in two halves")
        Swift.assert(Self(low: copy low, high: copy mid) < divisor, "remainder must be less than divisor")
        return Division(quotient: quotient, remainder: Self(low: low, high: mid))
    }
}
