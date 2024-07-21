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
// MARK: * Binary Integer x Random
//*============================================================================*

final class BinaryIntegerTestsOnRandom: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testRandomThroughBitIndex() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for index in 0 ..< (T.isArbitrary ? 128 : IX(size: T.self)!) {
                let index = Shift<T.Magnitude>(Count(index))
                let limit = IX(raw: index.value) + (T.isSigned ? 1 : 2)
                
                for var randomness: any Randomness in fuzzers {
                    let random = T.random(through: index, using: &randomness)
                    Test().yay(random.entropy() >= Count(00001))
                    Test().yay(random.entropy() <= Count(limit))
                    Test().nay(random.isInfinite)
                }
            }
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
}
