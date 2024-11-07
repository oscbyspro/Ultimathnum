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
// MARK: * Swift x Binary Integer
//*============================================================================*

@Suite struct SwiftTestsOnBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("T.init(raw:)", arguments: typesAsCoreInteger, fuzzers)
    func bitcasting(type: any CoreInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: CoreInteger {
            check(T.min )
            check(T.zero)
            check(T.max )
            
            for _ in 0 ..< 32 {
                check(T.random(using: &randomness))
            }
        }
        
        func check<T>(_ instance: T) where T: CoreInteger {
            var instance    = instance
            let expectation = instance
            
            #expect(expectation == T(     instance.stdlib))
            #expect(expectation == T(raw: instance.stdlib))
            #expect(expectation == T(     instance.stdlib()))
            #expect(expectation == T(raw: instance.stdlib()))
            #expect(expectation == T(     T.Stdlib(     instance)))
            #expect(expectation == T(raw: T.Stdlib(raw: instance)))
        }
    }
}
