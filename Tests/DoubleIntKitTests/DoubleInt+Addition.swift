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
import TestKit

//*============================================================================*
// MARK: * Double Int x Addition x Not In Protocol
//*============================================================================*

@Suite struct DoubleIntTestsOnAdditionNotInProtocol {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 2 by 1 as 2
    //=------------------------------------------------------------------------=
    // TODO: HalveableInteger/plus (_:) would let us hoist these tests
    // TODO: HalveableInteger/minus(_:) would let us hoist these tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "DoubleInt/addition/not-in-protocol: random 212 vs 222",
        Tag.List.tags(.generic, .random),
        arguments: DoubleIntTests.bases, fuzzers
    )   func random212vs222(
        base: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(base)
        func whereIs<B>(_ base: B.Type) throws where B: SystemsInteger {
            typealias T = DoubleInt<B>
            
            for _ in 0 ..< 1024 {
                let lhs2 = T.entropic(using: &randomness)
                let rhs1 = B.Magnitude.entropic(using: &randomness)
                let rhs2 = T(load: rhs1)
                                
                try #require(lhs2.plus (rhs1) == lhs2.plus (rhs2))
                try #require(lhs2.minus(rhs1) == lhs2.minus(rhs2))
            }
        }
    }
}
