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
// MARK: * Finite
//*============================================================================*

@Suite struct FiniteTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Finite: validation",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func validation(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {

        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 128 {
                let index = Shift<T.Magnitude>.max(or: 255)
                let value = T.entropic(through: index, using: &randomness)
                
                Ɣexpect(value, as: Finite.self, if: !value.isInfinite)
                
                if  let result = Finite(exactly: value) {
                    try #require(result.value == value)
                    try #require(result.magnitude().value == value.magnitude())
                }
            }
        }
    }
}
