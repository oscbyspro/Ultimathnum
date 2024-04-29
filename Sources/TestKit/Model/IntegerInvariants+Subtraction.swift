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
// MARK: * Integer Invariants x Subtraction
//*============================================================================*

extension IntegerInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func subtractionAboutMinMax(_ id: SystemsIntegerID) where T: SystemsInteger {
        test.subtraction(T.min,  T .min, F( 0 as T))
        test.subtraction(T.min,  T .max, F( 1 as T, error: true))
        test.subtraction(T.max,  T .min, F(~0 as T, error: T.isSigned))
        test.subtraction(T.max,  T .max, F( 0 as T))
        
        test.subtraction(T.min, ~0 as T, F( T .min + 1, error: !T.isSigned))
        test.subtraction(T.min,  0 as T, F( T .min))
        test.subtraction(T.min,  1 as T, F( T .max, error: true))
        test.subtraction(T.max, ~0 as T, F( T .min, error: T.isSigned))
        test.subtraction(T.max,  0 as T, F( T .max))
        test.subtraction(T.max,  1 as T, F( T .max - 1))
    }
    
    public func subtractionAboutRepeatingBit(_ id: BinaryIntegerID) where T: BinaryInteger {
        //=--------------------------------------=
        let x0 = T(repeating: 0)
        let x1 = T(repeating: 1)
        //=--------------------------------------=
        test.subtraction(x0, x0, F(x0))
        test.subtraction(x0, x1, F( 1, error: !T.isSigned))
        test.subtraction(x1, x0, F(x1))
        test.subtraction(x1, x1, F(x0))
        //=--------------------------------------=
        for decrement: T in [1, 2, 3] {
            test.subtraction(x0, decrement, F(decrement.complement(), error: !T.isSigned))
            test.subtraction(x1, decrement, F(decrement.toggled()))
        }
    }
}
