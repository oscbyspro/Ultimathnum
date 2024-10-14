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
import TestKit2

//*============================================================================*
// MARK: * Finite
//*============================================================================*

@Suite struct FiniteTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Finite.init - [entropic]", arguments: typesAsBinaryInteger, fuzzers)
    func initByFuzzingEntropies(_ type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)

        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for _ in 0 ..< 128 {
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                Ɣexpect(random, as: Finite.self, if: !random.isInfinite)
                if  let result = Finite(exactly: random) {
                    #expect(result.value == random)
                    #expect(result.magnitude().value == random.magnitude())
                }
            }
        }
    }
}
