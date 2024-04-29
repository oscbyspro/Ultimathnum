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
    
    public func subtractionOfMinMax(_ id: SystemsIntegerID) where T: SystemsInteger {
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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func subtractionOfRepeatingBit(_ id: BinaryIntegerID) where T: BinaryInteger {
        //=--------------------------------------=
        let x0 = T(repeating: 0)
        let x1 = T(repeating: 1)
        //=--------------------------------------=
        test.subtraction(x0, x0, F(x0))
        test.subtraction(x0, x1, F( 1, error: !T.isSigned))
        test.subtraction(x1, x0, F(x1))
        test.subtraction(x1, x1, F(x0))
        //=--------------------------------------=
        for decrement: T in [1, 2, 3, ~1, ~2, ~3] {
            test.subtraction(x0, decrement, F(decrement.complement(), error: !T.isSigned))
            test.subtraction(x1, decrement, F(decrement.toggled()))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func subtractionByNegation(_ id: SystemsIntegerID) where T: SystemsInteger {
        //=--------------------------------------=
        self.subtractionByNegation(BinaryIntegerID())
        //=--------------------------------------=
        for x in [T.min, T.max, T.lsb, T.msb] {
            test.subtraction(0 as T, x, F(x.complement(), error: T.isSigned == (x == T.min)))
            test.subtraction(0 as T, x, F(x.complement(), error: T.isSigned == (x == T.min)))
        }
    }
    
    public func subtractionByNegation(_ id: BinaryIntegerID) where T: BinaryInteger {
        test.subtraction(0 as T, ~1 as T, F( 2 as T, error: !T.isSigned))
        test.subtraction(0 as T, ~0 as T, F( 1 as T, error: !T.isSigned))
        test.subtraction(0 as T,  0 as T, F( 0 as T))
        test.subtraction(0 as T,  1 as T, F(~0 as T, error: !T.isSigned))
        test.subtraction(0 as T,  2 as T, F(~1 as T, error: !T.isSigned))
    }
}
