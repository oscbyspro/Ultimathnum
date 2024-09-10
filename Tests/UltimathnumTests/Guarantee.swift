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
// MARK: * Guarantee
//*============================================================================*

final class GuaranteeTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Random
    //=------------------------------------------------------------------------=
    
    func testInitByFuzzing() {
        func whereIs<T>(_ type: T.Type, size: IX, rounds: IX, randomness: consuming FuzzerInt) where T: BinaryInteger {
            func random() -> T {
                let index = IX.random(in: 00000 ..< size, using: &randomness)!
                let pattern = T.Signitude.random(through: Shift(Count(index)), using: &randomness)
                return T(raw: pattern) // do not forget about infinite values!
            }
            
            func check<G>(_ value: G.Value, as guarantee: G.Type) where G: Guarantee, G.Value: Equatable {
                if  G.predicate(value) {
                    Test().same(G(           value) .payload(), value)
                    Test().same(G(unchecked: value) .payload(), value)
                    Test().same(G(exactly:   value)?.payload(), value)
                    Test().success(try G(value, prune: Bad.any).payload(), value)
                }   else {
                    Test().none(G(exactly: value))
                    Test().failure(try G(value, prune: Bad.any), Bad.any)
                }
            }
            
            for _ in 0 ..< rounds {
                let ((random)): T = random()
                check(random, as: Finite .self)
                check(random, as: Natural.self)
                check(random, as: Nonzero.self)
                check(Count(raw: IX(load: random)), as: Shift<T.Magnitude>.self)
            }
        }
                
        for type in coreSystemsIntegers {
            whereIs(type, size: IX(size: type), rounds: 16, randomness: fuzzer)
        }
        
        whereIs(DoubleInt<I8>.self, size: 0016, rounds: 16, randomness: fuzzer)
        whereIs(DoubleInt<U8>.self, size: 0016, rounds: 16, randomness: fuzzer)
        
        whereIs(InfiniInt<I8>.self, size: 0064, rounds: 16, randomness: fuzzer)
        whereIs(InfiniInt<U8>.self, size: 0064, rounds: 16, randomness: fuzzer)
    }
}
