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
    
    @inlinable package static func sign(_ text: UInt8) -> Sign? {
        switch text {
        case UInt8(ascii: "+"): Sign.plus
        case UInt8(ascii: "-"): Sign.minus
        default: nil
        }
    }
    
    @inlinable package static func mask(_ text: UInt8) -> Void? {
        switch text {
        case UInt8(ascii: "&"): Void()
        default: nil
        }
    }
    
    @inlinable package static func remove<UTF8, Component>(
        from description: inout UTF8,
        prefix match: (UInt8) -> Component?
    )   -> Component? where UTF8: Collection<UInt8>, UTF8 == UTF8.SubSequence {
        
        if  let first = description.first, let component = match(first) {
            description.removeFirst()
            return component as Component
        }   else {
            return nil
        }
    }
}
