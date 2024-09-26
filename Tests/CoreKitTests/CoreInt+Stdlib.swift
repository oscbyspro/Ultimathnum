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
// MARK: * Core Int x Stdlib
//*============================================================================*

@Suite struct CoreIntTestsOnStdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Hashable
    //=------------------------------------------------------------------------=
    
    @Test("T/hashValue vs T.Stdlib/hashValue", arguments: coreIntegers, fuzzers)
    func hashValue(_ type: any CoreInteger.Type, _ randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: CoreInteger {
            for _ in IX.zero ..< 32 {
                let custom = T.random(using: &randomness)
                let stdlib = T.Stdlib(custom)
                #expect(custom.hashValue == stdlib.hashValue)
            }
        }
    }
    
    @Test("AnyHashable(x) vs AnyHashable(x.stdlib())", .tags(.unofficial), arguments: coreIntegers, fuzzers)
    func asAnyHashable(_ type: any CoreInteger.Type, _ randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: CoreInteger {
            for _ in IX.zero ..< 32 {
                let custom = T.random(using: &randomness)
                let stdlib = T.Stdlib(custom)
                #expect(AnyHashable(custom) == AnyHashable(stdlib))
            }
        }
    }
}
