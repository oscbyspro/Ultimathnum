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
// MARK: * Triple Int x Addition
//*============================================================================*

@Suite struct TripleIntTestsOnAddition {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "TripleInt: addition 323 (#124)",
        Tag.List.tags(.todo),
        arguments: TripleIntTests.bases
    )   func addition323(_ base: any SystemsInteger.Type) throws {
        
        try  whereIs(base)
        func whereIs<B>(_ type: B.Type) throws where B: SystemsInteger {
            typealias X = DoubleInt<B>.Magnitude
            typealias Y = TripleInt<B>
            typealias F = Fallible<TripleInt<B>>
            //=----------------------------------=
            let x = B.msb
            //=----------------------------------=
            if  B.isSigned {
                try #require(Y(low:  0, mid:  0, high:  0).plus(X(low: ~4, high: ~5)) == F(Y(low: ~4, mid: ~5, high:  0)))
                try #require(Y(low:  1, mid:  2, high:  3).plus(X(low: ~4, high: ~5)) == F(Y(low: ~3, mid: ~3, high:  3)))
                try #require(Y(low: ~1, mid: ~2, high: ~3).plus(X(low:  4, high:  5)) == F(Y(low:  2, mid:  3, high: ~2)))
                try #require(Y(low: ~0, mid: ~0, high: ~0).plus(X(low:  4, high:  5)) == F(Y(low:  3, mid:  5, high:  0)))
                
                try #require(Y(low:  4, mid:  5, high:  x).plus(X(low: ~4, high: ~5)) == F(Y(low: ~0, mid: ~0, high:  x)))
                try #require(Y(low:  5, mid:  5, high:  x).plus(X(low: ~4, high: ~5)) == F(Y(low:  0, mid:  0, high:  x ^ 1)))
                try #require(Y(low: ~4, mid: ~5, high: ~x).plus(X(low:  4, high:  5)) == F(Y(low: ~0, mid: ~0, high: ~x)))
                try #require(Y(low: ~3, mid: ~5, high: ~x).plus(X(low:  4, high:  5)) == F(Y(low:  0, mid:  0, high:  x), error: true))
            }   else {
                try #require(Y(low:  0, mid:  0, high:  0).plus(X(low: ~4, high: ~5)) == F(Y(low: ~4, mid: ~5, high:  0)))
                try #require(Y(low:  1, mid:  2, high:  3).plus(X(low: ~4, high: ~5)) == F(Y(low: ~3, mid: ~3, high:  3)))
                try #require(Y(low: ~1, mid: ~2, high: ~3).plus(X(low:  4, high:  5)) == F(Y(low:  2, mid:  3, high: ~2)))
                try #require(Y(low: ~0, mid: ~0, high: ~0).plus(X(low:  4, high:  5)) == F(Y(low:  3, mid:  5, high:  0), error: true))
                
                try #require(Y(low:  4, mid:  5, high: ~0).plus(X(low: ~4, high: ~5)) == F(Y(low: ~0, mid: ~0, high: ~0)))
                try #require(Y(low:  5, mid:  5, high: ~0).plus(X(low: ~4, high: ~5)) == F(Y(low:  0, mid:  0, high:  0), error: true))
                try #require(Y(low: ~4, mid: ~5, high: ~0).plus(X(low:  4, high:  5)) == F(Y(low: ~0, mid: ~0, high: ~0)))
                try #require(Y(low: ~3, mid: ~5, high: ~0).plus(X(low:  4, high:  5)) == F(Y(low:  0, mid:  0, high:  0), error: true))
            }
        }
    }
    
    @Test(
        "TripleInt: subtraction 323 (#124)",
        Tag.List.tags(.todo),
        arguments: TripleIntTests.bases
    )   func subtraction323(_ base: any SystemsInteger.Type) throws {
        
        try  whereIs(base)
        func whereIs<B>(_ type: B.Type) throws where B: SystemsInteger {
            typealias X = DoubleInt<B>.Magnitude
            typealias Y = TripleInt<B>
            typealias F = Fallible<TripleInt<B>>
            //=----------------------------------=
            let x = B.msb
            //=----------------------------------=
            if  B.isSigned {
                try #require(Y(low:  0, mid:  0, high:  0).minus(X(low: ~4, high: ~5)) == F(Y(low:  5, mid:  5, high: ~0)))
                try #require(Y(low:  1, mid:  2, high:  3).minus(X(low: ~4, high: ~5)) == F(Y(low:  6, mid:  7, high:  2)))
                try #require(Y(low: ~1, mid: ~2, high: ~3).minus(X(low:  4, high:  5)) == F(Y(low: ~5, mid: ~7, high: ~3)))
                try #require(Y(low: ~0, mid: ~0, high: ~0).minus(X(low:  4, high:  5)) == F(Y(low: ~4, mid: ~5, high: ~0)))
                
                try #require(Y(low: ~4, mid: ~5, high: ~x).minus(X(low: ~4, high: ~5)) == F(Y(low:  0, mid:  0, high: ~x)))
                try #require(Y(low: ~5, mid: ~5, high: ~x).minus(X(low: ~4, high: ~5)) == F(Y(low: ~0, mid: ~0, high: ~x ^ 1)))
                try #require(Y(low:  4, mid:  5, high:  x).minus(X(low:  4, high:  5)) == F(Y(low:  0, mid:  0, high:  x)))
                try #require(Y(low:  3, mid:  5, high:  x).minus(X(low:  4, high:  5)) == F(Y(low: ~0, mid: ~0, high: ~x), error: true))
            }   else {
                try #require(Y(low:  0, mid:  0, high:  0).minus(X(low: ~4, high: ~5)) == F(Y(low:  5, mid:  5, high: ~0), error: true))
                try #require(Y(low:  1, mid:  2, high:  3).minus(X(low: ~4, high: ~5)) == F(Y(low:  6, mid:  7, high:  2)))
                try #require(Y(low: ~1, mid: ~2, high: ~3).minus(X(low:  4, high:  5)) == F(Y(low: ~5, mid: ~7, high: ~3)))
                try #require(Y(low: ~0, mid: ~0, high: ~0).minus(X(low:  4, high:  5)) == F(Y(low: ~4, mid: ~5, high: ~0)))
                
                try #require(Y(low: ~4, mid: ~5, high:  0).minus(X(low: ~4, high: ~5)) == F(Y(low:  0, mid:  0, high:  0)))
                try #require(Y(low: ~5, mid: ~5, high:  0).minus(X(low: ~4, high: ~5)) == F(Y(low: ~0, mid: ~0, high: ~0), error: true))
                try #require(Y(low:  4, mid:  5, high:  0).minus(X(low:  4, high:  5)) == F(Y(low:  0, mid:  0, high:  0)))
                try #require(Y(low:  3, mid:  5, high:  0).minus(X(low:  4, high:  5)) == F(Y(low: ~0, mid: ~0, high: ~0), error: true))
            }
        }
    }
    
    @Test(
        "TripleInt: addition 333 (#124)",
        Tag.List.tags(.todo),
        arguments: TripleIntTests.bases
    )   func addition333(base: any SystemsInteger.Type) throws {
        
        try  whereIs(base)
        func whereIs<B>(_ type: B.Type) throws where B: SystemsInteger {
            typealias X = DoubleInt<B>
            typealias Y = TripleInt<B>
            typealias F = Fallible<TripleInt<B>>
            //=----------------------------------=
            let x =  B.msb
            let y =  B.msb + 6
            let z = ~B.msb - 6
            //=----------------------------------=
            if  B.isSigned {
                try #require(Y(low:  0, mid:  0, high:  0).plus(Y(low: ~4, mid: ~5, high: ~6)) == F(Y(low: ~4, mid: ~5, high: ~6)))
                try #require(Y(low:  1, mid:  2, high:  3).plus(Y(low: ~4, mid: ~5, high: ~6)) == F(Y(low: ~3, mid: ~3, high: ~3)))
                try #require(Y(low: ~1, mid: ~2, high: ~3).plus(Y(low:  4, mid:  5, high:  6)) == F(Y(low:  2, mid:  3, high:  3)))
                try #require(Y(low: ~0, mid: ~0, high: ~0).plus(Y(low:  4, mid:  5, high:  6)) == F(Y(low:  3, mid:  5, high:  6)))
                
                try #require(Y(low:  5, mid:  5, high:  y).plus(Y(low: ~4, mid: ~5, high: ~6)) == F(Y(low:  0, mid:  0, high:  x)))
                try #require(Y(low:  4, mid:  5, high:  y).plus(Y(low: ~4, mid: ~5, high: ~6)) == F(Y(low: ~0, mid: ~0, high: ~x), error: true))
                try #require(Y(low: ~4, mid: ~5, high:  z).plus(Y(low:  4, mid:  5, high:  6)) == F(Y(low: ~0, mid: ~0, high: ~x)))
                try #require(Y(low: ~3, mid: ~5, high:  z).plus(Y(low:  4, mid:  5, high:  6)) == F(Y(low:  0, mid:  0, high:  x), error: true))
            }   else {
                try #require(Y(low:  0, mid:  0, high:  0).plus(Y(low: ~4, mid: ~5, high: ~6)) == F(Y(low: ~4, mid: ~5, high: ~6)))
                try #require(Y(low:  1, mid:  2, high:  3).plus(Y(low: ~4, mid: ~5, high: ~6)) == F(Y(low: ~3, mid: ~3, high: ~3)))
                try #require(Y(low: ~1, mid: ~2, high: ~3).plus(Y(low:  4, mid:  5, high:  6)) == F(Y(low:  2, mid:  3, high:  3), error: true))
                try #require(Y(low: ~0, mid: ~0, high: ~0).plus(Y(low:  4, mid:  5, high:  6)) == F(Y(low:  3, mid:  5, high:  6), error: true))
                
                try #require(Y(low:  4, mid:  5, high:  6).plus(Y(low: ~4, mid: ~5, high: ~6)) == F(Y(low: ~0, mid: ~0, high: ~0)))
                try #require(Y(low:  5, mid:  5, high:  6).plus(Y(low: ~4, mid: ~5, high: ~6)) == F(Y(low:  0, mid:  0, high:  0), error: true))
                try #require(Y(low: ~4, mid: ~5, high: ~6).plus(Y(low:  4, mid:  5, high:  6)) == F(Y(low: ~0, mid: ~0, high: ~0)))
                try #require(Y(low: ~3, mid: ~5, high: ~6).plus(Y(low:  4, mid:  5, high:  6)) == F(Y(low:  0, mid:  0, high:  0), error: true))
            }
        }
    }
    
    @Test(
        "TripleInt: subtraction 333 (#124)",
        Tag.List.tags(.todo),
        arguments: TripleIntTests.bases
    )   func subtraction333(_ base: any SystemsInteger.Type) throws {
        
        try  whereIs(base)
        func whereIs<B>(_ type: B.Type) throws where B: SystemsInteger {
            typealias X = DoubleInt<B>
            typealias Y = TripleInt<B>
            typealias F = Fallible<TripleInt<B>>
            //=----------------------------------=
            let x =  B.msb
            let y =  B.msb + 6
            let z = ~B.msb - 6
            //=----------------------------------=
            if  B.isSigned {
                try #require(Y(low:  0, mid:  0, high:  0).minus(Y(low: ~4, mid: ~5, high: ~6)) == F(Y(low:  5, mid:  5, high:  6)))
                try #require(Y(low:  1, mid:  2, high:  3).minus(Y(low: ~4, mid: ~5, high: ~6)) == F(Y(low:  6, mid:  7, high:  9)))
                try #require(Y(low: ~1, mid: ~2, high: ~3).minus(Y(low:  4, mid:  5, high:  6)) == F(Y(low: ~5, mid: ~7, high: ~9)))
                try #require(Y(low: ~0, mid: ~0, high: ~0).minus(Y(low:  4, mid:  5, high:  6)) == F(Y(low: ~4, mid: ~5, high: ~6)))
                
                try #require(Y(low: ~5, mid: ~5, high:  z).minus(Y(low: ~4, mid: ~5, high: ~6)) == F(Y(low: ~0, mid: ~0, high: ~x)))
                try #require(Y(low: ~4, mid: ~5, high:  z).minus(Y(low: ~4, mid: ~5, high: ~6)) == F(Y(low:  0, mid:  0, high:  x), error: true))
                try #require(Y(low:  4, mid:  5, high:  y).minus(Y(low:  4, mid:  5, high:  6)) == F(Y(low:  0, mid:  0, high:  x)))
                try #require(Y(low:  3, mid:  5, high:  y).minus(Y(low:  4, mid:  5, high:  6)) == F(Y(low: ~0, mid: ~0, high: ~x), error: true))
            }   else {
                try #require(Y(low:  0, mid:  0, high:  0).minus(Y(low: ~4, mid: ~5, high: ~6)) == F(Y(low:  5, mid:  5, high:  6), error: true))
                try #require(Y(low:  1, mid:  2, high:  3).minus(Y(low: ~4, mid: ~5, high: ~6)) == F(Y(low:  6, mid:  7, high:  9), error: true))
                try #require(Y(low: ~1, mid: ~2, high: ~3).minus(Y(low:  4, mid:  5, high:  6)) == F(Y(low: ~5, mid: ~7, high: ~9)))
                try #require(Y(low: ~0, mid: ~0, high: ~0).minus(Y(low:  4, mid:  5, high:  6)) == F(Y(low: ~4, mid: ~5, high: ~6)))
                
                try #require(Y(low: ~4, mid: ~5, high: ~6).minus(Y(low: ~4, mid: ~5, high: ~6)) == F(Y(low:  0, mid:  0, high:  0)))
                try #require(Y(low: ~5, mid: ~5, high: ~6).minus(Y(low: ~4, mid: ~5, high: ~6)) == F(Y(low: ~0, mid: ~0, high: ~0), error: true))
                try #require(Y(low:  4, mid:  5, high:  6).minus(Y(low:  4, mid:  5, high:  6)) == F(Y(low:  0, mid:  0, high:  0)))
                try #require(Y(low:  3, mid:  5, high:  6).minus(Y(low:  4, mid:  5, high:  6)) == F(Y(low: ~0, mid: ~0, high: ~0), error: true))
            }
        }
    }
}
