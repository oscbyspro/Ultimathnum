//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Text Int
//*============================================================================*

/// A common text de/encoder for all binary integers.
///
/// ### Tradeoffs
///
/// This coder unifies all integer types and all common radices (2...36) with
/// a single non-inlinable and non-generic algorithm. This design favors code
/// size over performance. If test de/encoding performance is important to you, 
/// then you may want to use a dedicated hexadecimal formatter, for example.
///
/// ### Development
///
/// - TODO: Consider adding a `<= UX.size` fast path.
///
@frozen public struct TextInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    public static let decimal = try! Self(radix: 10)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let numerals: Numerals
    @usableFromInline let exponentiation: Exponentiation
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(radix: UX, uppercase: Bool = false) throws {
        self.numerals = try Numerals(radix, uppercase: uppercase)
        self.exponentiation = try Exponentiation(radix)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var radix: UX {
        UX(load: self.numerals.radix as U8)
    }
    
    @inlinable public var uppercase: Bool {
        self.numerals.uppercase
    }
    
    //*========================================================================*
    // MARK: * Failure
    //*========================================================================*
    
    @frozen public enum Failure: Swift.Error & Equatable {
        
        case invalid
        
        case overflow
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Decoding
//=----------------------------------------------------------------------------=

extension TextInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable package static func makeSignMaskBody<UTF8>(
        from description: UTF8
    )   -> (sign: Sign, mask: Bit?, body: UTF8.SubSequence) where UTF8: Collection<UInt8> {
        var body = description[...] as UTF8.SubSequence
        let sign = self.removeLeadingSign(from: &body) ?? .plus
        let mask = self.removeLeadingMask(from: &body) ?? .zero
        return (sign: sign, mask: mask, body: body)
    }
    
    @inlinable package static func removeLeadingSign<UTF8>(
        from description: inout UTF8
    )   ->  Sign? where UTF8: Collection<UInt8>, UTF8 == UTF8.SubSequence {
        switch description.first {
        case UInt8(ascii: "+"): description.removeFirst(); return Sign.plus
        case UInt8(ascii: "-"): description.removeFirst(); return Sign.minus
        default: return nil
        }
    }
    
    @inlinable package static func removeLeadingMask<UTF8>(
        from description: inout UTF8
    )   ->  Bit? where UTF8: Collection<UInt8>, UTF8 == UTF8.SubSequence {
        switch description.first {
        case UInt8(ascii: "#"): description.removeFirst(); return Bit.zero
        case UInt8(ascii: "&"): description.removeFirst(); return Bit.one
        default: return nil
        }
    }
}
