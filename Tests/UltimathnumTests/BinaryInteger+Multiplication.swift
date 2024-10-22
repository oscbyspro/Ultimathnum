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
// MARK: * Binary Integer x Multiplication
//*============================================================================*

@Suite struct BinaryIntegerTestsOnMultiplication {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("BinaryInteger/multiplication: 1-by-1-as-2 for low entropies as signed", .serialized, arguments: [
        
        (lhs: ~2 as I8, rhs: ~2 as I8, low:  9 as I8, high:  0 as I8),
        (lhs: ~2 as I8, rhs: ~1 as I8, low:  6 as I8, high:  0 as I8),
        (lhs: ~2 as I8, rhs: ~0 as I8, low:  3 as I8, high:  0 as I8),
        (lhs: ~2 as I8, rhs:  0 as I8, low:  0 as I8, high:  0 as I8),
        (lhs: ~2 as I8, rhs:  1 as I8, low: ~2 as I8, high: ~0 as I8),
        (lhs: ~2 as I8, rhs:  2 as I8, low: ~5 as I8, high: ~0 as I8),
        
        (lhs: ~1 as I8, rhs: ~2 as I8, low:  6 as I8, high:  0 as I8),
        (lhs: ~1 as I8, rhs: ~1 as I8, low:  4 as I8, high:  0 as I8),
        (lhs: ~1 as I8, rhs: ~0 as I8, low:  2 as I8, high:  0 as I8),
        (lhs: ~1 as I8, rhs:  0 as I8, low:  0 as I8, high:  0 as I8),
        (lhs: ~1 as I8, rhs:  1 as I8, low: ~1 as I8, high: ~0 as I8),
        (lhs: ~1 as I8, rhs:  2 as I8, low: ~3 as I8, high: ~0 as I8),
        
        (lhs: ~0 as I8, rhs: ~2 as I8, low:  3 as I8, high:  0 as I8),
        (lhs: ~0 as I8, rhs: ~1 as I8, low:  2 as I8, high:  0 as I8),
        (lhs: ~0 as I8, rhs: ~0 as I8, low:  1 as I8, high:  0 as I8),
        (lhs: ~0 as I8, rhs:  0 as I8, low:  0 as I8, high:  0 as I8),
        (lhs: ~0 as I8, rhs:  1 as I8, low: ~0 as I8, high: ~0 as I8),
        (lhs: ~0 as I8, rhs:  2 as I8, low: ~1 as I8, high: ~0 as I8),
        
        (lhs:  0 as I8, rhs: ~2 as I8, low:  0 as I8, high:  0 as I8),
        (lhs:  0 as I8, rhs: ~1 as I8, low:  0 as I8, high:  0 as I8),
        (lhs:  0 as I8, rhs: ~0 as I8, low:  0 as I8, high:  0 as I8),
        (lhs:  0 as I8, rhs:  0 as I8, low:  0 as I8, high:  0 as I8),
        (lhs:  0 as I8, rhs:  1 as I8, low:  0 as I8, high:  0 as I8),
        (lhs:  0 as I8, rhs:  2 as I8, low:  0 as I8, high:  0 as I8),
        
        (lhs:  1 as I8, rhs: ~2 as I8, low: ~2 as I8, high: ~0 as I8),
        (lhs:  1 as I8, rhs: ~1 as I8, low: ~1 as I8, high: ~0 as I8),
        (lhs:  1 as I8, rhs: ~0 as I8, low: ~0 as I8, high: ~0 as I8),
        (lhs:  1 as I8, rhs:  0 as I8, low:  0 as I8, high:  0 as I8),
        (lhs:  1 as I8, rhs:  1 as I8, low:  1 as I8, high:  0 as I8),
        (lhs:  1 as I8, rhs:  2 as I8, low:  2 as I8, high:  0 as I8),
        
        (lhs:  2 as I8, rhs: ~2 as I8, low: ~5 as I8, high: ~0 as I8),
        (lhs:  2 as I8, rhs: ~1 as I8, low: ~3 as I8, high: ~0 as I8),
        (lhs:  2 as I8, rhs: ~0 as I8, low: ~1 as I8, high: ~0 as I8),
        (lhs:  2 as I8, rhs:  0 as I8, low:  0 as I8, high:  0 as I8),
        (lhs:  2 as I8, rhs:  1 as I8, low:  2 as I8, high:  0 as I8),
        (lhs:  2 as I8, rhs:  2 as I8, low:  4 as I8, high:  0 as I8),
        
        
    ] as [(lhs: I8, rhs: I8, low: I8, high: I8)])
    func multiplicationOfLowEntropiesAsFullWidthAsSigned(lhs: I8, rhs: I8, low: I8, high: I8) throws {
        for type in typesAsBinaryIntegerAsSigned {
            try whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: SignedInteger {
            Ɣexpect(T(load: lhs), times: T(load: rhs), is: T(load: low).veto(false), and: T(load: high))
        }
    }
    
    @Test("BinaryInteger/multiplication: 1-by-1-as-2 for low entropies as unsigned", .serialized, arguments: [
        
        (lhs: ~5 as I8, rhs: ~5 as I8, low:  36 as I8, high: ~11 as I8, error: true),
        (lhs: ~5 as I8, rhs: ~4 as I8, low:  30 as I8, high: ~10 as I8, error: true),
        (lhs: ~5 as I8, rhs: ~3 as I8, low:  24 as I8, high:  ~9 as I8, error: true),
        (lhs: ~5 as I8, rhs: ~2 as I8, low:  18 as I8, high:  ~8 as I8, error: true),
        (lhs: ~5 as I8, rhs: ~1 as I8, low:  12 as I8, high:  ~7 as I8, error: true),
        (lhs: ~5 as I8, rhs: ~0 as I8, low:   6 as I8, high:  ~6 as I8, error: true),
        (lhs: ~5 as I8, rhs:  0 as I8, low:   0 as I8, high:   0 as I8, error: false),
        (lhs: ~5 as I8, rhs:  1 as I8, low:  ~5 as I8, high:   0 as I8, error: false),
        (lhs: ~5 as I8, rhs:  2 as I8, low: ~11 as I8, high:   1 as I8, error: true),
        (lhs: ~5 as I8, rhs:  3 as I8, low: ~17 as I8, high:   2 as I8, error: true),
        (lhs: ~5 as I8, rhs:  4 as I8, low: ~23 as I8, high:   3 as I8, error: true),
        (lhs: ~5 as I8, rhs:  5 as I8, low: ~29 as I8, high:   4 as I8, error: true),
        
        (lhs:  0 as I8, rhs: ~5 as I8, low:   0 as I8, high:   0 as I8, error: false),
        (lhs:  0 as I8, rhs: ~3 as I8, low:   0 as I8, high:   0 as I8, error: false),
        (lhs:  0 as I8, rhs: ~2 as I8, low:   0 as I8, high:   0 as I8, error: false),
        (lhs:  0 as I8, rhs: ~1 as I8, low:   0 as I8, high:   0 as I8, error: false),
        (lhs:  0 as I8, rhs: ~0 as I8, low:   0 as I8, high:   0 as I8, error: false),
        (lhs:  0 as I8, rhs:  0 as I8, low:   0 as I8, high:   0 as I8, error: false),
        (lhs:  0 as I8, rhs:  1 as I8, low:   0 as I8, high:   0 as I8, error: false),
        (lhs:  0 as I8, rhs:  2 as I8, low:   0 as I8, high:   0 as I8, error: false),
        (lhs:  0 as I8, rhs:  4 as I8, low:   0 as I8, high:   0 as I8, error: false),
        (lhs:  0 as I8, rhs:  5 as I8, low:   0 as I8, high:   0 as I8, error: false),
        
        (lhs:  5 as I8, rhs: ~5 as I8, low: ~29 as I8, high:   4 as I8, error: true),
        (lhs:  5 as I8, rhs: ~4 as I8, low: ~24 as I8, high:   4 as I8, error: true),
        (lhs:  5 as I8, rhs: ~3 as I8, low: ~19 as I8, high:   4 as I8, error: true),
        (lhs:  5 as I8, rhs: ~2 as I8, low: ~14 as I8, high:   4 as I8, error: true),
        (lhs:  5 as I8, rhs: ~1 as I8, low:  ~9 as I8, high:   4 as I8, error: true),
        (lhs:  5 as I8, rhs: ~0 as I8, low:  ~4 as I8, high:   4 as I8, error: true),
        (lhs:  5 as I8, rhs:  0 as I8, low:   0 as I8, high:   0 as I8, error: false),
        (lhs:  5 as I8, rhs:  1 as I8, low:   5 as I8, high:   0 as I8, error: false),
        (lhs:  5 as I8, rhs:  2 as I8, low:  10 as I8, high:   0 as I8, error: false),
        (lhs:  5 as I8, rhs:  3 as I8, low:  15 as I8, high:   0 as I8, error: false),
        (lhs:  5 as I8, rhs:  4 as I8, low:  20 as I8, high:   0 as I8, error: false),
        (lhs:  5 as I8, rhs:  5 as I8, low:  25 as I8, high:   0 as I8, error: false),
        
        
    ] as [(lhs: I8, rhs: I8, low: I8, high: I8, error: Bool)])
    func multiplicationOfLowEntropiesAsFullWidthAsUnsigned(lhs: I8, rhs: I8, low: I8, high: I8, error: Bool) throws {
        for type in typesAsBinaryIntegerAsUnsigned {
            try whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: UnsignedInteger {
            Ɣexpect(T(load: lhs), times: T(load: rhs), is: T(load: low).veto(error), and: T(load: high))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/multiplication: random by random",
        Tag.List.tags(.random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func multiplicationOfRandomByRandom(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? conditional(debug: 256, release: 4096)
            let rounds = !T.isArbitrary ?  conditional(debug: 128, release: 1024) : 16
            
            for _  in 0 ..< rounds {
                let a = T.entropic(size: size, using: &randomness)
                let b = T.entropic(size: size, using: &randomness)
                let c = T.entropic(size: size, using: &randomness)
                let d = T.entropic(size: size, using: &randomness)
                
                let x = Fallible<T>.sink {
                    let e: T = a.plus(b).sink(&$0)
                    let f: T = c.plus(d).sink(&$0)
                    return e.times(f)
                }
                
                let y = Fallible<T>.sink {
                    let e: T = a.times(c).sink(&$0)
                    let f: T = a.times(d).sink(&$0)
                    let g: T = b.times(c).sink(&$0)
                    let h: T = b.times(d).sink(&$0)
                    return e.plus(f).sink(&$0).plus(g).sink(&$0).plus(h)
                }
                
                try #require(x.value == y.value)
                
                if !T.isSigned, !x.value.isZero {
                    try #require(x.error == y.error)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/multiplication: random by itself",
        Tag.List.tags(.random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func multiplicationOfRandomByItself(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? conditional(debug: 256, release: 4096)
            let rounds = !T.isArbitrary ?  conditional(debug: 128, release: 1024) : 16
            
            for _  in 0 ..< rounds {
                let a = T.entropic(size: size, using: &randomness)
                let b = T.entropic(size: size, using: &randomness)
                
                let x = Fallible<T>.sink {
                    a.plus(b).sink(&$0).squared()
                }
                
                let y = Fallible<T>.sink {
                    let c: T = a.squared().sink(&$0)
                    let d: T = a.times(b ).sink(&$0).times(2).sink(&$0)
                    let e: T = b.squared().sink(&$0)
                    return c.plus(d).sink(&$0).plus(e)
                }
                
                try #require(x.value == y.value)
                
                if  a.isNegative == b.isNegative {
                    try #require(x.error == y.error)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/multiplication: ascending zeros by ascending zeros",
        Tag.List.tags(.random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func multiplicationOfAscendingZerosByAscendingZeros(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let index = Shift<T.Magnitude>.max(or: 255)
            let rounds: IX = !T.isArbitrary ? conditional(debug: 64, release: 1024) : 32
            
            for _ in 0 ..< rounds {
                let a = Shift.random(through: index, using: &randomness)
                let b = Shift.random(through: index, using: &randomness)
                let c = T  .entropic(through: index, as: Domain.finite, using: &randomness).up(a)
                let d = T  .entropic(through: index, as: Domain.finite, using: &randomness).up(b)
                let e = c.multiplication(d).down(a).down(b)
                let f = c.down(a).multiplication(d.down(b))
                try #require(e == f)
            }
        }
    }
    
    /// - TODO: Consider full-width square multiplication algorithm.
    @Test(
        "BinaryInteger/multiplication: ascending zeros by itself",
        Tag.List.tags(.random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func multiplicationOfAscendingZerosByItself(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let index = Shift<T.Magnitude>.max(or: 255)
            let rounds: IX = !T.isArbitrary ? conditional(debug: 64, release: 1024) : 32
            
            for _ in 0 ..< rounds {
                let a = Shift.random(through: index, using: &randomness)
                let b = T  .entropic(through: index, as: Domain.finite, using: &randomness).up(a)
                try #require(b.squared() == b.times(b))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Arbitrary Integer
    //=------------------------------------------------------------------------=
    
    /// - Note: The `(0s, 1) ⨉ (0s, 1)` case does not fit in the combined size.
    @Test(
        "BinaryInteger/multiplication: zeros then ones",
        Tag.List.tags(.important),
        arguments: typesAsArbitraryIntegerAsByte
    )   func multiplicationOfZerosThenOnes(type: any ArbitraryInteger.Type) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryInteger {
            let size = IX(size: T.Element.self) * 8
            
            var a = T(repeating: Bit.one)
            for i in 0 ... size {
                                
                var b =  T(repeating: Bit.one)
                var c =  a.complement()
                for j in 0 ... size {
                    
                    try #require(a.times(b).value == c)
                    
                    if  i == j {
                        try #require(a.squared().value == c)
                    }
                    
                    c = c.up(Shift.one)
                    b = b.up(Shift.one)
                };  a = a.up(Shift.one)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Systems Integer
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/multiplication: full 8-bit is half 16-bit",
        Tag.List.tags(.exhaustive),
        ConditionTrait.disabled(if: isDebug),
        arguments: [
        
        (x08: I8.self, x16: I16.self),
        (x08: I8.self, x16: DoubleInt<I8>.self),
        (x08: U8.self, x16: U16.self),
        (x08: U8.self, x16: DoubleInt<U8>.self),
        
    ] as [(x08: any SystemsInteger.Type, x16: any SystemsInteger.Type)])
    func multiplicationAsFull8BitIsHalf16Bit(x08: any SystemsInteger.Type, x16: any SystemsInteger.Type) throws {
        try  whereIs(x08, x16)
        
        func whereIs<A, B>(_ x08: A.Type, _ x16: B.Type) throws where A: SystemsInteger, B: SystemsInteger {
            try #require(A.size == Count(08))
            try #require(B.size == Count(16))
            try #require(A.isSigned == B.isSigned)
            
            var success = IX.zero
            
            for lhs in A.all {
                for rhs in A.all {
                    let result = lhs.multiplication((rhs))
                    let expectation = B(lhs).times(B(rhs))
            
                    guard !expectation.error else { continue }
                    guard result.low  == A.Magnitude(load:    expectation.value) else { continue }
                    guard result.high == A(load: expectation.value.down(A.size)) else { continue }
                    
                    success &+= 1
                }
            }
            
            #expect(success == IX(A.all.count) &* IX(A.all.count))
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Multiplication x Edge Cases
//*============================================================================*

@Suite struct BinaryIntgerTestsOnMultiplicationEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/multiplication/edge-cases: low complements",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func multiplicationOfLowComplements(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try withOnlyOneCallToRequire(type) { require in
                for _ in 0 ..< conditional(debug:  16, release: 32) {
                    let lhs = T.entropic(through: Shift.max(or: 255), using: &randomness)
                    let rhs = T.entropic(through: Shift.max(or: 255), using: &randomness)
                    let low = lhs &* rhs
                    
                    let lhsComplement = lhs.complement()
                    let rhsComplement = rhs.complement()
                    let lowComplement = low.complement()
                    
                    require((lhsComplement &* rhs) == lowComplement)
                    require((lhs &* rhsComplement) == lowComplement)
                    require((lhsComplement &* rhsComplement) == low)
                }
                
                for _ in 0 ..< conditional(debug:  16, release: 32) {
                    let int = T.entropic(through: Shift.max(or: 255), using: &randomness)
                    require(int.complement().squared().value == int.squared().value)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/multiplication/edge-cases: x * 0 is 0",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func multiplicationByZeroIsZero(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try withOnlyOneCallToRequire(type) { require in
                for _ in 0 ..< 32 {
                    let lhs = T.entropic(through: Shift.max(or: 255), using: &randomness)
                    let rhs = T.zero
                    
                    let expectation = Doublet<T>()
                    
                    require(lhs.times(rhs) == Fallible(T.zero))
                    require(rhs.times(lhs) == Fallible(T.zero))
                    
                    require(lhs.multiplication(rhs) == expectation)
                    require(rhs.multiplication(lhs) == expectation)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/multiplication/edge-cases: x * 1 is x",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func multiplicationByOneIsSelf(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
                
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try withOnlyOneCallToRequire(type) { require in
                for _ in 0 ..< 32 {
                    let lhs = T.entropic(through: Shift.max(or: 255), using: &randomness)
                    let rhs = T(1)
                    
                    let expectation = Doublet(low: T.Magnitude(raw: lhs), high: T(repeating: Bit(lhs.isNegative)))
                    
                    require(lhs.times(rhs) == Fallible(lhs))
                    require(rhs.times(lhs) == Fallible(lhs))
                    
                    require(lhs.multiplication(rhs) == expectation)
                    require(rhs.multiplication(lhs) == expectation)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/multiplication/edge-cases: x * -1 is -x",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func multiplicationByMinusOneIsAdditiveInverseOfSelf(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try withOnlyOneCallToRequire(type) { require in
                for _ in 0 ..< 32 {
                    let lhs = T.entropic(through: Shift.max(or: 255), using: &randomness)
                    let rhs = T.zero.toggled()
                    
                    var expectation = lhs.negated()
                    if !T.isSigned, lhs  <= T.lsb {
                        expectation.error = false // 0 or 1 times T.max
                    }
                    
                    require(lhs.times(rhs) == expectation)
                    require(rhs.times(lhs) == expectation)
                    
                    if T.isSigned {
                        var full  = Doublet(
                            low:  T.Magnitude.init(raw: expectation.value),
                            high: T(repeating: expectation.value.appendix)
                        )
                        
                        if  expectation.error {
                            full.high = T.zero // T.min times -1
                        }
                        
                        require(lhs.multiplication(rhs) == full)
                        require(rhs.multiplication(lhs) == full)
                    }
                }
            }
        }
    }
}
