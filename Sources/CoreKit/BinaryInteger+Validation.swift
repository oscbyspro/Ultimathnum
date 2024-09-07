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
