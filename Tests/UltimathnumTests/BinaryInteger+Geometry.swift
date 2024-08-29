//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Geometry
//*============================================================================*

final class BinaryIntegerTestsOnGeometry: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// Checks all values in `0` through `min(T.max, 255)`.
    func testSquareRootOfSmallValues() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var low  = (base: 0 as U32, square: 0 as U32)
            var high = (base: 1 as U32, square: 1 as U32)
            
            while low.square <= U8.max {
                for value in low.square ..< high.square {
                    guard let value = T.exactly(value).optional() else { return }
                    Test().isqrt(value, T(load: low.base))
                }
                
                low  = high
                high.base = high.base.incremented().unwrap()
                high.square = (high).base.squared().unwrap()
            }
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    /// - Note: A binary algorithm may make a correct initial guess here.
    func testSquareRootOfPowerOf2Squares() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            for index in 0 ..< IX(size: type)/2 {
                let expectation = T.lsb << index
                let power = expectation << index
                Test().isqrt(power, expectation)
            }
        }
                
        for type in systemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    func testSquareRootOfInfiniteOrNegativeIsNil() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            guard type.isSigned || type.isArbitrary else { return }
            Test().none((~0 as  T).isqrt())
            Test().none((~1 as  T).isqrt())
            Test().none((~2 as  T).isqrt())
            Test().none((~3 as  T).isqrt())
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Random
    //=------------------------------------------------------------------------=
    
    func testSquareRootByFuzzing() {
        func whereIs<T>(_ type: T.Type, size: IX, rounds: IX, randomness: consuming FuzzerInt) where T: UnsignedInteger {
            let index = Shift<T>(Count(size/2-1))
            for _  in 0 ..< rounds {
                let expectation = T.random(through: index, using: &randomness)
                let limit = expectation.times(2).incremented().unwrap()
                let error = T.random(in: T.zero ..< limit, using: &randomness) ?? T.zero
                let power = expectation.squared().plus(error)
                Test().same(power.optional()?.isqrt(), expectation)
            }
        }
        
        for type in binaryIntegersWhereIsUnsigned {
            #if DEBUG
            whereIs(type, size: IX(size: type) ?? 128, rounds: 032, randomness: fuzzer)
            #else
            whereIs(type, size: IX(size: type) ?? 256, rounds: 256, randomness: fuzzer)
            #endif
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

extension BinaryIntegerTestsOnGeometry {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testErrorPropagationMechanism() {
        func whereIs<T>(_ type: T.Type, rounds: IX, randomness: consuming FuzzerInt) where T: UnsignedInteger & SystemsInteger {
            var success: IX = 0
            
            func random() -> T {
                let index = IX.random(in: 0..<IX(size: type), using: &randomness)!
                return T.random(through: Shift(Count(index)), using: &randomness)
            }
            
            for _ in 0 ..< rounds {
                let instance: T = random()
                let expectation: Fallible<T> = instance.isqrt().veto(false)
                success &+= IX(Bit(instance.veto(false).isqrt() == expectation))
                success &+= IX(Bit(instance.veto(true ).isqrt() == expectation.veto()))
            }
            
            Test().same(success, rounds &* 2)
        }
        
        for type in systemsIntegersWhereIsUnsigned {
            whereIs(type, rounds: 32, randomness: fuzzer)
        }
    }
}
