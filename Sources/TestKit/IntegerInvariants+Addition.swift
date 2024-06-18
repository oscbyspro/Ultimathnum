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
    
    public func negation() where T: BinaryInteger {
        //=--------------------------------------=
        let min: T = Self.minEsque
        let max: T = Self.maxEsque
        let msb: T = Self.msbEsque
        let bot: T = Self.botEsque
        //=--------------------------------------=
        test.subtraction(T.zero, min, F(min.complement(), error:  T.isSigned && !T.size.isInfinite))
        test.subtraction(T.zero, max, F(max.complement(), error: !T.isSigned))
        test.subtraction(T.zero, msb, F(msb.complement(), error: !T.isSigned || !T.size.isInfinite))
        test.subtraction(T.zero, bot, F(bot.complement(), error: !T.isSigned))
        //=--------------------------------------=
        test.subtraction(T.zero, ~1 as T, F( 2 as T, error: !T.isSigned))
        test.subtraction(T.zero, ~0 as T, F( 1 as T, error: !T.isSigned))
        test.subtraction(T.zero,  0 as T, F( 0 as T))
        test.subtraction(T.zero,  1 as T, F(~0 as T, error: !T.isSigned))
        test.subtraction(T.zero,  2 as T, F(~1 as T, error: !T.isSigned))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func additionOfMinMaxEsque() where T: BinaryInteger {
        //=--------------------------------------=
        let min: T = Self.minEsque
        let max: T = Self.maxEsque
        //=--------------------------------------=
        test.addition(min,  min, F( min << 001,      error:  (T.isSigned && !T.size.isInfinite)))
        test.addition(min,  max, F(~000))
        test.addition(max,  min, F(~000))
        test.addition(max,  max, F( max << 001,      error: !(T.isSigned &&  T.size.isInfinite)))

        test.addition(min, ~000, F( max |  min << 1, error:  (T.isSigned && !T.size.isInfinite)))
        test.addition(min,  000, F( min))
        test.addition(min,  001, F( min |  001))
        test.addition(max, ~000, F( max ^  001,      error: !(T.isSigned)))
        test.addition(max,  000, F( max))
        test.addition(max,  001, F( min ^  min << 1, error: !(T.isSigned && T.size.isInfinite)))
    }
    
    public func subtractionOfMinMaxEsque() where T: BinaryInteger {
        //=--------------------------------------=
        let min: T = Self.minEsque
        let max: T = Self.maxEsque
        //=--------------------------------------=
        test.subtraction(min,  min, F(000))
        test.subtraction(min,  max, F(001 | min << 1, error: !(T.isSigned &&  T.size.isInfinite)))
        test.subtraction(max,  min, F(001 | max << 1, error:  (T.isSigned && !T.size.isInfinite)))
        test.subtraction(max,  max, F(000))
        
        test.subtraction(min, ~000, F(min | 001,      error: !(T.isSigned)))
        test.subtraction(min,  000, F(min))
        test.subtraction(min,  001, F(max | min << 1, error: !(T.isSigned &&  T.size.isInfinite)))
        test.subtraction(max, ~000, F(min ^ min << 1, error:  (T.isSigned && !T.size.isInfinite)))
        test.subtraction(max,  000, F(max))
        test.subtraction(max,  001, F(max ^ 001))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func additionOfRepeatingBit(_ id: BinaryIntegerID) where T: BinaryInteger {
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
}
