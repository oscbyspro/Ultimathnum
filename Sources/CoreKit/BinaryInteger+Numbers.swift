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
            isLessThanZero = magnitude[{ $0.negated() }]
        }
        
        let value = Self(bitPattern: magnitude)
        return value.combine(value.isNegative != isLessThanZero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<Other>(_ source: consuming Other) where Other: BinaryInteger {
        self = Self.exactly(source).unwrap()
    }
    
    @inlinable public static func exactly<Other>(_ source: consuming Other) -> Fallible<Self> where Other: BinaryInteger {
        if  let lhsSize = UX(size: Self.self), let rhsSize = UX(size: Other.self) {
            if (lhsSize >  rhsSize && (Self.isSigned))
            || (lhsSize >= rhsSize && (Self.isSigned == Other.isSigned)) {
                return Fallible.success(Self(load: source))
                
            }   else if lhsSize >= rhsSize {
                Swift.assert(Self.mode.isSigned != Other.mode.isSigned)
                let rhsIsNegative = source.isNegative
                let result = Self(load: source)
                let lhsIsNegative = result.isNegative
                return result.combine(lhsIsNegative != rhsIsNegative)
                
            }   else {
                let bit   = Bit(Self.isSigned) & Bit(source.isNegative)
                let count = rhsSize.minus(UX(load: source.count(.descending(((bit)))))).assert()
                let limit = lhsSize.minus(UX(Bit(Self.isSigned) & Bit(Other.isSigned))).assert()
                return Self(load: source).combine(limit < count)
            }
            
        }   else {
            return source.withUnsafeBinaryIntegerElements {
                Self.exactly($0, mode: Other.mode)
            }
        }
    }
}
