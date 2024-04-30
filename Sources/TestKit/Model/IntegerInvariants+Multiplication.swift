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
// MARK: * Integer Invariants x Multiplication
//*============================================================================*

extension IntegerInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func multiplicationOfMsb(_ id: SystemsIntegerID) where T: SystemsInteger {
        //=--------------------------------------=
        self.multiplicationOfMsbEsque()
        //=--------------------------------------=
        let msb = T.msb
        let bot = T.msb.toggled()
        //=--------------------------------------=
        always: do {
            test.multiplication(msb, msb, Fallible(T2(low:  000000000, high:  T(raw:  M.msb >> 1)), error: true))
            test.multiplication(msb, bot, Fallible(T2(low:  M.msb,     high:  T(raw:    msb >> 1) - T(Bit(!T.isSigned))), error: true))
            test.multiplication(bot, msb, Fallible(T2(low:  M.msb,     high:  T(raw:    msb >> 1) - T(Bit(!T.isSigned))), error: true))
            test.multiplication(bot, bot, Fallible(T2(low:  000000001, high:  T(raw: ~M.msb >> 1)), error: true))
        };  if T.isSigned {
            test.multiplication(bot,  ~4, Fallible(T2(low:  M.msb + 5, high: ~0000002), error: true))
            test.multiplication(bot,  ~3, Fallible(T2(low:  000000004, high: ~0000001), error: true))
            test.multiplication(bot,  ~2, Fallible(T2(low:  M.msb + 3, high: ~0000001), error: true))
            test.multiplication(bot,  ~1, Fallible(T2(low:  000000002, high: ~0000000), error: true))
            test.multiplication(bot,  ~0, Fallible(T2(low:  M.msb + 1, high: ~0000000)))
            test.multiplication(bot,   0, Fallible(T2(low:  000000000, high:  0000000)))
            test.multiplication(bot,   1, Fallible(T2(low: ~M.msb - 0, high:  0000000)))
            test.multiplication(bot,   2, Fallible(T2(low: ~000000001, high:  0000000), error: true))
            test.multiplication(bot,   3, Fallible(T2(low: ~M.msb - 2, high:  0000001), error: true))
            test.multiplication(bot,   4, Fallible(T2(low: ~000000003, high:  0000001), error: true))
            
            test.multiplication(msb,  ~4, Fallible(T2(low:  M.msb,     high:  0000002), error: true))
            test.multiplication(msb,  ~3, Fallible(T2(low:  000000000, high:  0000002), error: true))
            test.multiplication(msb,  ~2, Fallible(T2(low:  M.msb,     high:  0000001), error: true))
            test.multiplication(msb,  ~1, Fallible(T2(low:  000000000, high:  0000001), error: true))
            test.multiplication(msb,  ~0, Fallible(T2(low:  M.msb,     high:  0000000), error: true))
            test.multiplication(msb,   0, Fallible(T2(low:  000000000, high:  0000000)))
            test.multiplication(msb,   1, Fallible(T2(low:  M.msb,     high: ~0000000)))
            test.multiplication(msb,   2, Fallible(T2(low:  000000000, high: ~0000000), error: true))
            test.multiplication(msb,   3, Fallible(T2(low:  M.msb,     high: ~0000001), error: true))
            test.multiplication(msb,   4, Fallible(T2(low:  000000000, high: ~0000001), error: true))
        }   else {
            test.multiplication(bot,  ~4, Fallible(T2(low:  M.msb + 5, high:  bot - 3), error: true))
            test.multiplication(bot,  ~3, Fallible(T2(low:  000000004, high:  bot - 2), error: true))
            test.multiplication(bot,  ~2, Fallible(T2(low:  M.msb + 3, high:  bot - 2), error: true))
            test.multiplication(bot,  ~1, Fallible(T2(low:  000000002, high:  bot - 1), error: true))
            test.multiplication(bot,  ~0, Fallible(T2(low:  M.msb + 1, high:  bot - 1), error: true))
            test.multiplication(bot,   0, Fallible(T2(low:  000000000, high:  0000000)))
            test.multiplication(bot,   1, Fallible(T2(low: ~M.msb - 0, high:  0000000)))
            test.multiplication(bot,   2, Fallible(T2(low: ~000000001, high:  0000000)))
            test.multiplication(bot,   3, Fallible(T2(low: ~M.msb - 2, high:  0000001), error: true))
            test.multiplication(bot,   4, Fallible(T2(low: ~000000003, high:  0000001), error: true))

            test.multiplication(msb,  ~4, Fallible(T2(low:  M.msb,     high:  bot - 2), error: true))
            test.multiplication(msb,  ~3, Fallible(T2(low:  000000000, high:  bot - 1), error: true))
            test.multiplication(msb,  ~2, Fallible(T2(low:  M.msb,     high:  bot - 1), error: true))
            test.multiplication(msb,  ~1, Fallible(T2(low:  000000000, high:  bot - 0), error: true))
            test.multiplication(msb,  ~0, Fallible(T2(low:  M.msb,     high:  bot - 0), error: true))
            test.multiplication(msb,   0, Fallible(T2(low:  000000000, high:  0000000)))
            test.multiplication(msb,   1, Fallible(T2(low:  M.msb,     high:  0000000)))
            test.multiplication(msb,   2, Fallible(T2(low:  000000000, high:  0000001), error: true))
            test.multiplication(msb,   3, Fallible(T2(low:  M.msb,     high:  0000001), error: true))
            test.multiplication(msb,   4, Fallible(T2(low:  000000000, high:  0000002), error: true))
        }
    }
    
    public func multiplicationOfMsbEsque() where T: BinaryInteger {
        //=--------------------------------------=
        let shl = Self.shlEsque
        let msb = Self.msbEsque
        let bot = Self.botEsque
        let xor = T(repeating: Bit(T.isSigned))
        let add = T(Bit(T.isSigned))
        //=--------------------------------------=
        test.multiplication(msb, msb, Fallible(((msb    ) << shl) ^ xor &+ add, error: !T.size.isInfinite))
        test.multiplication(msb, bot, Fallible(((bot    ) << shl) ^ xor &+ add, error: !T.size.isInfinite))
        test.multiplication(bot, msb, Fallible(((bot    ) << shl) ^ xor &+ add, error: !T.size.isInfinite))
        test.multiplication(bot, bot, Fallible(((bot ^ 1) << shl) | 0000000001, error: !T.size.isInfinite))
        //=--------------------------------------=
        test.multiplication(bot,  ~4, Fallible(0 &- bot << 2 &- bot, error: !(T.size.isInfinite &&  T.isSigned)))
        test.multiplication(bot,  ~3, Fallible(0 &- bot << 2,        error: !(T.size.isInfinite &&  T.isSigned)))
        test.multiplication(bot,  ~2, Fallible(0 &- bot << 1 &- bot, error: !(T.size.isInfinite &&  T.isSigned)))
        test.multiplication(bot,  ~1, Fallible(0 &- bot << 1,        error: !(T.size.isInfinite &&  T.isSigned)))
        test.multiplication(bot,  ~0, Fallible(0 &- bot,             error:  !T.isSigned))
        test.multiplication(bot,   0, Fallible(     000))
        test.multiplication(bot,   1, Fallible(     bot))
        test.multiplication(bot,   2, Fallible(     bot << 1,        error:  !T.size.isInfinite &&  T.isSigned))
        test.multiplication(bot,   3, Fallible(     bot << 1 &+ bot, error: !(T.size.isInfinite)))
        test.multiplication(bot,   4, Fallible(     bot << 2,        error: !(T.size.isInfinite)))
        
        test.multiplication(msb,  ~4, Fallible(0 &- msb << 2 &- msb, error: !(T.size.isInfinite &&  T.isSigned)))
        test.multiplication(msb,  ~3, Fallible(0 &- msb << 2,        error: !(T.size.isInfinite &&  T.isSigned)))
        test.multiplication(msb,  ~2, Fallible(0 &- msb << 1 &- msb, error: !(T.size.isInfinite &&  T.isSigned)))
        test.multiplication(msb,  ~1, Fallible(0 &- msb << 1,        error: !(T.size.isInfinite &&  T.isSigned)))
        test.multiplication(msb,  ~0, Fallible(0 &- msb,             error: !(T.size.isInfinite &&  T.isSigned)))
        test.multiplication(msb,   0, Fallible(     000))
        test.multiplication(msb,   1, Fallible(     msb))
        test.multiplication(msb,   2, Fallible(     msb << 1,        error: !(T.size.isInfinite)))
        test.multiplication(msb,   3, Fallible(     msb << 1 &+ msb, error: !(T.size.isInfinite)))
        test.multiplication(msb,   4, Fallible(     msb << 2,        error: !(T.size.isInfinite)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func multiplicationOfRepeatingBit(_ id: SystemsIntegerID) where T: SystemsInteger {
        //=--------------------------------------=
        let x0 = T(repeating: 0)
        let x1 = T(repeating: 1)
        //=--------------------------------------=
        for multiplier: T in [4, 3, 2, 1, 0, ~0, ~1, ~2, ~3, ~4]  {
            test.multiplication(x0, multiplier, Fallible(T2(low: M(raw: x0), high: x0)))
        }
        
        if  T.isSigned {
            test.multiplication(x1, ~4, Fallible(T2(low:  5, high:  0 as T)))
            test.multiplication(x1, ~3, Fallible(T2(low:  4, high:  0 as T)))
            test.multiplication(x1, ~2, Fallible(T2(low:  3, high:  0 as T)))
            test.multiplication(x1, ~1, Fallible(T2(low:  2, high:  0 as T)))
            test.multiplication(x1, ~0, Fallible(T2(low:  1, high:  0 as T)))
            test.multiplication(x1,  0, Fallible(T2(low:  0, high:  0 as T)))
            test.multiplication(x1,  1, Fallible(T2(low: ~0, high: ~0 as T)))
            test.multiplication(x1,  2, Fallible(T2(low: ~1, high: ~0 as T)))
            test.multiplication(x1,  3, Fallible(T2(low: ~2, high: ~0 as T)))
            test.multiplication(x1,  4, Fallible(T2(low: ~3, high: ~0 as T)))
        }   else {
            test.multiplication(x1, ~4, Fallible(T2(low:  5, high: ~5 as T), error: true))
            test.multiplication(x1, ~3, Fallible(T2(low:  4, high: ~4 as T), error: true))
            test.multiplication(x1, ~2, Fallible(T2(low:  3, high: ~3 as T), error: true))
            test.multiplication(x1, ~1, Fallible(T2(low:  2, high: ~2 as T), error: true))
            test.multiplication(x1, ~0, Fallible(T2(low:  1, high: ~1 as T), error: true))
            test.multiplication(x1,  0, Fallible(T2(low:  0, high:  0 as T)))
            test.multiplication(x1,  1, Fallible(T2(low: ~0, high:  0 as T)))
            test.multiplication(x1,  2, Fallible(T2(low: ~1, high:  1 as T), error: true))
            test.multiplication(x1,  3, Fallible(T2(low: ~2, high:  2 as T), error: true))
            test.multiplication(x1,  4, Fallible(T2(low: ~3, high:  3 as T), error: true))
        }
    }
    
    public func multiplicationOfRepeatingBit(_ id: BinaryIntegerID) where T: BinaryInteger {
        let x0 = T(repeating: 0)
        let x1 = T(repeating: 1)
        
        for multiplier: T in [4, 3, 2, 1, 0, ~0, ~1, ~2, ~3, ~4]  {
            test.multiplication(x0, multiplier, Fallible(x0))
        }
        
        if  T.isSigned {
            test.multiplication(x1, ~4, Fallible( 5 as T))
            test.multiplication(x1, ~3, Fallible( 4 as T))
            test.multiplication(x1, ~2, Fallible( 3 as T))
            test.multiplication(x1, ~1, Fallible( 2 as T))
            test.multiplication(x1, ~0, Fallible( 1 as T))
            test.multiplication(x1,  0, Fallible( 0 as T))
            test.multiplication(x1,  1, Fallible(~0 as T))
            test.multiplication(x1,  2, Fallible(~1 as T))
            test.multiplication(x1,  3, Fallible(~2 as T))
            test.multiplication(x1,  4, Fallible(~3 as T))
        }   else {
            test.multiplication(x1, ~4, Fallible( 5 as T, error: true))
            test.multiplication(x1, ~3, Fallible( 4 as T, error: true))
            test.multiplication(x1, ~2, Fallible( 3 as T, error: true))
            test.multiplication(x1, ~1, Fallible( 2 as T, error: true))
            test.multiplication(x1, ~0, Fallible( 1 as T, error: true))
            test.multiplication(x1,  0, Fallible( 0 as T))
            test.multiplication(x1,  1, Fallible(~0 as T))
            test.multiplication(x1,  2, Fallible(~1 as T, error: true))
            test.multiplication(x1,  3, Fallible(~2 as T, error: true))
            test.multiplication(x1,  4, Fallible(~3 as T, error: true))
        }
    }
}
