//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Numbers
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var zero: Self {
        Self()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() {
        self = 0
    }
    
    @inlinable public init(_ source: consuming Self) {
        self = source
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func exactly(
        sign: consuming Sign = .plus,
        magnitude: consuming Magnitude
    )   -> Fallible<Self> {
        
        var isLessThanZero = Bool(sign)
        if  isLessThanZero {
            isLessThanZero = magnitude.capture({ $0.negated() })
        }
        
        let value = Self(bitPattern: magnitude)
        return value.combine(value.isLessThanZero != isLessThanZero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<Other>(_ source: consuming Other) where Other: BinaryInteger {
        self = Self.exactly(source).unwrap()
    }
    
    @inlinable public static func exactly<Other>(_ source: consuming Other) -> Fallible<Self> where Other: BinaryInteger {
        if !Self.bitWidth.isInfinite, !Other.bitWidth.isInfinite {
            let measurement = UX(load: Self.bitWidth).compared(to: UX(load: Other.bitWidth))
            if (measurement > 0) == (Self.isSigned == Other.isSigned) || (measurement == 0 && Self.isSigned) {
                return Fallible.success(Self(load: source))
                
            }   else if measurement >= 0 {
                let rhsIsLessThanZero = source.isLessThanZero
                let result = Self(load: source)
                let lhsIsLessThanZero = result.isLessThanZero
                return result.combine(lhsIsLessThanZero != rhsIsLessThanZero)
                
            }   else {
                let bit   = Bit(Self.isSigned) & Bit(source.isLessThanZero)
                let count = UX(load: Other.bitWidth).minus(UX(load: source.count(.descending(((bit)))))).assert()
                let limit = UX(load: Self .bitWidth).minus(UX(Bit(Self.isSigned) & Bit(Other.isSigned))).assert()
                return Self(load: source).combine(limit < count)
            }
            
        }   else {
            return source.withUnsafeBinaryIntegerElements {
                Self.exactly($0, isSigned: Other.isSigned)
            }
        }
    }
}
