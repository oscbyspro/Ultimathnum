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
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Comparison
//*============================================================================*

final class BinaryIntegerTestsOnComparison: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSignum() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            Test().signum( 0 as T, Signum.zero)
            Test().signum( 1 as T, Signum.positive)
            Test().signum( 2 as T, Signum.positive)
            Test().signum( 3 as T, Signum.positive)
            
            Test().signum(~3 as T, Signum(Sign(T.isSigned)))
            Test().signum(~2 as T, Signum(Sign(T.isSigned)))
            Test().signum(~1 as T, Signum(Sign(T.isSigned)))
            Test().signum(~0 as T, Signum(Sign(T.isSigned)))
            
            Test().signum(Esque<T>.min, -Signum(Bit(T.isSigned)))
            Test().signum(Esque<T>.bot,  Signum.positive)
            Test().signum(Esque<T>.msb,  Signum(Sign(raw: T.isSigned)))
            Test().signum(Esque<T>.max,  Signum.positive)
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testGenericComparisonOfLowEntropies() {
        func whereIs<T, U>(_ lhs: T.Type, _ rhs: U.Type) where T: BinaryInteger, U: BinaryInteger {            
            switch (T.isSigned, U.isSigned) {
            case (true, true):
                Test().comparison( 2 as T,  3 as U, Signum.negative)
                Test().comparison( 2 as T, ~3 as U, Signum.positive)
                Test().comparison(~2 as T,  3 as U, Signum.negative)
                Test().comparison(~2 as T, ~3 as U, Signum.positive)
                
                Test().comparison( 0 as T,  0 as U, Signum.zero)
                Test().comparison( 0 as T, -1 as U, Signum.positive)
                Test().comparison(-1 as T,  0 as U, Signum.negative)
                Test().comparison(-1 as T, -1 as U, Signum.zero)
                
                Test().comparison( 1 as T,  1 as U, Signum.zero)
                Test().comparison( 1 as T, -1 as U, Signum.positive)
                Test().comparison(-1 as T,  1 as U, Signum.negative)
                Test().comparison(-1 as T, -1 as U, Signum.zero)

            case (true, false):
                Test().comparison( 2 as T,  3 as U, Signum.negative)
                Test().comparison( 2 as T, ~3 as U, Signum.negative)
                Test().comparison(~2 as T,  3 as U, Signum.negative)
                Test().comparison(~2 as T, ~3 as U, Signum.negative)
            
            case (false, true):
                Test().comparison( 2 as T,  3 as U, Signum.negative)
                Test().comparison( 2 as T, ~3 as U, Signum.positive)
                Test().comparison(~2 as T,  3 as U, Signum.positive)
                Test().comparison(~2 as T, ~3 as U, Signum.positive)
                
            case (false, false):
                Test().comparison( 2 as T,  3 as U, Signum.negative)
                Test().comparison( 2 as T, ~3 as U, Signum.negative)
                Test().comparison(~2 as T,  3 as U, Signum.positive)
                Test().comparison(~2 as T, ~3 as U, Signum(Sign(raw: T.size < U.size)))
            }
        }
        
        for lhs in binaryIntegers {
            for rhs in binaryIntegers {
                whereIs(lhs, rhs)
            }
        }
    }
    
    func testGenericComparisonOfMinMaxEsque() {
        func whereIs<T, U>(_ lhs: T.Type, _ rhs: U.Type) where T: BinaryInteger, U: BinaryInteger {
            always: do {
                Test().comparison(Esque<T>.min, Esque<U>.max, Signum.negative)
                Test().comparison(Esque<T>.max, Esque<U>.min, Signum.positive)
            }
            
            switch (T.isSigned, U.isSigned) {
            case (true,  true):
                Test().comparison(Esque<T>.min, Esque<U>.min, -T.size.compared(to: U.size))
                Test().comparison(Esque<T>.max, Esque<U>.max,  T.size.compared(to: U.size))
                
            case (true,  false):
                Test().comparison(Esque<T>.min, Esque<U>.min,  Signum.negative)
                Test().comparison(Esque<T>.max, Esque<U>.max, -Signum(Sign(T.size > U.size)))
            
            case (false, true):
                Test().comparison(Esque<T>.min, Esque<U>.min,  Signum.positive)
                Test().comparison(Esque<T>.max, Esque<U>.max,  Signum(Sign(T.size < U.size)))
                
            case (false, false):
                Test().comparison(Esque<T>.min, Esque<U>.min,  Signum.zero)
                Test().comparison(Esque<T>.max, Esque<U>.max,  T.size.compared(to: U.size))
            }
        }
        
        for lhs in binaryIntegers {
            for rhs in binaryIntegers {
                whereIs(lhs, rhs)
            }
        }
    }
    
    func testGenericComparisonOfRepeatingBit() {
        func whereIs<T, U>(_ lhs: T.Type, _ rhs: U.Type) where T: BinaryInteger, U: BinaryInteger {
            always: do {
                Test().comparison(T(repeating: Bit.zero), U(repeating: Bit.zero),  Signum.zero)
                Test().comparison(T(repeating: Bit.zero), U(repeating: Bit.one ), -Signum(Sign(U.isSigned)))
                Test().comparison(T(repeating: Bit.one ), U(repeating: Bit.zero),  Signum(Sign(T.isSigned)))
            }
            
            switch (T.isSigned, U.isSigned) {
            case (true,  true):
                Test().comparison(T(repeating: Bit.one ), U(repeating: Bit.one ),  Signum.zero)
                
            case (true,  false):
                Test().comparison(T(repeating: Bit.one ), U(repeating: Bit.one ),  Signum.negative)
            
            case (false, true):
                Test().comparison(T(repeating: Bit.one ), U(repeating: Bit.one ),  Signum.positive)
                
            case (false, false):
                Test().comparison(T(repeating: Bit.one ), U(repeating: Bit.one ),  T.size.compared(to: U.size))
            }
        }
        
        for lhs in binaryIntegers {
            for rhs in binaryIntegers {
                whereIs(lhs, rhs)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Random
    //=------------------------------------------------------------------------=
    
    /// Here we check that the following invariants hold for all values:
    ///
    ///     integer.hashValue == IXL(load: integer).hashValue
    ///     integer.hashValue == UXL(load: integer).hashValue
    ///
    func testHashValueByFuzzingGenericVersusXL() {
        func whereIs<T>(type: T.Type, size: IX, rounds: IX, randomness: consuming FuzzerInt) where T: BinaryInteger {
            func random() -> T {
                let index = IX.random(in: 00000 ..< size, using: &randomness)!
                let pattern = T.Signitude.random(through: Shift(Count(index)), using: &randomness)
                return T(raw: pattern) // do not forget about infinite values!
            }
            
            for _ in 0 ..< rounds {
                let integer: T = random()
                Test().same(integer.hashValue, IXL(load: integer).hashValue)
                Test().same(integer.hashValue, UXL(load: integer).hashValue)
            }
        }
        
        #if DEBUG
        let rounds: IX = 128
        #else
        let rounds: IX = 512
        #endif
        for type in binaryIntegers {
            whereIs(type: type, size: IX(size: type) ?? 256, rounds: rounds, randomness: fuzzer)
        }
    }
}
