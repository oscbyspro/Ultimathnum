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
    
    func testUpToSmallLimit() {
        func whereIs<T>(_ type: T.Type, using randomness: inout some Randomness) where T: SystemsInteger & UnsignedInteger {
            for limit: T in 1 ... 16 {
                Test().yay(randomness.next(upTo: Nonzero(limit)) < limit)
            }
        }
        
        for type in systemsIntegersWhereIsUnsigned {
            for var randomness in randomnesses {
                whereIs(type, using: &randomness)
            }
        }
    }
    
    func testThroughSmallLimit() {
        func whereIs<T>(_ type: T.Type, using randomness: inout some Randomness) where T: SystemsInteger & UnsignedInteger {
            for limit: T in 0 ..< 16 {
                Test().yay(randomness.next(through: limit) <= limit)
            }
        }
        
        for type in systemsIntegersWhereIsUnsigned {
            for var randomness in randomnesses {
                whereIs(type, using: &randomness)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Req. Determinism
    //=------------------------------------------------------------------------=
    
    func testNextIsSimilarToFill() {
        func whereIs<T>(_ type: T.Type, using randomness: FuzzerInt) where T: SystemsInteger & UnsignedInteger {
            
            var a = randomness
            var b = randomness
            
            for _ in 0 ..< 16 {
                let lhs = a.next(as: T.self)
                var rhs = T.zero
                
                rhs.withUnsafeMutableBinaryIntegerBody {
                    b.fill($0.bytes())
                }
                
                Test().same(lhs, rhs)
            }
        }
        
        for type in systemsIntegersWhereIsUnsigned {
            whereIs(type, using: fuzzer)
        }
    }
    
    func testUpToIsSimilarToThrough() {
        func whereIs<T>(_ type: T.Type, using randomness: FuzzerInt) where T: SystemsInteger & UnsignedInteger {
            
            var a = randomness
            var b = randomness
            
            for limit: T in 0 ..< 16 {
                let lhs = a.next(through: limit)
                let rhs = b.next(upTo: Nonzero(limit + 1))
                Test().same(lhs, rhs)
            }
        }
        
        for type in systemsIntegersWhereIsUnsigned {
            whereIs(type, using: fuzzer)
        }
    }
}
