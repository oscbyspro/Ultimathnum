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
// MARK: * Binary Integer x Stride
//*============================================================================*

final class BinaryIntegerTestsOnStride: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Random
    //=------------------------------------------------------------------------=
    
    /// Here we check that the following invariant holds for finite values:
    ///
    ///     start.advanced(by: distance) == T.exactly(IXL(start) + IXL(distance))
    ///
    func testAdvancedByFuzzingGenericFiniteValuesVersusIXL() {
        func whereIs<A, B>(type: A.Type, distance: B.Type, rounds: IX, randomness: consuming FuzzerInt) where A: BinaryInteger, B: SignedInteger {
            func random<T>(_ random: T.Type = T.self) -> T where T: BinaryInteger {
                let size  = IX(size: T.self) ?? 128
                let index = IX.random(in: 000000000 ..< size, using: &randomness)!
                return T.random(through: Shift(Count(index)), using: &randomness)
            }
            
            for _ in 0 ..< rounds {
                let start:    A = random()
                let distance: B = random()
                let end: IXL  = IXL(start) + IXL(distance)
                let result =  start.advanced(by: distance)
                let expectation = A.exactly(end)
                Test().same(result, expectation)
            }
        }
        
        #if DEBUG
        let rounds: IX = 032
        #else
        let rounds: IX = 256
        #endif
        for type in binaryIntegers {
            for distance in binaryIntegersWhereIsSigned {
                whereIs(type: type, distance: distance, rounds: rounds, randomness: fuzzer)
            }
        }
    }
}
