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

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Sets the `error` indicator when `condition` is `true`.
    @inlinable public consuming func veto(_ condition: Bool = true) -> Fallible<Self> {
        Fallible(self, error: condition)
    }
    
    /// Sets the `error` indicator if the `predicate` return `true`.
    @inlinable public consuming func veto(_ predicate: (Self) -> Bool) -> Fallible<Self> {
        let error = predicate(self)
        return self.veto(error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Integers
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func exactly(_ source: consuming RootInt) -> Fallible<Self> {
        source.withUnsafeBinaryIntegerElements {
            Self.exactly($0, mode: .signed)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func exactly(
        sign: consuming Sign = .plus,
        magnitude: consuming Magnitude
    )   -> Fallible<Self> {
        
        var isNegative = Bool(sign)
        if  isNegative {
            isNegative = magnitude[{ $0.negated() }]
        }
        
        let value = Self(raw: magnitude)
        return value.veto(value.isNegative != isNegative)
    }
    
    @inlinable public static func exactly<Other>(
        sign: consuming Sign = .plus,
        magnitude: consuming Other
    )   -> Fallible<Self> where Other: UnsignedInteger {
        
        let magnitude = Magnitude.exactly(magnitude)
        let result = Self.exactly(sign: sign, magnitude: magnitude.value)
        return result.veto(magnitude.error)
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
                return Fallible(Self(load: source))
                
            }   else if lhsSize >= rhsSize {
                Swift.assert(Self.isSigned != Other.isSigned)
                let rhsIsNegative = source.isNegative
                let result = Self(load: source)
                let lhsIsNegative = result.isNegative
                return result.veto(lhsIsNegative != rhsIsNegative)
                
            }   else {
                let bit   = Bit(Self.isSigned) & Bit(source.isNegative)
                let count = rhsSize.minus(UX(load: source.count(.descending(bit)))).assert()
                let limit = lhsSize.minus(UX(Bit(Self.isSigned))).assert()
                return Self(load: source).veto(limit < count)
            }
            
        }   else {
            return source.withUnsafeBinaryIntegerElements {
                Self.exactly($0, mode: Other.mode)
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Validation x Edgy
//*============================================================================*

extension EdgyInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(clamping source: some BinaryInteger) {
        if  let instance = Self.exactly(source).optional() {
            self = instance
        }   else {
            self = source.isNegative ? Self.min : Self.max
        }
    }
}
