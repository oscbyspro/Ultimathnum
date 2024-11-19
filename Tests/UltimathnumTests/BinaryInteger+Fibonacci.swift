//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import FibonacciKit
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Fibonacci
//*============================================================================*

@Suite struct BinaryIntegerTestsOnFibonacci {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// - Seealso: https://www.wolframalpha.com/input?i=fibonacci%281000%29
    /// - Seealso: https://www.wolframalpha.com/input?i=fibonacci%281024%29
    @Test(
        "BinaryInteger/fibonacci: element at large natural index",
        arguments: Array<(IXL, IXL)>.infer([
        
        (IXL(1000), IXL("""
        0000000000000000000000000000000000000000000000043466557686937456\
        4356885276750406258025646605173717804024817290895365554179490518\
        9040387984007925516929592259308032263477520968962323987332247116\
        1642996440906533187938298969649928516003704476137795166849228875
        """)!),
        
        (IXL(1024), IXL("""
        0000000000000000000000000000000000000000004506699633677819813104\
        3832357288860493678605962186048308030231496000306457087213962487\
        9260914103039624487326658034501121953020936742558101987106764609\
        4200262285202346655868899711089246778413354004103631553925405243
        """)!),
        
    ])) func elementAtLargeNaturalIndex(index: IXL, element: IXL) throws {
        for type in typesAsBinaryInteger {
            try whereIs(type)
        }
            
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            if  let index =  T.exactly  (index).optional() {
                try #require(T.fibonacci(index) == T.exactly(element))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/fibonacci: lossy vs exact",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func lossyVersusExact(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 8 {
                let index = T.entropic(size: 8, as: Domain.finite, using: &randomness)
                let lossy = try #require(T.fibonacci(index))
                let exact = IXL.fibonacci(IXL  (index))
                try #require(lossy == T.exactly(exact))
            }
        }
    }
    
    @Test(
        "BinaryInteger/fibonacci: lossy vs lossy",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func lossyVersusLossy(
        type: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        for other in typesAsSystemsInteger {
            try whereIs(small: type, large: other)
        }
        
        func whereIs<A, B>(small: A.Type, large: B.Type) throws where A: SystemsInteger, B: SystemsInteger {
            guard A.mode == B.mode else { return }
            guard A.size <  B.size else { return }
            
            for _ in 0 ..< conditional(debug: 8, release: 32) {
                let index = A.entropic(using: &randomness)
                let small = A.fibonacci(A(index))
                let large = B.fibonacci(B(index))
                try #require(small == large.map(A.exactly))
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Fibonacci x Conveniences
//*============================================================================*

@Suite struct BinaryIntegerTestsOnFibonacciConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/fibonacci/conveniences: as FiniteInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsFiniteInteger, fuzzers
    )   func asFiniteInteger(
        type: any FiniteInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: FiniteInteger {
            for _ in 0 ..< 8 {
                let index = T.entropic(size: 8, using: &randomness)
                let expectation = T.fibonacci(index) as Optional< Fallible<T>>
                try #require(expectation == T.fibonacci(index) as Fallible<T>)
            }
        }
    }
    
    @Test(
        "BinaryInteger/fibonacci/conveniences: as LenientInteger",
        Tag.List.tags(.forwarding, .generic, .random),
        arguments: typesAsArbitraryIntegerAsSigned, fuzzers
    )   func asLenientInteger(
        type: any ArbitraryIntegerAsSigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: ArbitraryIntegerAsSigned {
            for _ in 0 ..< 32 {
                let index = T.entropic(size: 8, using: &randomness)
                let expectation = T.fibonacci(index) as Optional<Fallible<T>>
                try #require(expectation?.optional() == T.fibonacci(index) as T)
            }
        }
    }
}
