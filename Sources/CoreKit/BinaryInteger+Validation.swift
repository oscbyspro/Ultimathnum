//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Validation
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Integers
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Loads the `source` by trapping on `error`
    ///
    /// - Note: The `error` is set if the conversion is `lossy`.
    ///
    /// - Note: This particular overload cannot fail.
    ///
    @inline(__always) // performance: please fold it like a paper airplane
    @inlinable public init(_ source: consuming Self) {
        self = source
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Loads the `sign` and `magnitude` by trapping on `error`.
    ///
    /// - Note: The `error` is set if the conversion is `lossy`.
    ///
    @inlinable public init<Other>(
        sign: consuming Sign = .plus,
        magnitude: consuming Other
    )   where Other: UnsignedInteger  {
        self = Self.exactly(sign: sign, magnitude: magnitude).unwrap()
    }
    
    /// Loads the `sign` and `magnitude` and returns an `error` indicator.
    ///
    /// - Note: The `error` is set if the conversion is `lossy`.
    ///
    @inlinable public static func exactly(
        sign: consuming Sign = .plus,
        magnitude: consuming Magnitude
    )   -> Fallible<Self> {
        
        var magnitude  = magnitude // await consuming fix
        var isNegative = Bool(sign)
        
        if  isNegative {
            (magnitude, isNegative) = magnitude.negated().components()
        }
        
        let value = Self(raw: magnitude)
        return value.veto(value.isNegative != isNegative)
    }
    
    /// Loads the `sign` and `magnitude` and returns an `error` indicator.
    ///
    /// - Note: The `error` is set if the conversion is `lossy`.
    ///
    @inlinable public static func exactly<Other>(
        sign: consuming Sign = .plus,
        magnitude: consuming Other
    )   -> Fallible<Self> where Other: UnsignedInteger {
        let magnitude = Magnitude.exactly(magnitude)
        let result = Self.exactly(sign: sign, magnitude: magnitude.value)
        return result.veto(magnitude.error)
    }
    
    /// Loads the `sign` and `magnitude` and returns an `error` indicator.
    ///
    /// - Note: The `error` is set if the conversion is `lossy`.
    ///
    @inlinable public static func exactly<Other>(
        sign: consuming Sign = .plus,
        magnitude: consuming Fallible<Other>
    )   -> Fallible<Self> where Other: UnsignedInteger {
        Self.exactly(sign: sign, magnitude: magnitude.value).veto(magnitude.error)
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    // TODO: await appendix { borrowing get } fixes then make these borrowing
    //=------------------------------------------------------------------------=
        
    /// Loads the `source` by trapping on `error`
    ///
    /// - Note: The `error` is set if the conversion is `lossy`.
    ///
    @inlinable public init<Other>(_ source: consuming Other) where Other: BinaryInteger {
        self = Self.exactly(source).unwrap()
    }
    
    /// Loads the `source` and returns an `error` indicator.
    ///
    /// - Note: The `error` is set if the conversion is `lossy`.
    ///
    @inlinable public static func exactly<Other>(_ source: consuming Other) -> Fallible<Self> where Other: BinaryInteger {
        if  let size = IX(size: Self.self), !Other.size.isInfinite {
            if  Self.size > Other.size, Self.isSigned {
                return Fallible(Self(load: source))
                
            }   else if Self.size >= Other.size, Self.isSigned == Other.isSigned {
                return Fallible(Self(load: source))
                
            }   else if Self.size >= Other.size {
                Swift.assert(Self.isSigned != Other.isSigned)
                let rhsIsNegative = source.isNegative
                let result = Self(load: source)
                let lhsIsNegative = result.isNegative
                return result.veto(lhsIsNegative != rhsIsNegative)
                
            }   else {
                Swift.assert(Self.size < Other.size)
                let limit = Count(unchecked: size.decremented(Self.isSigned).unchecked())
                let count = source.nondescending(Bit(Self.isSigned && source.isNegative))
                return Self(load: source).veto(limit < count)
            }
            
        }   else {
            return source.withUnsafeBinaryIntegerElements {
                Self.exactly($0, mode: Other.mode)
            }
        }
    }
    
    /// Loads the `source` and returns an `error` indicator.
    ///
    /// - Note: The `error` is set if the conversion is `lossy`.
    ///
    @inlinable public static func exactly<Other>(_ source: consuming Fallible<Other>) -> Fallible<Self> where Other: BinaryInteger {
        Self.exactly(source.value).veto(source.error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Stdlib
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Swift.BinaryInteger
    //=------------------------------------------------------------------------=
    // TODO: Write tests...
    //=------------------------------------------------------------------------=
    
    /// Loads the `source`.
    @inlinable public static func stdlib<Source>(load source: Source) -> Self where Source: Swift.BinaryInteger {
        if  Source.isSigned, let small = Int(exactly: source) {
            return Self(load: IX(small))
        }
        
        if !Source.isSigned, let small = UInt(exactly: source) {
            return Self(load: UX(small))
        }
        
        //  TODO: deduplicate the following code
        
        let appendix = Bit(source < Source.zero)
        let elements = source.words
        let instance = elements.withContiguousStorageIfAvailable {
            $0.withMemoryRebound(to: UX.self) {
                Self(load: DataInt($0, repeating: appendix)!)
            }
        }
        
        if  let instance {
            return instance
        }
        
        return ContiguousArray(elements).withUnsafeBufferPointer {
            $0.withMemoryRebound(to: UX.self) {
                Self(load: DataInt($0, repeating: appendix)!)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Swift.BinaryFloatingPoint
    //=------------------------------------------------------------------------=
    
    /// Returns a `value` and an `error` indicator.
    ///
    /// - Note: It returns `nil` if the operation is `lossy`.
    ///
    /// - Note: It returns `nil` if the operation is `undefined`.
    ///
    @inlinable public static func stdlib<Source>(exactly source: Source) -> Optional<Self> where Source: Swift.BinaryFloatingPoint {
        Self.stdlib(leniently: source)?.optional()
    }
    
    /// Returns a `value` and an `error` indicator, or `nil`.
    ///
    /// - Note: It returns `nil` if the operation is `undefined`.
    ///
    /// - Note: It returns `nil` if the integer part cannot be represented.
    ///
    /// - Note: The `error` is set if the `value` has been rounded towards zero.
    ///
    @inlinable public static func stdlib<Source>(leniently source: Source) -> Optional<Fallible<Self>> where Source: Swift.BinaryFloatingPoint {
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
        if  exponent < Source.Exponent.zero {
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
        let implicit = Magnitude.lsb.up(position)
        let fraction = if let size = IX(size: Self.self), Int(size) < capacity {
            Magnitude.stdlib(load: pattern  << distance)
        }   else {
            Magnitude.stdlib(load: pattern) << IX(distance as Swift.Int)
        }
        //=--------------------------------------=
        // note: reject invalid sign and magnitude
        //=--------------------------------------=
        let sign = Sign(source.sign)
        let magnitude: Magnitude = (implicit |  fraction)
        let instance = Self.exactly(sign: sign, magnitude: magnitude)
        return instance.optional()?.veto(error)
    }
}
