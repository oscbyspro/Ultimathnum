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
// MARK: * Randomness
//*============================================================================*

final class RandomnessTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testRandomUpToSmallLimit() {
        func whereIs<T, R>(_ type: T.Type, using randomness: inout R) where T: SystemsInteger & UnsignedInteger, R: Randomness {
            for limit: T in 1 ... 16 {
                Test().yay(randomness.next(upTo: Divisor(limit)) < limit)
            }
        }
        
        for type in systemsIntegersWhereIsUnsigned {
            for var randomness in fuzzers {
                whereIs(type, using: &randomness)
            }
        }
    }
    
    func testRandomThroughSmallLimit() {
        func whereIs<T, R>(_ type: T.Type, using randomness: inout R) where T: SystemsInteger & UnsignedInteger, R: Randomness {
            for limit: T in 0 ..< 16 {
                Test().yay(randomness.next(through: limit) <= limit)
            }
        }
        
        for type in systemsIntegersWhereIsUnsigned {
            for var randomness in fuzzers {
                whereIs(type, using: &randomness)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Req. Determinism
    //=------------------------------------------------------------------------=
    
    func testRandomNextIsSimilarToFill() {
        func whereIs<T>(_ type: T.Type, using randomness: FuzzerInt) where T: SystemsInteger & UnsignedInteger {
            
            var a = randomness
            var b = randomness
            
            for _ in 0 ..< 16 {
                let lhs = a.next(as: T.self)
                var rhs = T.zero
                
                rhs.withUnsafeMutableBinaryIntegerBody {
                    b.fill(UnsafeMutableRawBufferPointer($0.buffer()))
                }
                
                Test().same(lhs, rhs)
            }
        }
        
        for type in systemsIntegersWhereIsUnsigned {
            for randomness in fuzzers {
                whereIs(type, using: randomness)
            }
        }
    }
    
    func testRandomUpToIsSimilarToRandomThrough() {
        func whereIs<T>(_ type: T.Type, using randomness: FuzzerInt) where T: SystemsInteger & UnsignedInteger {
            
            var a = randomness
            var b = randomness
            
            for limit: T in 0 ..< 16 {
                let lhs = a.next(through: limit)
                let rhs = b.next(upTo: Divisor(limit + 1))
                Test().same(lhs, rhs)
            }
        }
        
        for type in systemsIntegersWhereIsUnsigned {
            for randomness in fuzzers {
                whereIs(type, using: randomness)
            }
        }
    }
}
