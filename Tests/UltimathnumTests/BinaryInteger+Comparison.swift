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
// MARK: * Binary Integer x Comparison
//*============================================================================*

final class BinaryIntegerTestsOnComparison: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSignum() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            Test().signum( 0 as T, 0 as Signum)
            Test().signum( 1 as T, 1 as Signum)
            Test().signum( 2 as T, 1 as Signum)
            Test().signum( 3 as T, 1 as Signum)
            
            Test().signum(~3 as T, Signum(Sign(T.isSigned)))
            Test().signum(~2 as T, Signum(Sign(T.isSigned)))
            Test().signum(~1 as T, Signum(Sign(T.isSigned)))
            Test().signum(~0 as T, Signum(Sign(T.isSigned)))
            
            Test().signum(Esque<T>.min, T.isSigned ? -1 : 0 as Signum)
            Test().signum(Esque<T>.bot, 1 as Signum)
            Test().signum(Esque<T>.msb, T.isSigned ? -1 : 1 as Signum)
            Test().signum(Esque<T>.max, 1 as Signum)
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testGenericComparisonOfLowEntropies() {
        func whereIs<T, U>(_ lhs: T.Type, _ rhs: U.Type) where T: BinaryInteger, U: BinaryInteger {            
            switch (T.isSigned, U.isSigned) {
            case (true, true):
                Test().comparison( 2 as T,  3 as U, -1 as Signum)
                Test().comparison( 2 as T, ~3 as U,  1 as Signum)
                Test().comparison(~2 as T,  3 as U, -1 as Signum)
                Test().comparison(~2 as T, ~3 as U,  1 as Signum)
                
                Test().comparison( 0 as T,  0 as U,  0 as Signum)
                Test().comparison( 0 as T, -1 as U,  1 as Signum)
                Test().comparison(-1 as T,  0 as U, -1 as Signum)
                Test().comparison(-1 as T, -1 as U,  0 as Signum)
                
                Test().comparison( 1 as T,  1 as U,  0 as Signum)
                Test().comparison( 1 as T, -1 as U,  1 as Signum)
                Test().comparison(-1 as T,  1 as U, -1 as Signum)
                Test().comparison(-1 as T, -1 as U,  0 as Signum)

            case (true, false):
                Test().comparison( 2 as T,  3 as U, -1 as Signum)
                Test().comparison( 2 as T, ~3 as U, -1 as Signum)
                Test().comparison(~2 as T,  3 as U, -1 as Signum)
                Test().comparison(~2 as T, ~3 as U, -1 as Signum)
            
            case (false, true):
                Test().comparison( 2 as T,  3 as U, -1 as Signum)
                Test().comparison( 2 as T, ~3 as U,  1 as Signum)
                Test().comparison(~2 as T,  3 as U,  1 as Signum)
                Test().comparison(~2 as T, ~3 as U,  1 as Signum)
                
            case (false, false):
                Test().comparison( 2 as T,  3 as U, -1 as Signum)
                Test().comparison( 2 as T, ~3 as U, -1 as Signum)
                Test().comparison(~2 as T,  3 as U,  1 as Signum)
                Test().comparison(~2 as T, ~3 as U,  T.size < U.size ? -1 : 1)
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
                Test().comparison(Esque<T>.min, Esque<U>.max, -1 as Signum)
                Test().comparison(Esque<T>.max, Esque<U>.min,  1 as Signum)
            }
            
            switch (T.isSigned, U.isSigned) {
            case (true,  true):
                Test().comparison(Esque<T>.min, Esque<U>.min, -T.size.compared(to: U.size))
                Test().comparison(Esque<T>.max, Esque<U>.max,  T.size.compared(to: U.size))
                
            case (true,  false):
                Test().comparison(Esque<T>.min, Esque<U>.min, -1 as Signum)
                Test().comparison(Esque<T>.max, Esque<U>.max, -Signum(Sign(T.size > U.size)))
            
            case (false, true):
                Test().comparison(Esque<T>.min, Esque<U>.min,  1 as Signum)
                Test().comparison(Esque<T>.max, Esque<U>.max,  Signum(Sign(T.size < U.size)))
                
            case (false, false):
                Test().comparison(Esque<T>.min, Esque<U>.min,  0 as Signum)
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
                Test().comparison(T(repeating: 0), U(repeating: 0),  Signum.zero)
                Test().comparison(T(repeating: 0), U(repeating: 1), -Signum(Sign(U.isSigned)))
                Test().comparison(T(repeating: 1), U(repeating: 0),  Signum(Sign(T.isSigned)))
            }
            
            switch (T.isSigned, U.isSigned) {
            case (true,  true):
                Test().comparison(T(repeating: 1), U(repeating: 1),  0 as Signum)
                
            case (true,  false):
                Test().comparison(T(repeating: 1), U(repeating: 1), -1 as Signum)
            
            case (false, true):
                Test().comparison(T(repeating: 1), U(repeating: 1),  1 as Signum)
                
            case (false, false):
                Test().comparison(T(repeating: 1), U(repeating: 1),  T.size.compared(to: U.size))
            }
        }
        
        for lhs in binaryIntegers {
            for rhs in binaryIntegers {
                whereIs(lhs, rhs)
            }
        }
    }
}
