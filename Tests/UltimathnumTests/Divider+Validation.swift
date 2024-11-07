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
// MARK: * Divider x Validation
//*============================================================================*

@Suite struct DividerTestsOnValidation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Divider/validation: initialization",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsIntegerAsUnsigned, fuzzers
    )   func initialization(
        _ type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< 32 {
                let random = T.entropic(using: &randomness)
                
                if  let result = Divider(exactly: random) {
                    try #require(result.div == random)
                }
                
                Ɣexpect(random, as: Divider.self, if: !random.isZero)
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
    
    @Test(
        "Divider21/validation: initialization",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsIntegerAsUnsigned, fuzzers
    )   func initialization(
        _ type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< 32 {
                let random = T.entropic(using: &randomness)
                
                if  let result = Divider21(exactly: random) {
                    try #require(result.div == random)
                }
                
                Ɣexpect(random, as: Divider21.self, if: !random.isZero)
            }
        }
    }
}
