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
import TestKit2

//*============================================================================*
// MARK: * Divider x Validation
//*============================================================================*

@Suite struct DividerTestsOnValidation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Divider.init - [entropic]", arguments: systemsIntegersWhereIsUnsigned, fuzzers)
    func initByFuzzingEntropies(_ type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) {
        whereIs(type)

        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< 32 {
                let random = T.entropic(using: &randomness)
                Ɣexpect(random, as: Divider.self, if: !random.isZero)
                if  let result = Divider(exactly: random) {
                    #expect(result.div == random)
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Divider x Validation x 2-by-1
//*============================================================================*

@Suite struct DividerTestsOnValidation21 {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Divider21.init - [entropic]", arguments: systemsIntegersWhereIsUnsigned, fuzzers)
    func initByFuzzingEntropies(_ type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) {
        whereIs(type)

        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< 32 {
                let random = T.entropic(using: &randomness)
                Ɣexpect(random, as: Divider21.self, if: !random.isZero)
                if  let result = Divider21(exactly: random) {
                    #expect(result.div == random)
                }
            }
        }
    }
}
