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
import TestKit

//*============================================================================*
// MARK: * Triple Int x Division
//*============================================================================*

@Suite struct TripleIntTestsOnDivision {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "TripleInt: division 3212MSB (#124)",
        Tag.List.tags(.todo),
        arguments: TripleIntTests.basesAsUnsigned
    )   func division3212MSB(_ base: any SystemsIntegerAsUnsigned.Type) throws {
        
        try  whereIs(base)
        func whereIs<B>(_ type: B.Type) throws where B: SystemsIntegerAsUnsigned {
            typealias X = DoubleInt<B>
            typealias Y = TripleInt<B>
            typealias D = Division<B, DoubleInt<B>>
            //=----------------------------------=
            let x = B.msb
            //=----------------------------------=
            try Ɣrequire(Y(low:  0, mid:  0, high: ~0), by: X(low:  1, high: ~0), is: D(quotient: ~0 as B, remainder: X(low:  1, high: ~1)))
            try Ɣrequire(Y(low:  0, mid:  0, high: ~0), by: X(low: ~1, high: ~0), is: D(quotient: ~0 as B, remainder: X(low: ~1, high:  1)))
            try Ɣrequire(Y(low: ~0, mid: ~0, high: ~1), by: X(low:  0, high: ~0), is: D(quotient: ~0 as B, remainder: X(low: ~0, high: ~1)))
            try Ɣrequire(Y(low: ~0, mid: ~0, high: ~1), by: X(low: ~0, high: ~0), is: D(quotient: ~0 as B, remainder: X(low: ~1, high:  0)))
            
            try Ɣrequire(Y(low:  0, mid:  0, high: ~x), by: X(low: ~0, high:  x), is: D(quotient: ~3 as B, remainder: X(low: ~3, high: 4))) // 2
            try Ɣrequire(Y(low: ~0, mid:  0, high: ~x), by: X(low: ~0, high:  x), is: D(quotient: ~3 as B, remainder: X(low: ~4, high: 5))) // 2
            try Ɣrequire(Y(low:  0, mid: ~0, high: ~x), by: X(low: ~0, high:  x), is: D(quotient: ~1 as B, remainder: X(low: ~1, high: 1))) // 1
            try Ɣrequire(Y(low: ~0, mid: ~0, high: ~x), by: X(low: ~0, high:  x), is: D(quotient: ~1 as B, remainder: X(low: ~2, high: 2))) // 1
            
            
            func Ɣrequire(_ dividend: Y, by divisor: X, is expectation: D) throws {
                try #require(Bool(divisor.msb))
                
                let result: D = dividend.division3212(normalized: Nonzero(divisor))
                try #require(result == expectation)
                
                recover: do {
                    let remainder = TripleInt(
                        low:  result.remainder.low,
                        mid:  result.remainder.high,
                        high: B.zero
                    )
                    
                    let recovered = divisor.multiplication(result.quotient).plus(remainder)
                    try #require(Fallible(dividend) == recovered)
                }
            }
        }
    }
}
