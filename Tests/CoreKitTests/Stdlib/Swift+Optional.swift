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
// MARK: * Swift x Optional
//*============================================================================*

@Suite struct SwiftTestsOnOptional {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("T.init(raw:)", arguments: coreIntegers, fuzzers)
    func bitcasting(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            #expect(Optional<T>(raw: Optional<T.Magnitude>.none) == Optional<T>.none)
            #expect(Optional<T>(raw: Optional<T.Signitude>.none) == Optional<T>.none)
            
            for _ in 0 ..< 32 {
                let magnitude = T.Magnitude.random(using: &randomness)
                let signitude = T.Signitude.random(using: &randomness)
                
                #expect(Optional<T>(raw: Optional(magnitude)) == T(raw: magnitude))
                #expect(Optional<T>(raw: Optional(signitude)) == T(raw: signitude))
            }
        }
    }
    
    @Test("Optional/unwrap()", arguments: coreIntegers, fuzzers)
    func unwrapping(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            let random = T.random(using: &randomness)
            #expect(Optional(random).unwrap()    == random)
            #expect(Optional(random).unchecked() == random)
        }
    }
}
