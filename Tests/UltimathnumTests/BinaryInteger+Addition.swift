//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Addition
//*============================================================================*

final class BinaryIntegerTestsOnAddition: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNegation() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            //=----------------------------------=
            let min: T = Esque<T>.min
            let max: T = Esque<T>.max
            let msb: T = Esque<T>.msb
            let bot: T = Esque<T>.bot
            //=----------------------------------=
            Test().subtraction(T.zero, min, Fallible(min.complement(), error:  T.isSigned && !T.size.isInfinite))
            Test().subtraction(T.zero, max, Fallible(max.complement(), error: !T.isSigned))
            Test().subtraction(T.zero, msb, Fallible(msb.complement(), error: !T.isSigned || !T.size.isInfinite))
            Test().subtraction(T.zero, bot, Fallible(bot.complement(), error: !T.isSigned))
            //=----------------------------------=
            Test().subtraction(T.zero, ~1 as T, Fallible( 2 as T, error: !T.isSigned))
            Test().subtraction(T.zero, ~0 as T, Fallible( 1 as T, error: !T.isSigned))
            Test().subtraction(T.zero,  0 as T, Fallible( 0 as T))
            Test().subtraction(T.zero,  1 as T, Fallible(~0 as T, error: !T.isSigned))
            Test().subtraction(T.zero,  2 as T, Fallible(~1 as T, error: !T.isSigned))
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testAdditionOfMinMaxEsque() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            //=----------------------------------=
            let min: T = Esque<T>.min
            let max: T = Esque<T>.max
            //=----------------------------------=
            Test().addition(min,  min, Fallible( min << 001,      error:  (T.isSigned && !T.size.isInfinite)))
            Test().addition(min,  max, Fallible(~000))
            Test().addition(max,  min, Fallible(~000))
            Test().addition(max,  max, Fallible( max << 001,      error: !(T.isSigned &&  T.size.isInfinite)))

            Test().addition(min, ~000, Fallible( max |  min << 1, error:  (T.isSigned && !T.size.isInfinite)))
            Test().addition(min,  000, Fallible( min))
            Test().addition(min,  001, Fallible( min |  001))
            Test().addition(max, ~000, Fallible( max ^  001,      error: !(T.isSigned)))
            Test().addition(max,  000, Fallible( max))
            Test().addition(max,  001, Fallible( min ^  min << 1, error: !(T.isSigned && T.size.isInfinite)))
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testSubtractionOfMinMaxEsque() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            //=----------------------------------=
            let min: T = Esque<T>.min
            let max: T = Esque<T>.max
            //=----------------------------------=
            Test().subtraction(min,  min, Fallible(000))
            Test().subtraction(min,  max, Fallible(001 | min << 1, error: !(T.isSigned &&  T.size.isInfinite)))
            Test().subtraction(max,  min, Fallible(001 | max << 1, error:  (T.isSigned && !T.size.isInfinite)))
            Test().subtraction(max,  max, Fallible(000))
            
            Test().subtraction(min, ~000, Fallible(min | 001,      error: !(T.isSigned)))
            Test().subtraction(min,  000, Fallible(min))
            Test().subtraction(min,  001, Fallible(max | min << 1, error: !(T.isSigned &&  T.size.isInfinite)))
            Test().subtraction(max, ~000, Fallible(min ^ min << 1, error:  (T.isSigned && !T.size.isInfinite)))
            Test().subtraction(max,  000, Fallible(max))
            Test().subtraction(max,  001, Fallible(max ^ 001))
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testAdditionOfRepeatingBit() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            //=----------------------------------=
            let x0 = T(repeating: 0)
            let x1 = T(repeating: 1)
            //=----------------------------------=
            Test().addition(x0, x0, Fallible(x0))
            Test().addition(x0, x1, Fallible(x1))
            Test().addition(x1, x0, Fallible(x1))
            Test().addition(x1, x1, Fallible(~1, error: !T.isSigned))
            //=----------------------------------=
            for increment: T in [1, 2, 3, ~1, ~2, ~3]  {
                Test().addition(x0, increment, Fallible(increment))
                Test().addition(x1, increment, Fallible(increment &- 1, error: !T.isSigned))
            }
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testSubtractionOfRepeatingBit() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            //=----------------------------------=
            let x0 = T(repeating: 0)
            let x1 = T(repeating: 1)
            //=----------------------------------=
            Test().subtraction(x0, x0, Fallible(x0))
            Test().subtraction(x0, x1, Fallible( 1, error: !T.isSigned))
            Test().subtraction(x1, x0, Fallible(x1))
            Test().subtraction(x1, x1, Fallible(x0))
            //=----------------------------------=
            for decrement: T in [1, 2, 3, ~1, ~2, ~3] {
                Test().subtraction(x0, decrement, Fallible(decrement.complement(), error: !T.isSigned))
                Test().subtraction(x1, decrement, Fallible(decrement.toggled()))
            }
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
}