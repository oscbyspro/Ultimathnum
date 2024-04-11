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
// MARK: * Body
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func body() -> Array<Element.Magnitude> {
        self.withUnsafeBinaryIntegerBody {
            Array($0.buffer())
        }
    }
    
    public func words() -> Array<UX> {
        self.withUnsafeBinaryIntegerElementsAsBytes {
            Array(ExchangeInt($0).body())
        }
    }
}
