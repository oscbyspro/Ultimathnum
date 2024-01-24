//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Proper Binary Integer x Numbers x Systems
//*============================================================================*

extension Namespace.ProperBinaryInteger where Base: SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Loads `base` as the given `type` using exhange tokens.
    ///
    /// - Note: This method can be used when `init(truncating:)` cannot.
    ///
    @inlinable package static func load<Other: SystemsInteger>(_ source: Base, as type: Other.Type) -> Other {
        if  Other.bitWidth.load(as: UX.self) <= UX.bitWidth {
            return Other.init(load: source.load(as: UX.self))
        }   else {            
            var source = source
            let minus  = source.isLessThanZero
            
            var bitIndex: Other = 000000000000000000000000000000
            let bitWidth: Other = Other(bitPattern: Other.bitWidth)
            var value = Other(repeating: Bit(bitPattern: minus))
            
            chunking: while bitIndex < bitWidth {
                let element = source.load(as: UX.self)
                source = source >> Base(load: UX.bitWidth)
                value  = value  ^ Other(load: minus ? ~element : element) &<< bitIndex
                bitIndex = bitIndex + Other(load: UX.bitWidth)
            }
            
            return value as Other
        }
    }
    
    /// Loads `base` as the given `type` using exhange tokens, or a bit cast.
    ///
    /// - Note: This method can be used when `init(truncating:)` cannot.
    ///
    @inlinable package static func bitCastOrLoad<Other: SystemsInteger>(_ base: Base, as type: Other.Type) -> Other {
        if  Base.BitPattern.self ==  Other.BitPattern.self {
            return Other(bitPattern: Swift.unsafeBitCast(base.bitPattern, to: Other.BitPattern.self))
        }   else {
            return PBI.load(base, as: Other.self)
        }
    }
}
