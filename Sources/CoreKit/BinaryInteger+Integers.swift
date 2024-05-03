//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Integers
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
        return value.combine(value.isNegative != isNegative)
    }
    
    @inlinable public static func exactly<Other>(
        sign: consuming Sign = .plus,
        magnitude: consuming Other
    )   -> Fallible<Self> where Other: UnsignedInteger {
        
        let magnitude = Magnitude.exactly(magnitude)
        let result = Self.exactly(sign: sign, magnitude: magnitude.value)
        return result.combine(magnitude.error)
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
                Swift.assert(Self.mode.isSigned != Other.mode.isSigned)
                let rhsIsNegative = source.isNegative
                let result = Self(load: source)
                let lhsIsNegative = result.isNegative
                return result.combine(lhsIsNegative != rhsIsNegative)
                
            }   else {
                let bit   = Bit(Self.isSigned) & Bit(source.isNegative)
                let count = rhsSize.minus(UX(load: source.count(.descending(bit)))).assert()
                let limit = lhsSize.minus(UX(Bit(Self.isSigned))).assert()
                return Self(load: source).combine(limit < count)
            }
            
        }   else {
            return source.withUnsafeBinaryIntegerElements {
                Self.exactly($0, mode: Other.mode)
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Integers x Enclosed
//*============================================================================*

extension EnclosedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var min: Self {
        isSigned ? Self(raw: 1 as Magnitude &<< Shift(unchecked: size &- 1)) : Self()
    }
    
    @inlinable public static var max: Self {
        ~(min)
    }
    
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

//*============================================================================*
// MARK: * Binary Integer x Integers x Systems
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var lsb: Self {
        Self(raw: 1 as Magnitude)
    }
    
    @inlinable public static var msb: Self {
        Self(raw: 1 as Magnitude &<< (size &- 1))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Machine Word
//=----------------------------------------------------------------------------=

extension SystemsInteger where BitPattern == UX.BitPattern {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Returns the size of the given type as a machine word.
    ///
    /// - Note: A finite integer size must fit in this type per protocol.
    ///
    /// - Important: A binary integer's size is measured in bits.
    ///
    @inlinable public init<T>(size type: T.Type) where T: SystemsInteger {
        self = T.size.load(as: Self.self)
    }
    
    /// Returns the size of the given type as a machine word, if possible.
    ///
    /// - Note: A finite integer size must fit in this type per protocol.
    ///
    /// - Important: A binary integer's size is measured in bits.
    ///
    @inlinable public init?<T>(size type: T.Type) where T: BinaryInteger {
        if  T.size.isInfinite {
            return nil
        }   else {
            self = T.size.load(as: Self.self)
        }
    }
}
