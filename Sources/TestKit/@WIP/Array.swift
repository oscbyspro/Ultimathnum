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
// MARK: * Array
//*============================================================================*

extension Array where Element: SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func withExchangeInt<T, U>(as type: T.Type, repeating bit: Bit, perform action: (ExchangeInt<T>) -> U) -> U {
        self.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: U8.self) {
                action(ExchangeInt(MemoryInt(MemoryIntBody($0)!, repeating: bit)))
            }
        }
    }
}
