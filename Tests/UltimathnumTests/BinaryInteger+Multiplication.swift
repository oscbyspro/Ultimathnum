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
// MARK: * Binary Integer x Multiplication
//*============================================================================*

@Suite struct BinaryIntegerTestsOnMultiplication {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/multiplication: 1-by-1-as-2 for low entropies as signed",
        Tag.List.tags(.generic),
        ParallelizationTrait.serialized,
        arguments: Array<(I8, I8, I8, I8)>.infer([
        
        (I8(~2), I8(~2), I8( 9), I8( 0)),
        (I8(~2), I8(~1), I8( 6), I8( 0)),
        (I8(~2), I8(~0), I8( 3), I8( 0)),
        (I8(~2), I8( 0), I8( 0), I8( 0)),
        (I8(~2), I8( 1), I8(~2), I8(~0)),
        (I8(~2), I8( 2), I8(~5), I8(~0)),
        
        (I8(~1), I8(~2), I8( 6), I8( 0)),
        (I8(~1), I8(~1), I8( 4), I8( 0)),
        (I8(~1), I8(~0), I8( 2), I8( 0)),
        (I8(~1), I8( 0), I8( 0), I8( 0)),
        (I8(~1), I8( 1), I8(~1), I8(~0)),
        (I8(~1), I8( 2), I8(~3), I8(~0)),
        
        (I8(~0), I8(~2), I8( 3), I8( 0)),
        (I8(~0), I8(~1), I8( 2), I8( 0)),
        (I8(~0), I8(~0), I8( 1), I8( 0)),
        (I8(~0), I8( 0), I8( 0), I8( 0)),
        (I8(~0), I8( 1), I8(~0), I8(~0)),
        (I8(~0), I8( 2), I8(~1), I8(~0)),
        
        (I8( 0), I8(~2), I8( 0), I8( 0)),
        (I8( 0), I8(~1), I8( 0), I8( 0)),
        (I8( 0), I8(~0), I8( 0), I8( 0)),
        (I8( 0), I8( 0), I8( 0), I8( 0)),
        (I8( 0), I8( 1), I8( 0), I8( 0)),
        (I8( 0), I8( 2), I8( 0), I8( 0)),
        
        (I8( 1), I8(~2), I8(~2), I8(~0)),
        (I8( 1), I8(~1), I8(~1), I8(~0)),
        (I8( 1), I8(~0), I8(~0), I8(~0)),
        (I8( 1), I8( 0), I8( 0), I8( 0)),
        (I8( 1), I8( 1), I8( 1), I8( 0)),
        (I8( 1), I8( 2), I8( 2), I8( 0)),
        
        (I8( 2), I8(~2), I8(~5), I8(~0)),
        (I8( 2), I8(~1), I8(~3), I8(~0)),
        (I8( 2), I8(~0), I8(~1), I8(~0)),
        (I8( 2), I8( 0), I8( 0), I8( 0)),
        (I8( 2), I8( 1), I8( 2), I8( 0)),
        (I8( 2), I8( 2), I8( 4), I8( 0)),
        
    ])) func someLowEntropiesAsFullWidthAsSigned(
        lhs: I8, rhs: I8, low: I8, high: I8
    )   throws {
        
        for type in typesAsBinaryIntegerAsSigned {
            try whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: SignedInteger {
            let lhs  = T(load: lhs )
            let rhs  = T(load: rhs )
            let low  = T(load: low ).veto(false)
            let high = T(load: high)
                        
            try #require(lhs.times(rhs) == low)
            try #require(lhs.multiplication(rhs) == Doublet(low: T.Magnitude(raw: low.value), high: high))
        }
    }
    
    @Test(
        "BinaryInteger/multiplication: 1-by-1-as-2 for low entropies as unsigned",
        Tag.List.tags(.generic),
        ParallelizationTrait.serialized,
        arguments: Array<(I8, I8, I8, I8, Bool)>.infer([
            
        (I8(~5), I8(~5), I8( 36), I8(~11), true ),
        (I8(~5), I8(~4), I8( 30), I8(~10), true ),
        (I8(~5), I8(~3), I8( 24), I8( ~9), true ),
        (I8(~5), I8(~2), I8( 18), I8( ~8), true ),
        (I8(~5), I8(~1), I8( 12), I8( ~7), true ),
        (I8(~5), I8(~0), I8(  6), I8( ~6), true ),
        (I8(~5), I8( 0), I8(  0), I8(  0), false),
        (I8(~5), I8( 1), I8( ~5), I8(  0), false),
        (I8(~5), I8( 2), I8(~11), I8(  1), true ),
        (I8(~5), I8( 3), I8(~17), I8(  2), true ),
        (I8(~5), I8( 4), I8(~23), I8(  3), true ),
        (I8(~5), I8( 5), I8(~29), I8(  4), true ),
        
        (I8( 0), I8(~5), I8(  0), I8(  0), false),
        (I8( 0), I8(~3), I8(  0), I8(  0), false),
        (I8( 0), I8(~2), I8(  0), I8(  0), false),
        (I8( 0), I8(~1), I8(  0), I8(  0), false),
        (I8( 0), I8(~0), I8(  0), I8(  0), false),
        (I8( 0), I8( 0), I8(  0), I8(  0), false),
        (I8( 0), I8( 1), I8(  0), I8(  0), false),
        (I8( 0), I8( 2), I8(  0), I8(  0), false),
        (I8( 0), I8( 4), I8(  0), I8(  0), false),
        (I8( 0), I8( 5), I8(  0), I8(  0), false),
        
        (I8( 5), I8(~5), I8(~29), I8(  4), true ),
        (I8( 5), I8(~4), I8(~24), I8(  4), true ),
        (I8( 5), I8(~3), I8(~19), I8(  4), true ),
        (I8( 5), I8(~2), I8(~14), I8(  4), true ),
        (I8( 5), I8(~1), I8( ~9), I8(  4), true ),
        (I8( 5), I8(~0), I8( ~4), I8(  4), true ),
        (I8( 5), I8( 0), I8(  0), I8(  0), false),
        (I8( 5), I8( 1), I8(  5), I8(  0), false),
        (I8( 5), I8( 2), I8( 10), I8(  0), false),
        (I8( 5), I8( 3), I8( 15), I8(  0), false),
        (I8( 5), I8( 4), I8( 20), I8(  0), false),
        (I8( 5), I8( 5), I8( 25), I8(  0), false),
        
    ])) func someLowEntropiesAsFullWidthAsUnsigned(
        lhs: I8, rhs: I8, low: I8, high: I8, error: Bool
    )   throws {
        
        for type in typesAsBinaryIntegerAsUnsigned {
            try whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: UnsignedInteger {
            let lhs  = T(load: lhs )
            let rhs  = T(load: rhs )
            let low  = T(load: low ).veto(error)
            let high = T(load: high)
                        
            try #require(lhs.times(rhs) == low)
            try #require(lhs.multiplication(rhs) == Doublet(low: T.Magnitude(raw: low.value), high: high))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/multiplication: random by random",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func randomByRandom(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size:    IX = conditional(
                debug:   IX(size: T.self) ?? 0256,
                release: IX(size: T.self) ?? 4096
            )
            
            let rounds:  IX = conditional(
                debug:   T.isArbitrary ? 16 : 0128,
                release: T.isArbitrary ? 16 : 1024
            )
            
            for _  in 0 ..< rounds {
                let a = T.entropic(size: size, using: &randomness)
                let b = T.entropic(size: size, using: &randomness)
                let c = T.entropic(size: size, using: &randomness)
                let d = T.entropic(size: size, using: &randomness)
                
                let x = Fallible.error {
                    let e: T = a.plus( b).sink(&$0)
                    let f: T = c.plus( d).sink(&$0)
                    return     e.times(f).sink(&$0)
                }
                
                let y = Fallible.error {
                    let e: T = a.times(c).sink(&$0)
                    let f: T = a.times(d).sink(&$0)
                    let g: T = b.times(c).sink(&$0)
                    let h: T = b.times(d).sink(&$0)
                    return e.plus(f).sink(&$0).plus(g).sink(&$0).plus(h).sink(&$0)
                }
                
                always: do {
                    try #require(x.value == y.value)
                }
                
                if !T.isSigned, !x.value.isZero {
                    try #require(x.error == y.error)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/multiplication: random by itself",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func randomByIteself(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size:    IX = conditional(
                debug:   IX(size: T.self) ?? 0256,
                release: IX(size: T.self) ?? 4096
            )
            
            let rounds:  IX = conditional(
                debug:   T.isArbitrary ? 16 : 0128,
                release: T.isArbitrary ? 16 : 1024
            )
            
            for _  in 0 ..< rounds {
                let a = T.entropic(size: size, using: &randomness)
                let b = T.entropic(size: size, using: &randomness)
                
                let x = Fallible.error {
                    a.plus(b).sink(&$0).squared().sink(&$0)
                }
                
                let y = Fallible.error {
                    let c: T = a.squared().sink(&$0)
                    let d: T = a.times(b ).sink(&$0).doubled().sink(&$0)
                    let e: T = b.squared().sink(&$0)
                    return c.plus(d).sink(&$0).plus(e).sink(&$0)
                }
                
                always: do {
                    try #require(x.value == y.value)
                }
                
                if  a.isNegative == b.isNegative {
                    try #require(x.error == y.error)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/multiplication: ascending zeros by ascending zeros",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func ascendingZerosByAscendingZeros(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let index = Shift<T.Magnitude>.max(or: 255)
            let rounds: IX = conditional(
                debug:   T.isArbitrary ? 08 : 0032,
                release: T.isArbitrary ? 32 : 1024
            )
            
            for _ in 0 ..< rounds {
                let i = Shift.random(through: index, using: &randomness)
                let j = Shift.random(through: index, using: &randomness)
                
                let a = T.entropic(through: index, as: Domain.finite, using: &randomness).up(i)
                let b = T.entropic(through: index, as: Domain.finite, using: &randomness).up(j)
                let c = a.multiplication(b)
                
                let x = a.down(i)
                let y = b.down(j)
                let z = x.multiplication(y)
                
                try #require(a == x.up(i))
                try #require(b == y.up(j))
                try #require(c == z.up(i).up(j))
                
                try #require(a.times(b) == T.exactly(c))
                try #require(x.times(y) == T.exactly(z))
            }
        }
    }
    
    @Test(
        "BinaryInteger/multiplication: ascending zeros by itself",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func ascendingZerosByItself(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let index = Shift<T.Magnitude>.max(or: 255)
            let rounds: IX = conditional(
                debug:   T.isArbitrary ? 08 : 0032,
                release: T.isArbitrary ? 32 : 1024
            )
            
            for _ in 0 ..< rounds {
                let i = Shift.random(through: index, using: &randomness)
                let j = i
                
                let a = T.entropic(through: index, as: Domain.finite, using: &randomness).up(i)
                let b = a
                let c = a.multiplication(b)
                
                let x = a.down(i)
                let y = x
                let z = x.multiplication(y)
                
                try #require(a == x.up(i))
                try #require(b == y.up(j))
                try #require(c == z.up(i).up(j))
                
                try #require(a.times(b)  == T.exactly(c))
                try #require(x.times(y)  == T.exactly(z))
                try #require(a.squared() == T.exactly(c))
                try #require(x.squared() == T.exactly(z))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Arbitrary Integer
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/multiplication: (0s, 1s) * (0s, 1s)",
        Tag.List.tags(.generic, .important),
        arguments: typesAsArbitraryIntegerAsByte
    )   func for0s1sBy0s1s(
        type: any ArbitraryInteger.Type
    )   throws {
        
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
        Tag.List.tags(.exhaustive, .generic),
        ConditionTrait.disabled(if: isDebug),
        arguments: Array<(any SystemsInteger.Type, any SystemsInteger.Type)>.infer([
        
        (I8.self, I16.self),
        (I8.self, DoubleInt<I8>.self),
        (U8.self, U16.self),
        (U8.self, DoubleInt<U8>.self),
        
    ])) func full8BitIsHalf16Bit(
        x08: any SystemsInteger.Type, x16: any SystemsInteger.Type
    )   throws {
        
        try  whereIs(x08: x08, x16: x16)
        func whereIs<A, B>(x08: A.Type, x16: B.Type)
        throws where A: SystemsInteger, B: SystemsInteger {
            try #require(A.size == Count(08))
            try #require(B.size == Count(16))
            try #require(A.isSigned == (B.isSigned))
            try withOnlyOneCallToRequire((x08, x16)) { require in
                for lhs in A.all {
                    for rhs in A.all {
                        let result = lhs.multiplication((rhs))
                        let expectation = B(lhs).times(B(rhs))
                
                        require(expectation.error == false)
                        require(result.low  == A.Magnitude(load:    expectation.value))
                        require(result.high == A(load: expectation.value.down(A.size)))
                    }
                }
            }
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
    )   func lowComplements(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
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
    )   func randomByZeroIsZero(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try withOnlyOneCallToRequire(type) { require in
                for _ in 0 ..< 32 {
                    let lhs = T.entropic(through: Shift.max(or: 255), using: &randomness)
                    let rhs = T.zero
                                        
                    require(lhs.times(rhs) == Fallible(T.zero))
                    require(rhs.times(lhs) == Fallible(T.zero))
                    
                    require(lhs.multiplication(rhs) == Doublet<T>())
                    require(rhs.multiplication(lhs) == Doublet<T>())
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/multiplication/edge-cases: x * 1 is x",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func randomByOneIsSelf(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try withOnlyOneCallToRequire(type) { require in
                for _ in 0 ..< 32 {
                    let lhs = T.entropic(through: Shift.max(or: 255), using: &randomness)
                    let rhs = T(1)
                                        
                    require(lhs.times(rhs) == Fallible(lhs))
                    require(rhs.times(lhs) == Fallible(lhs))
                    
                    require(lhs.multiplication(rhs) == Doublet(lhs))
                    require(rhs.multiplication(lhs) == Doublet(lhs))
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/multiplication/edge-cases: x * -1 is -x",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func randomByMinusOneIsAdditiveInverseOfSelf(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
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

//*============================================================================*
// MARK: * Binary Integer x Multiplication x Conveniences
//*============================================================================*

@Suite struct BinaryIntegerTestsOnMultiplicationConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/multiplication/conveniences: x * y as BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func randomByRandomAsBinaryInteger(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let lhs = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let rhs = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let expectation = lhs.times(rhs) as Fallible<T>
                
                if  let expectation = expectation.optional() {
                    try #require(expectation == reduce(lhs, *,  rhs))
                    try #require(expectation == reduce(lhs, *=, rhs))
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/multiplication/conveniences: x * x as BinaryInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func randomByItselfAsBinaryInteger(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let lhs = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let expectation = lhs.squared() as Fallible<T>
                
                if  let expectation = expectation.optional() {
                    try #require(expectation == reduce(lhs, *,  lhs))
                    try #require(expectation == reduce(lhs, *=, lhs))
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Lenient
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/multiplication/conveniences: x * y as LenientInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsArbitraryIntegerAsSigned, fuzzers
    )   func randomByRandomAsLenientInteger(
        type: any ArbitraryIntegerAsSigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsSigned {
            for _ in 0 ..< 32 {
                let lhs = T.entropic(size: 256, using: &randomness)
                let rhs = T.entropic(size: 256, using: &randomness)
                let expectation = lhs.times(rhs) as Fallible<T>
                
                try #require(expectation.optional() == lhs.times(rhs) as T)
                
                if  let expectation = expectation.optional() {
                    try #require(expectation == reduce(lhs, *,  rhs))
                    try #require(expectation == reduce(lhs, *=, rhs))
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/multiplication/conveniences: x * x as LenientInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsArbitraryIntegerAsSigned, fuzzers
    )   func randomByItselfAsLenientInteger(
        type: any ArbitraryIntegerAsSigned.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsSigned {
            for _ in 0 ..< 32 {
                let lhs = T.entropic(size: 256, using: &randomness)
                let expectation = lhs.squared() as Fallible<T>
                
                try #require(expectation.optional() == lhs.times(lhs) as T)
                try #require(expectation.optional() == lhs.squared( ) as T)
                
                if  let expectation = expectation.optional() {
                    try #require(expectation == reduce(lhs, *,  lhs))
                    try #require(expectation == reduce(lhs, *=, lhs))
                }
            }
        }
    }
}
