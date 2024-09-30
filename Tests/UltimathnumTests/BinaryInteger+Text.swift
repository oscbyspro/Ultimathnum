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
        #if DEBUG
        try  whereIs(type, size: IX(size: type) ?? 0256, rounds: 0032)
        #else
        try  whereIs(type, size: IX(size: type) ?? 4096, rounds: 1024)
        #endif
        func whereIs<T>(_ type: T.Type, size: IX, rounds: IX) throws where T: BinaryInteger {
            for _ in 0 ..< rounds {
                let radix = UX.random(in: 2...36, using: &randomness)
                let coder = try TextInt(radix: radix)
                let value = T.entropic(size: size, mode: .signed, using: &randomness)
                try Ɣexpect(coder.lowercased(), bidirectional: value)
                try Ɣexpect(coder.uppercased(), bidirectional: value)
            }
        }
    }
}
