//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Text Int x Format
//*============================================================================*

extension TextInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable package static func decompose<UTF8>(
        _ description: UTF8
    )   -> (sign: Sign, mask: Bit, body: UTF8.SubSequence) where UTF8: Collection<UInt8> {
        var body = description[...]
        let sign = self.remove(from: &body, prefix: Self.decode) ?? Sign.plus
        let mask = self.remove(from: &body, prefix: Self.decode) ?? Bit .zero
        return (sign: sign, mask: mask, body: body)
    }
    
    @inlinable package static func remove<UTF8, Component>(
        from description: inout UTF8, 
        prefix match: (UInt8) -> Component?
    )   ->  Component? where UTF8: Collection<UInt8>, UTF8 == UTF8.SubSequence {
        
        if  let first = description.first {
            if  let component = match(first) {
                description.removeFirst()
                return component
            }
        }
        
        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Sign
    //=------------------------------------------------------------------------=
    
    @inlinable package static func decode(_ text: UInt8) -> Sign? {
        switch text {
        case UInt8(ascii: "+"): .plus
        case UInt8(ascii: "-"): .minus
        default: nil
        }
    }
    
    @inlinable package static func encode(_ data: Sign) -> UInt8 {
        UInt8(ascii: data == .plus ? "+" : "-")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Mask
    //=------------------------------------------------------------------------=
    
    @inlinable package static func decode(_ text: UInt8) -> Bit? {
        switch text {
        case UInt8(ascii: "#"): .zero
        case UInt8(ascii: "&"): .one
        default: nil
        }
    }
    
    @inlinable package static func encode(_ data: Bit)  -> UInt8 {
        UInt8(ascii: data == .zero ? "#" : "&")
    }
}
