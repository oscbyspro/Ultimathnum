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
import RandomIntKit
import TestKit2

//*============================================================================*
// MARK: * Double Int x Multiplication x Not In Protocol
//*============================================================================*

@Suite struct DoubleIntTestsOnMultiplicationNotInProtocol {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 2 by 1 as 3
    //=------------------------------------------------------------------------=
    // TODO: HalveableInteger/multiplication(_:) would let us hoist these tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "DoubleInt/multiplication/not-in-protocol: random 213 vs 224",
        Tag.List.tags(.generic, .random),
        arguments: DoubleIntTests.bases, fuzzers
    )   func random213vs224(base: any SystemsInteger.Type, randomness: consuming FuzzerInt) throws {
        
        try  whereIs(base)
        func whereIs<B>(_ base: B.Type) throws where B: SystemsInteger {
            typealias T = DoubleInt<B>
            
            for _ in 0 ..< 1024 {
                let lhs2 = T.entropic(using: &randomness)
                let rhs1 = B.entropic(using: &randomness)
                let rhs2 = T(load: rhs1)
                
                let result3 = lhs2.multiplication(rhs1)
                let result4 = lhs2.multiplication(rhs2)
                
                try #require(result4.low.low   == result3.low)
                try #require(result4.low.high  == result3.mid)
                try #require(result4.high.low  == B.Magnitude.init(raw: result3.high))
                try #require(result4.high.high == B(repeating: result3.high.appendix))
            }
        }
    }
}
