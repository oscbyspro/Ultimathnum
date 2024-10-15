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
// MARK: * Double Int x Multiplication
//*============================================================================*

@Suite("DoubleInt/multiplication - not in protocol")
struct DoubleIntTestsOnMultiplicationNotInProtocol {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 2 by 1 as 3
    //=------------------------------------------------------------------------=
    // TODO: HalveableInteger/multiplication(_:) would let us hoist this test
    //=------------------------------------------------------------------------=
    
    @Test("DoubleInt/multiplication - 213 vs 224 [entropic]", arguments: typesAsCoreInteger, fuzzers)
    func multiplication213vs224(base: any CoreInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(base)
        
        func whereIs<B>(_ base: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            
            for _ in 0 ..< 1024 {
                let lhs = T.entropic(using: &randomness)
                let rhs = B.entropic(using: &randomness)
                
                let result3 = lhs.multiplication(rhs)
                let result4 = lhs.multiplication(T(load: rhs))
                
                #expect(result4.low.low   == result3.low)
                #expect(result4.low.high  == result3.mid)
                #expect(result4.high.low  == B.Magnitude.init(raw: result3.high))
                #expect(result4.high.high == B(repeating: result3.high.appendix))
            }
        }
    }
}
