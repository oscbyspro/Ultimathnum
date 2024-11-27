//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreIop
import CoreKit
import RandomIntIop
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Fuzzer Int x Stdlib
//*============================================================================*

@Suite struct FuzzerIntStdlibTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "FuzzerInt.Stdlib: metadata",
        Tag.List.tags(.documentation)
    )   func metadata() {
        #expect(MemoryLayout<FuzzerInt.Stdlib>.size == 8)
        #expect(FuzzerInt.Stdlib.self as Any is any Swift.RandomNumberGenerator.Type)
    }
    
    
    @Test(
        "FuzzerInt.Stdlib: prefix",
        Tag.List.tags(.documentation),
        arguments: fuzzers
    )   func prefix(randomness: consuming FuzzerInt) throws {
        for _ in 0 ..< 8 {
            var normal  = FuzzerInt(seed: randomness.next())
            var (copy)  = normal
            var stdlibX = normal.stdlib
            var stdlibY = normal.stdlib()
            
            for _ in 0 ..< 8 {
                #expect(copy == normal)
                #expect(stdlibX == stdlibY)
                
                let element: FuzzerInt.Element = normal.next()
                                
                #expect(copy.stdlib.next() == Swift.UInt64(element), "stdlib modify")
                #expect(((stdlibX)).next() == Swift.UInt64(element), "stdlib read")
                #expect(((stdlibY)).next() == Swift.UInt64(element), "stdlib consuming")
                
                #expect(copy == normal)
                #expect(stdlibX == stdlibY)
            }
        }
    }
}
