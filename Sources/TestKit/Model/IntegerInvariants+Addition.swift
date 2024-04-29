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
// MARK: * Integer Invariants x Addition
//*============================================================================*

extension IntegerInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func additionAboutMinMax(_ id: SystemsIntegerID) where T: SystemsInteger {
        test.addition(T.min,  T .min, F( 0 as T, error: T.isSigned))
        test.addition(T.min,  T .max, F(~0 as T))
        test.addition(T.max,  T .min, F(~0 as T))
        test.addition(T.max,  T .max, F(~1 as T, error: true))
        
        test.addition(T.min, ~0 as T, F( T .max, error: T.isSigned))
        test.addition(T.min,  0 as T, F( T .min))
        test.addition(T.min,  1 as T, F( T .min + 1))
        test.addition(T.max, ~0 as T, F( T .max - 1, error: !T.isSigned))
        test.addition(T.max,  0 as T, F( T .max))
        test.addition(T.max,  1 as T, F( T .min, error: true))
    }
    
    public func additionAboutRepeatingBit(_ id: BinaryIntegerID) where T: BinaryInteger {
        //=--------------------------------------=
        let x0 = T(repeating: 0)
        let x1 = T(repeating: 1)
        //=--------------------------------------=
        test.addition(x0, x0, F(x0))
        test.addition(x0, x1, F(x1))
        test.addition(x1, x0, F(x1))
        test.addition(x1, x1, F(~1, error: !T.isSigned))
        //=--------------------------------------=
        for increment: T in [1, 2, 3, ~1, ~2, ~3]  {
            test.addition(x0, increment, F(increment))
            test.addition(x1, increment, F(increment - 1, error: !T.isSigned))
        }
    }
}
