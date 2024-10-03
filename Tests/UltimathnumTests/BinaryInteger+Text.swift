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
// MARK: * Binary Integer x Text
//*============================================================================*

@Suite struct BinaryIntegerTestsOnText {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("BinaryInteger/description [bidirectional][entropic]", arguments: binaryIntegers, fuzzers)
    func description(_ type: any BinaryInteger.Type, _ randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: type) ?? conditional(debug: 256, release: 4096)
            
            for _ in 0 ..< conditional(debug: 32, release: 1024) {
                let radix = UX.random(in: 2...36, using: &randomness)
                let coder = try TextInt(radix: radix)
                let value = T.entropic(size: size, mode: .signed, using: &randomness)
                try Ɣexpect(coder.lowercased(), bidirectional: value)
                try Ɣexpect(coder.uppercased(), bidirectional: value)
            }
        }
    }
}
