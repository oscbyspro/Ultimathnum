//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Floats
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Swift.BinaryFloatingPoint
    //=------------------------------------------------------------------------=
    
    /// Returns the `value` of `source` rounded towards zero by trapping on `nil`.
    ///
    /// ```swift
    /// Self.leniently(source)!.value
    /// ```
    ///
    /// - Note: It is `nil` if the operation is `undefined`.
    ///
    /// - Note: It is `nil` if the integer part cannot be represented.
    ///
    @_disfavoredOverload // disfavor: integer literal as Double
    @inlinable public init(_ source: some Swift.BinaryFloatingPoint) {
        self = Self.leniently(source)!.value
    }
    
    /// Returns the `value` of `source`, or `nil`.
    ///
    /// ```swift
    /// Self.leniently(source)?.optional()
    /// ```
    ///
    /// - Note: It is `nil` if the operation is `lossy`.
    ///
    /// - Note: It is `nil` if the operation is `undefined`.
    ///
    @_disfavoredOverload // disfavor: integer literal as Double
    @inlinable public static func exactly(_ source: some Swift.BinaryFloatingPoint) -> Optional<Self> {
        Self.leniently(source)?.optional()
    }
    
    /// Returns the `value` of `source` rounded towards zero and an `error` indicator, or `nil`.
    ///
    /// - Note: It is `nil` if the operation is `undefined`.
    ///
    /// - Note: It is `nil` if the integer part cannot be represented.
    ///
    /// - Note: The `error` is set if the `value` has been rounded towards zero.
    ///
    @_disfavoredOverload // disfavor: integer literal as Double
    @inlinable public static func leniently(_ source: some Swift.BinaryFloatingPoint) -> Optional<Fallible<Self>> {
        //=--------------------------------------=
        // note: floating point zeros are special
        //=--------------------------------------=
        guard !source.isZero else {
            return Fallible(Self.zero)
        }
        //=--------------------------------------=
        // note: order of infinity is unspecified
        //=--------------------------------------=
        guard source.isFinite else {
            return nil
        }
        //=--------------------------------------=
        // note: return zero when no integer part
        //=--------------------------------------=
        let exponent = source.exponent
        if  exponent < .zero {
            return Self.zero.veto()
        }
        //=--------------------------------------=
        // note: arbitrary integer nil, no crash
        //=--------------------------------------=
        guard let exponent = Int(exactly: exponent) else {
            return nil
        }
        //=--------------------------------------=
        // note: checks whether implict bit fits
        //=--------------------------------------=
        guard let position = Shift<Magnitude>(exactly: Count(raw: exponent)) else {
            return nil
        }
        //=--------------------------------------=
        // note: set error if source has fraction
        //=--------------------------------------=
        let count: Swift.Int = source.significandWidth
        let error: Bool = exponent < count
        let pattern = source.significandBitPattern
        let capacity: Swift.Int = count &+ pattern.trailingZeroBitCount
        let distance: Swift.Int = exponent &- capacity
        Swift.assert((Swift.Int.zero <= exponent))
        Swift.assert((Swift.Int.zero <= capacity))
        //=--------------------------------------=
        let sign = Sign(source.sign)
        var magnitude  = Magnitude.lsb.up(position)
        //=--------------------------------------=
        // note: the distance may be negative here
        //=--------------------------------------=
        if  let  size  = IX(size: Self.self), size < IX(capacity as Swift.Int) {
            magnitude |= Namespace.load(pattern   << (((distance))))
        }   else {
            magnitude |= Namespace.load(pattern)  << IX(distance as Swift.Int)
        }
        //=--------------------------------------=
        // note: reject invalid sign and magnitude
        //=--------------------------------------=
        let instance = Self.exactly(sign: sign, magnitude: magnitude)
        return instance.optional()?.veto(error)
    }
}
