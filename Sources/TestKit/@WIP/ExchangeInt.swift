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
        base.withExchangeInt(as: Element.self, repeating: bit) {
            Array($0.body())
        }
    }
    
    public static func normalized<T>(
        _ base: [T],
        repeating bit: Bit,
        as type: Element.Type = Element.self
    )   -> [Element] where T: SystemsInteger & UnsignedInteger {
        base.withExchangeInt(as: Element.self, repeating: bit) {
            Array($0.normalized())
        }
    }
    
    public static func prefix<T>(
        _ base: [T],
        repeating bit: Bit,
        count: Int,
        as type: Element.Type = Element.self
    )   -> [Element] where T: SystemsInteger & UnsignedInteger {
        base.withExchangeInt(as: Element.self, repeating: bit) {
            Array($0.prefix(count))
        }
    }
}
