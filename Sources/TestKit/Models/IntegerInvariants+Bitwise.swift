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
// MARK: * Integer Invariants x Bitwise
//*============================================================================*

extension IntegerInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func endianness() where T: SystemsInteger {
        test.same(T(repeating: 0).endianness(.big   ), T(repeating: 0))
        test.same(T(repeating: 0).endianness(.little), T(repeating: 0))
        test.same(T(repeating: 1).endianness(.big   ), T(repeating: 1))
        test.same(T(repeating: 1).endianness(.little), T(repeating: 1))
        
        test.same(T(1).endianness(.system),                     T(1))
        test.same(T(2).endianness(.big   ).endianness(.big   ), T(2))
        test.same(T(3).endianness(.big   ).endianness(.little), T(3) << T(raw: T.size - 8))
        test.same(T(4).endianness(.little).endianness(.big   ), T(4) << T(raw: T.size - 8))
        test.same(T(5).endianness(.little).endianness(.little), T(5))
    }
}
