//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Strict Unsigned Integer x Division x Long
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + where Base is Unsafe Buffer Pointer
//=----------------------------------------------------------------------------=

extension Namespace.StrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Initializes `base` to the [long][algorithm] `quotient` of dividing the
    /// `dividend` by the `divisor` and forms the `remainder` in the `dividend`.
    ///
    /// - Parameter base: A nonempty buffer of size `dividend.count - divisor.count`.
    ///
    /// - Parameter dividend: The normalized `dividend`. It must be wider than
    ///   the `divisor` and less than `divisor << (Element.bitWidth * base.count)`
    ///   to ensure that the `quotient` fits.
    ///
    /// - Parameter divisor: The normalized `divisor`. Its last element's most significant
    ///   bit must be set to ensure that the initial `quotient` element approximation does
    ///   not exceed the real `quotient` by more than 2.
    ///
    /// - Important: The `base` must be uninitialized, or its elements must be trivial.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/long_division
    ///
    /// ## Example Usage in Long Division Algorithm
    ///
    /// ```swift
    /// // try fast path
    /// // normalization
    ///
    /// var quotient = uninitialized(remainder.count - divisor.count) {
    ///     initializeToQuotientFormRemainderByLongAlgorithm2111MSB(&$0, dividing: &dividend, by: divisor)
    /// }
    ///
    /// // normalization
    /// // return values
    /// ```
    ///
    @inlinable package static func initializeToQuotientFormRemainderByLongAlgorithm2111MSB<T>(
    _ base: inout Base, dividing dividend: inout Base, by divisor: UnsafeBufferPointer<T>) where
    Base == UnsafeMutableBufferPointer<T> {
        //=--------------------------------------=
        Swift.assert(base.count >= 1 && base.count == dividend.count - divisor.count,
        "the dividend must be wider than the divisor")
        
        Swift.assert(SUISS.compare(dividend.dropFirst(base.count), to: divisor) == -1,
        "the quotient must fit in dividend.count - divisor.count elements")
        //=--------------------------------------=
        for index in base.indices.reversed() {
            let digit = SUI.formRemainderWithQuotientByOneLongIteration2111MSB(
            dividing: &dividend[index  ..< index &+ divisor.count &+ 1], by: divisor)
            base.baseAddress!.advanced(by: index).initialize(to: digit)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Base is Mutable Collection
//=----------------------------------------------------------------------------=

extension Namespace.StrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
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
    /// ## Example Usage in Long Division Algorithm
    ///
    /// ```swift
    /// // try fast path
    /// // normalization
    ///
    /// var quotient = uninitialized(dividend.count - divisor.count) {
    ///     for index in $0.indices.reversed() {
    ///         let digit = formRemainderWithQuotientByOneLongIteration2111MSB(
    ///         dividing: &dividend[index ..< index &+ divisor.count &+ 1], by: divisor)
    ///         $0.baseAddress!.advanced(by:  index).initialize(to: digit)
    ///     }
    /// }
    ///
    /// // normalization
    /// // return values
    /// ```
    ///
    @inlinable package static func formRemainderWithQuotientByOneLongIteration2111MSB(
    dividing dividend: inout Base, by divisor: some RandomAccessCollection<Base.Element>) -> Base.Element {
        //=--------------------------------------=
        Swift.assert(divisor.last! & Base.Element.msb != 0,
        "the divisor must be normalized")
        
        Swift.assert(dividend.count == divisor.count + 1,
        "the dividend must be exactly one element wider than the divisor")
        
        Swift.assert(SUISS.compare(dividend.dropFirst(), to: divisor) == -1,
        "the quotient of each iteration must fit in one element")
        //=--------------------------------------=
        let numerator   = TBI<Base.Element>.suffix2(dividend)
        let denominator = TBI<Base.Element>.suffix1(divisor )
        //=--------------------------------------=
        var quotient: Base.Element = try! denominator == numerator.high
        ? Base.Element.max // the quotient must fit in one element
        : Base.Element.dividing(numerator, by: denominator).quotient
        //=--------------------------------------=
        if  quotient == 0 { return quotient }
        //=--------------------------------------=
        var overflow = (SUISS).decrementInIntersection(&dividend, by: divisor, times: quotient).overflow
        
        decrementQuotientAtMostTwice: while overflow {
            quotient = quotient &- 1 as Base.Element
            overflow = !SUISS .increment(&dividend, by: divisor).overflow
        }
        
        Swift.assert(SUISS.compare(dividend, to: divisor) == -1)
        return quotient as Base.Element
    }
}
