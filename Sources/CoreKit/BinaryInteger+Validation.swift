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
    
    /// Creates a new instance from the given `source`.
    ///
    /// - Note: This method does not need to perform any validation.
    ///
    @inline(__always) // performance: please fold it like a paper airplane
    @inlinable public init(_ source: consuming Self) {
        self = source
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a validated instance from the given `source`.
    @inlinable public static func exactly(_ source: consuming RootInt) -> Fallible<Self> {
        source.withUnsafeBinaryIntegerElements {
            Self.exactly($0, mode: .signed)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a validated instance from the given `sign` and `magnitude`.
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
    
    /// Creates a validated instance from the given `sign` and `magnitude`.
    @inlinable public static func exactly<Other>(
        sign: consuming Sign = .plus,
        magnitude: consuming Other
    )   -> Fallible<Self> where Other: UnsignedInteger {
        
        let magnitude = Magnitude.exactly(magnitude)
        let result = Self.exactly(sign: sign, magnitude: magnitude.value)
        return result.veto(magnitude.error)
    }
    
    /// Creates a new instance from the given `sign` and `magnitude` by trapping on failure.
    @inlinable public init<Other>(
        sign: consuming Sign = .plus,
        magnitude: consuming Other
    )   where Other: UnsignedInteger  {
        self = Self.exactly(sign: sign, magnitude: magnitude).unwrap()
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    // TODO: await appendix { borrowing get } fixes then make these borrowing
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given `source` by trapping on failure.
    @inlinable public init<Other>(_ source: consuming Other) where Other: BinaryInteger {
        self = Self.exactly(source).unwrap()
    }
    
    /// Creates a validated instance from the given `source`.
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
                let limit = Count(unchecked: size.minus(Self.isSigned).unchecked())
                let count = source.nondescending(Bit(Self.isSigned && source.isNegative))
                return Self(load: source).veto(limit < count)
            }
            
        }   else {
            return source.withUnsafeBinaryIntegerElements {
                Self.exactly($0, mode: Other.mode)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Clamping
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance by clamping the given `source`.
    @inlinable public init(clamping source: some FiniteInteger) {
        self.init(clamping: source)!
    }
    
    /// Creates a new instance by clamping the given `source`.
    @_disfavoredOverload // BinaryInteger.init(clamping: some FiniteInteger)
    @inlinable public init(clamping source: some BinaryInteger) where Self: EdgyInteger {
        self.init(clamping: source)!
    }
    
    /// Creates a new instance by clamping the given `source`.
    ///
    /// The following illustration shows when clamping is possible:
    ///
    ///                ┌────────────┬────────────┐
    ///                │ Systems    │ Arbitrary  |
    ///     ┌──────────┼────────────┤────────────┤
    ///     │   Signed │ OK         │ source ∈ ℕ │
    ///     ├──────────┼────────────┤────────────┤
    ///     │ Unsigned │ OK         │ OK         │
    ///     └──────────┴────────────┴────────────┘
    ///
    ///
    /// - Note: This is the most generic version of `init(clamping:)`.
    ///
    @_disfavoredOverload // BinaryInteger.init(clamping: some FiniteInteger)
    @inlinable public init?(clamping source: some BinaryInteger) {
        if !Self.size.isInfinite {
            
            if  let  instance = Self.exactly(source).optional() {
                self = instance
                
            }   else if Self.isSigned {
                let msb = Self.lsb.up(Shift.max)
                self.init(raw: source.isNegative ? msb : msb.toggled())
                
            }   else {
                self.init(repeating: Bit(!source.isNegative))
            }
        
        }   else if Self.isSigned, source.isInfinite {
            return nil
            
        }   else if !Self.isSigned, source.isNegative {
            self.init()
            
        }   else {
            self.init(load: source)
        }
    }
}
