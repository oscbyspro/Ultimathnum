//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Exchange Int
//*============================================================================*

extension ExchangeInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func body<T>(
        _ base: [T],
        repeating bit: Bit,
        as type: Element.Type = Element.self
    )   -> [Element] where T: SystemsInteger & UnsignedInteger {
        
        base.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: U8.self) {
                let elements = ExchangeInt(DataInt($0, repeating: bit)!)
                return Array(elements.body())
            }
        }
    }
    
    public static func normalized<T>(
        _ base: [T],
        repeating bit: Bit,
        as type: Element.Type = Element.self
    )   -> [Element] where T: SystemsInteger & UnsignedInteger {
        
        base.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: U8.self) {
                let elements = ExchangeInt(DataInt($0, repeating: bit)!)
                return Array(elements.normalized())
            }
        }
    }
    
    public static func prefix<T>(
        _ base: [T],
        repeating bit: Bit,
        count: IX,
        as type: Element.Type = Element.self
    )   -> [Element] where T: SystemsInteger & UnsignedInteger {

        base.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: U8.self) {
                let elements = ExchangeInt(DataInt($0, repeating: bit)!)
                return Array(elements.prefix(count))
            }
        }
    }
}
