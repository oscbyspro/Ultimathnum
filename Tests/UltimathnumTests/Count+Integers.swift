//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Count x Integers
//*============================================================================*

@Suite struct CountTestsOnIntegers {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Count/integers: init(_:) - examples",
        Tag.List.tags(.documentation),
        ParallelizationTrait.serialized,
        arguments: Array<(IXL, Optional<Fallible<String>>)>.infer([
        
        (IXL(IX.max ) + 2, nil),
        (IXL(IX.max ) + 1, nil),
        (IXL(IX.max ),     Fallible("\(IX.max      )")),
        (IXL(IX.max ) - 1, Fallible("\(IX.max  -  1)")),
        (IXL(IX.max ) - 2, Fallible("\(IX.max  -  2)")),
        
        (IXL(IX.zero) + 2, Fallible("\(IX.zero +  2)")),
        (IXL(IX.zero) + 1, Fallible("\(IX.zero +  1)")),
        (IXL(IX.zero),     Fallible("\(IX.zero     )")),
        (IXL(IX.zero) - 1, Fallible("log2(&0+1)\(IX.zero - 1)").veto()),
        (IXL(IX.zero) - 2, Fallible("log2(&0+1)\(IX.zero - 2)").veto()),
        
        (IXL(IX.min ) + 2, Fallible("log2(&0+1)\(IX.min  + 2)").veto()),
        (IXL(IX.min ) + 1, Fallible("log2(&0+1)\(IX.min  + 1)").veto()),
        (IXL(IX.min ),     nil),
        (IXL(IX.min ) - 1, nil),
        (IXL(IX.min ) - 2, nil),
        
    ])) func initSomeBinaryIntegerExamples(
        source: IXL, expectation: Optional<Fallible<String>>
    )   throws {
        #expect(Count.exactly(source)?.map(\.description) == expectation)
    }
    
    @Test(
        "Count/integers: init(_:) - some BinaryInteger",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func initSomeBinaryIntegerByFuzzing(
        source: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(source)
        func whereIs<T>(_ source: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 128 {
                let random = T.entropic(through: Shift.max(or: 255), using: &randomness)
                
                if  IX.zero <= random, random <= IX.max {
                    let expectation = Fallible(Count(raw: IX(random)))
                    #expect(Count.exactly(random) == expectation)
                    #expect(Count(load:   random) == expectation.value)
                    #expect(Count(        random) == expectation.value)
                    
                }   else if  IX.min < random, random < IX.zero {
                    let expectation = Count(raw:  IX(random).decremented().value).veto()
                    #expect(Count.exactly(random) == expectation)
                    #expect(Count(load:   random) == expectation.value)
                    
                }   else {
                    #expect(Count.exactly(random) == nil)
                    #expect(Count(load:   random) == nil)
                }
            }
        }
    }
    
    @Test(
        "Count/integers: init(_:) - IX",
        Tag.List.tags(.random),
        arguments: fuzzers
    )   func initSameSizeSignedIntegerByFuzzing(
        randomness: consuming FuzzerInt
    )   throws {
        for _ in 0 ..< 1024 {
            let random = IX.entropic(using: &randomness)
            
            if  IX.zero <= random, random <= IX.max {
                let expectation = Fallible(Count(raw: IX(random)))
                try #require(Count.exactly(random) == expectation)
                try #require(Count(load:   random) == expectation.value)
                try #require(Count(        random) == expectation.value)

            }   else if  IX.min < random, random < IX.zero {
                let expectation = Count(raw:  IX(random).decremented().value).veto()
                try #require(Count.exactly(random) == expectation)
                try #require(Count(load:   random) == expectation.value)
                
            }   else {
                try #require(Count.exactly(random) == nil)
                try #require(Count(load:   random) == nil)
            }
        }
    }
}

//*============================================================================*
// MARK: * Count x Integers x Edge Cases
//*============================================================================*

@Suite struct CountTestsOnIntegersEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Count/integers: disambiguation",
        Tag.List.tags(.disambiguation)
    )   func disambiguation() {
        func build() {
            _ = Count.init(0)
            _ = Count.init(load: 0)
            _ = Count.exactly(0)
        }
    }
    
    @Test(
        "Count/integers/edge-cases: IX.min → nil",
        Tag.List.tags(.documentation, .important)
    )   func fromSameSizeSignedIntegerMinValueIsNil() {
        #expect(Count(load:      (IX.min)) == nil)
        #expect(Count(load:   IXL(IX.min)) == nil)
        #expect(Count.exactly(   (IX.min)) == nil)
        #expect(Count.exactly(IXL(IX.min)) == nil)
    }
}
