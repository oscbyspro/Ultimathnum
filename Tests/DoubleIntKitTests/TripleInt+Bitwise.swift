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
import TestKit2

//*============================================================================*
// MARK: * Triple Int x Bitwise
//*============================================================================*

@Suite struct TripleIntTestsOnBitwise {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "TripleInt: complement (#124)",
        Tag.List.tags(.todo),
        arguments: TripleIntTests.bases
    )   func complement(base: any SystemsInteger.Type) throws {
        
        try  whereIs(base)
        func whereIs<B>(_ base: B.Type) throws where B: SystemsInteger {
            typealias T = TripleInt<B>
            typealias F = Fallible<T>
            
            try #require(T(low:  0, mid:  0, high:  00000).complement(false) == F(T(low: ~0, mid: ~0, high: ~00000)))
            try #require(T(low:  0, mid:  0, high:  00000).complement(true ) == F(T(low:  0, mid:  0, high:  00000), error: !B.isSigned))
            try #require(T(low:  1, mid:  2, high:  00003).complement(false) == F(T(low: ~1, mid: ~2, high: ~00003)))
            try #require(T(low:  1, mid:  2, high:  00003).complement(true ) == F(T(low: ~0, mid: ~2, high: ~00003)))
            
            try #require(T(low: ~0, mid: ~0, high: ~B.msb).complement(false) == F(T(low:  0, mid:  0, high:  B.msb)))
            try #require(T(low: ~0, mid: ~0, high: ~B.msb).complement(true ) == F(T(low:  1, mid:  0, high:  B.msb)))
            try #require(T(low:  0, mid:  0, high:  B.msb).complement(false) == F(T(low: ~0, mid: ~0, high: ~B.msb)))
            try #require(T(low:  0, mid:  0, high:  B.msb).complement(true ) == F(T(low:  0, mid:  0, high:  B.msb), error:  B.isSigned))
        }
    }
}
