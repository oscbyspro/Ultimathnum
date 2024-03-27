//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Systems Integer x Bit
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var lsb: Self {
        Self(bitPattern: 1 as Magnitude)
    }
    
    @inlinable public static var msb: Self {
        Self(bitPattern: 1 as Magnitude &<< (bitWidth &- 1))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Machine Word
//=----------------------------------------------------------------------------=

extension SystemsInteger where BitPattern == UX.BitPattern {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Returns the bit width of the given type as an un/signed machine word.
    ///
    /// - Note: A systems integer's bit width must fit in this type per definition.
    ///
    @inlinable public init<T>(bitWidth type: T.Type) where T: SystemsInteger {
        self = T.bitWidth.load(as: Self.self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// - Note: This method can be used when `init(truncating:)` cannot.
    @inlinable package static func tokenized<T>(bitCastOrLoad source: T) -> Self where T: SystemsInteger {
        if  Self.BitPattern.self == T.BitPattern.self {
            return Self(bitPattern: Swift.unsafeBitCast(source.bitPattern, to: Self.BitPattern.self))
        }   else {
            return Self.tokenized(load: source)
        }
    }
    
    /// - Note: This method can be used when `init(truncating:)` cannot.
    @inlinable package static func tokenized<T: SystemsInteger>(load source: T) -> Self where T: SystemsInteger {
        if  UX(bitWidth: Self.self) <= UX.bitWidth {
            return Self.init(load: source.load(as: UX.self))
        }   else {
            var source = source as T
            let minus  = source.isLessThanZero
            
            var bitIndex: Self = 0000000000000000000000000000000
            let bitWidth: Self = Self(bitPattern: Self.bitWidth)
            var instance: Self = Self(repeating: Bit(bitPattern: minus))
            
            if  UX(bitWidth: T.self) >  UX.bitWidth {
                chunking: while bitIndex < bitWidth {
                    let element = (source).load(as: UX.self)
                    (source) = (source) &>> T(load: UX.bitWidth)
                    instance = instance ^   Self(load: minus ? ~element : element) &<< bitIndex
                    bitIndex = bitIndex +   Self(load: UX.bitWidth)
                }
            }
            
            return instance as Self as Self as Self
        }
    }
}
