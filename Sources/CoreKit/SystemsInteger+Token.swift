//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Systems Integer x Token
//*============================================================================*

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
        if  Self.bitWidth.load(as: UX.self) <= UX.bitWidth {
            return Self.init(load: source.load(as: UX.self))
        }   else {
            var source = source as T
            let minus  = source.isLessThanZero
            
            var bitIndex: Self = 0000000000000000000000000000000
            let bitWidth: Self = Self(bitPattern: Self.bitWidth)
            var instance: Self = Self(repeating: Bit(bitPattern: minus))
            
            if  T.bitWidth.load(as: UX.self) > UX.bitWidth {
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
