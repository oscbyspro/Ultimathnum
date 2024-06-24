//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Division x Read|Write|Body x Some
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` and `remainder` of dividing `self` by the `divisor`.
    ///
    /// - Requires: The `divisor` must be nonzero.
    ///
    /// - Returns: The `remainder` is returned. Note that the value of the `remainder` is less than the `divisor`.
    ///
    /// - Note: This operation does not need `write` access.
    ///
    /// - Important: This is `unsigned` and `finite`.
    ///
    @inlinable public func remainder(_ divisor: borrowing Divisor<Element>) -> Element {
        var remainder = Element()
        
        for index: IX in self.indices.reversed() {
            let dividend = Doublet(low: self[unchecked: index], high: remainder)
            remainder = Element.division(dividend, by: divisor).unchecked().remainder
        }
        
        return remainder as Element
    }
    
    /// Returns the `quotient` and `remainder` of dividing `self` by the `divisor`.
    ///
    /// - Requires: The `divisor` must be nonzero.
    ///
    /// - Returns: The `quotient` is stored in `self` and the `remainder` is returned.
    ///   Note that the value of the `remainder` is less than the `divisor`.
    ///
    /// - Important: This is `unsigned` and `finite`.
    ///
    @inlinable public func divisionSetQuotientGetRemainder(_ divisor: borrowing Divisor<Element>) -> Element {
        var remainder = Element()
        
        for index: IX in self.indices.reversed() {
            let dividend = Doublet(low: self[unchecked: index], high: remainder)
            let division = Element.division(dividend, by: divisor).unchecked()
            self[unchecked: index] = division.quotient
            ((((((remainder )))))) = division.remainder
        }
        
        return remainder as Element
    }
}

//*============================================================================*
// MARK: * Data Int x Division x Read|Write|Body x Long
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Initializes `self` to the [long][algorithm] `quotient` of dividing the
    /// `dividend` by the `divisor` and forms the `remainder` in the `dividend`.
    ///
    /// - Parameter self: A nonempty buffer of size `dividend.count - divisor.count`.
    ///
    /// - Parameter dividend: The normalized `dividend`. It must be wider than
    ///   the `divisor` and less than `divisor << (Element.size * self.count)`
    ///   to ensure that the `quotient` fits.
    ///
    /// - Parameter divisor: The normalized `divisor`. Its last element's most significant
    ///   bit must be set to ensure that the initial `quotient` element approximation does
    ///   not exceed the real `quotient` by more than 2.
    ///
    /// - Important: The `self` must be uninitialized, or its elements must be trivial.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/long_division
    ///
    @inlinable public func divisionSetQuotientSetRemainderByLong2111MSB(dividing dividend: Self, by divisor: Immutable) {
        Swift.assert(
            self.count >= 1 && self.count == dividend.count - divisor.count,
            "the dividend must be wider than the divisor"
        )
        Swift.assert(
            dividend[unchecked: self.count...].compared(to: divisor) == Signum.less,
            "the quotient must fit in dividend.count - divisor.count elements"
        )
        
        for index in self.indices.reversed() {
            let subsequence = dividend[unchecked: index ..< index &+ divisor.count &+ 1]
            let element = subsequence.divisionGetQuotientSetRemainderByLong2111MSBIteration(divisor)
            self[unchecked: index] = element
        }
    }
    
    /// Forms the `remainder` of dividing the `dividend` by the `divisor`,
    /// then returns the `quotient`. Its arguments must match the arguments
    /// of one long division iteration.
    ///
    /// - Parameter dividend: The current iteration's `remainder` slice from the `quotient`
    ///   element's index. It must be exactly one element wider than the `divisor`.
    ///
    /// - Parameter divisor: The normalized `divisor`. Its last element's most significant
    ///   bit must be set to ensure that the initial `quotient` element approximation does
    ///   not exceed the real `quotient` by more than 2.
    ///
    @inlinable public func divisionGetQuotientSetRemainderByLong2111MSBIteration(_ divisor: Immutable) -> Element {
        Swift.assert(
            divisor.last! >= Element.msb,
            "the divisor must be normalized"
        )
        Swift.assert(
            self.count == divisor.count + 1,
            "the dividend must be one element wider than the divisor"
        )
        Swift.assert(
            self[unchecked: 1...].compared(to: divisor) == Signum.less,
            "the quotient of each iteration must fit in one element"
        )
        
        let numerator = Doublet(
            low:  self[unchecked: self.count &- 2],
            high: self[unchecked: self.count &- 1]
        )
        
        let denominator = Divisor(
            unchecked: divisor[unchecked: divisor.count &- 1]
        )
        
        var quotient = if numerator.high == denominator.value {
            Element.max
        }   else {
            Element.division(numerator, by: denominator).unchecked().quotient
        }
        
        if  quotient.isZero { 
            return quotient
        }
        
        var overflow = self.decrementSubSequence(by: divisor, times: quotient).error
        
        decrementQuotientAtMostTwice: while overflow {
            quotient = quotient.decremented().unchecked()
            overflow = !self.increment(by: divisor).error
        }
        
        Swift.assert(self.compared(to: divisor) == Signum.less)
        return quotient
    }
}
