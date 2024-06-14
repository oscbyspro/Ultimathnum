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
// MARK: * Triple Int x Addition
//*============================================================================*

extension TripleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddition32B() {
        func whereTheBaseIsSigned<B>(_ type: B.Type) where B: SystemsInteger & SignedInteger {
            typealias X = DoubleInt<B>.Magnitude
            typealias Y = TripleInt<B>
            typealias F = Fallible<TripleInt<B>>
            //=----------------------------------=
            let x = B.msb
            //=----------------------------------=
            Test().same(Y(low:  0, mid:  0, high:  0).plus(X(low: ~4, high: ~5)), F(Y(low: ~4, mid: ~5, high:  0)))
            Test().same(Y(low:  1, mid:  2, high:  3).plus(X(low: ~4, high: ~5)), F(Y(low: ~3, mid: ~3, high:  3)))
            Test().same(Y(low: ~1, mid: ~2, high: ~3).plus(X(low:  4, high:  5)), F(Y(low:  2, mid:  3, high: ~2)))
            Test().same(Y(low: ~0, mid: ~0, high: ~0).plus(X(low:  4, high:  5)), F(Y(low:  3, mid:  5, high:  0)))
            
            Test().same(Y(low:  4, mid:  5, high:  x).plus(X(low: ~4, high: ~5)), F(Y(low: ~0, mid: ~0, high:  x)))
            Test().same(Y(low:  5, mid:  5, high:  x).plus(X(low: ~4, high: ~5)), F(Y(low:  0, mid:  0, high:  x ^ 1)))
            Test().same(Y(low: ~4, mid: ~5, high: ~x).plus(X(low:  4, high:  5)), F(Y(low: ~0, mid: ~0, high: ~x)))
            Test().same(Y(low: ~3, mid: ~5, high: ~x).plus(X(low:  4, high:  5)), F(Y(low:  0, mid:  0, high:  x), error: true))
        }
        
        func whereTheBaseIsUnsigned<B>(_ type: B.Type) where B: SystemsInteger & UnsignedInteger {
            typealias X = DoubleInt<B>.Magnitude
            typealias Y = TripleInt<B>
            typealias F = Fallible<TripleInt<B>>
            
            Test().same(Y(low:  0, mid:  0, high:  0).plus(X(low: ~4, high: ~5)), F(Y(low: ~4, mid: ~5, high:  0)))
            Test().same(Y(low:  1, mid:  2, high:  3).plus(X(low: ~4, high: ~5)), F(Y(low: ~3, mid: ~3, high:  3)))
            Test().same(Y(low: ~1, mid: ~2, high: ~3).plus(X(low:  4, high:  5)), F(Y(low:  2, mid:  3, high: ~2)))
            Test().same(Y(low: ~0, mid: ~0, high: ~0).plus(X(low:  4, high:  5)), F(Y(low:  3, mid:  5, high:  0), error: true))
            
            Test().same(Y(low:  4, mid:  5, high: ~0).plus(X(low: ~4, high: ~5)), F(Y(low: ~0, mid: ~0, high: ~0)))
            Test().same(Y(low:  5, mid:  5, high: ~0).plus(X(low: ~4, high: ~5)), F(Y(low:  0, mid:  0, high:  0), error: true))
            Test().same(Y(low: ~4, mid: ~5, high: ~0).plus(X(low:  4, high:  5)), F(Y(low: ~0, mid: ~0, high: ~0)))
            Test().same(Y(low: ~3, mid: ~5, high: ~0).plus(X(low:  4, high:  5)), F(Y(low:  0, mid:  0, high:  0), error: true))
        }
        
        for base in Self.basesWhereIsSigned {
            whereTheBaseIsSigned(base)
        }
        
        for base in Self.basesWhereIsUnsigned {
            whereTheBaseIsUnsigned(base)
        }
    }
    
    func testAddition33B() {
        func whereTheBaseIsSigned<B>(_ type: B.Type) where B: SystemsInteger & SignedInteger {
            typealias X = DoubleInt<B>
            typealias Y = TripleInt<B>
            typealias F = Fallible<TripleInt<B>>
            //=----------------------------------=
            let x = B.msb
            //=----------------------------------=
            Test().same(Y(low:  0, mid:  0, high:  0).plus(Y(low: ~4, mid: ~5, high: ~6)), F(Y(low: ~4, mid: ~5, high: ~6)))
            Test().same(Y(low:  1, mid:  2, high:  3).plus(Y(low: ~4, mid: ~5, high: ~6)), F(Y(low: ~3, mid: ~3, high: ~3)))
            Test().same(Y(low: ~1, mid: ~2, high: ~3).plus(Y(low:  4, mid:  5, high:  6)), F(Y(low:  2, mid:  3, high:  3)))
            Test().same(Y(low: ~0, mid: ~0, high: ~0).plus(Y(low:  4, mid:  5, high:  6)), F(Y(low:  3, mid:  5, high:  6)))
            
            Test().same(Y(low:  5, mid:  5, high:  x + 6).plus(Y(low: ~4, mid: ~5, high: ~6)), F(Y(low:  0, mid:  0, high:  x)))
            Test().same(Y(low:  4, mid:  5, high:  x + 6).plus(Y(low: ~4, mid: ~5, high: ~6)), F(Y(low: ~0, mid: ~0, high: ~x), error: true))
            Test().same(Y(low: ~4, mid: ~5, high: ~x - 6).plus(Y(low:  4, mid:  5, high:  6)), F(Y(low: ~0, mid: ~0, high: ~x)))
            Test().same(Y(low: ~3, mid: ~5, high: ~x - 6).plus(Y(low:  4, mid:  5, high:  6)), F(Y(low:  0, mid:  0, high:  x), error: true))
        }
        
        func whereTheBaseIsUnsigned<B>(_ type: B.Type) where B: SystemsInteger & UnsignedInteger {
            typealias X = DoubleInt<B>
            typealias Y = TripleInt<B>
            typealias F = Fallible<TripleInt<B>>
            
            Test().same(Y(low:  0, mid:  0, high:  0).plus(Y(low: ~4, mid: ~5, high: ~6)), F(Y(low: ~4, mid: ~5, high: ~6)))
            Test().same(Y(low:  1, mid:  2, high:  3).plus(Y(low: ~4, mid: ~5, high: ~6)), F(Y(low: ~3, mid: ~3, high: ~3)))
            Test().same(Y(low: ~1, mid: ~2, high: ~3).plus(Y(low:  4, mid:  5, high:  6)), F(Y(low:  2, mid:  3, high:  3), error: true))
            Test().same(Y(low: ~0, mid: ~0, high: ~0).plus(Y(low:  4, mid:  5, high:  6)), F(Y(low:  3, mid:  5, high:  6), error: true))
            
            Test().same(Y(low:  4, mid:  5, high:  6).plus(Y(low: ~4, mid: ~5, high: ~6)), F(Y(low: ~0, mid: ~0, high: ~0)))
            Test().same(Y(low:  5, mid:  5, high:  6).plus(Y(low: ~4, mid: ~5, high: ~6)), F(Y(low:  0, mid:  0, high:  0), error: true))
            Test().same(Y(low: ~4, mid: ~5, high: ~6).plus(Y(low:  4, mid:  5, high:  6)), F(Y(low: ~0, mid: ~0, high: ~0)))
            Test().same(Y(low: ~3, mid: ~5, high: ~6).plus(Y(low:  4, mid:  5, high:  6)), F(Y(low:  0, mid:  0, high:  0), error: true))
        }
        
        for base in Self.basesWhereIsSigned {
            whereTheBaseIsSigned(base)
        }
        
        for base in Self.basesWhereIsUnsigned {
            whereTheBaseIsUnsigned(base)
        }
    }
}
