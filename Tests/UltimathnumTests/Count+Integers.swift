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
import TestKit2

//*============================================================================*
// MARK: * Count x Integers
//*============================================================================*

@Suite struct CountTestsOnIntegers {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Count ← some BinaryInteger - disambiguation", .tags(.disambiguation))
    func disambiguation() {
        func build() {
            _ = Count.init(0)
            _ = Count.init(load: 0)
            _ = Count.exactly(0)
        }
    }
    
    @Test("Count ← some BinaryInteger - documentation", .serialized, .tags(.documentation), arguments: [
        
        (source: IXL(IX.max ) + 2, expectation: nil),
        (source: IXL(IX.max ) + 1, expectation: nil),
        (source: IXL(IX.max ),     expectation: Fallible("\(IX.max      )")),
        (source: IXL(IX.max ) - 1, expectation: Fallible("\(IX.max  -  1)")),
        (source: IXL(IX.max ) - 2, expectation: Fallible("\(IX.max  -  2)")),
        
        (source: IXL(IX.zero) + 2, expectation: Fallible("\(IX.zero +  2)")),
        (source: IXL(IX.zero) + 1, expectation: Fallible("\(IX.zero +  1)")),
        (source: IXL(IX.zero),     expectation: Fallible("\(IX.zero     )")),
        (source: IXL(IX.zero) - 1, expectation: Fallible("log2(&0+1)\(IX.zero - 1)").veto()),
        (source: IXL(IX.zero) - 2, expectation: Fallible("log2(&0+1)\(IX.zero - 2)").veto()),
        
        (source: IXL(IX.min ) + 2, expectation: Fallible("log2(&0+1)\(IX.min  + 2)").veto()),
        (source: IXL(IX.min ) + 1, expectation: Fallible("log2(&0+1)\(IX.min  + 1)").veto()),
        (source: IXL(IX.min ),     expectation: nil),
        (source: IXL(IX.min ) - 1, expectation: nil),
        (source: IXL(IX.min ) - 2, expectation: nil),
        
    ] as [(source: IXL, expectation: Optional<Fallible<String>>)])
    func initSomeBinaryIntegerExamples(source: IXL, expectation: Fallible<String>?) {
        #expect(Count.exactly(source)?.map(\.description) == expectation)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Edges
    //=------------------------------------------------------------------------=
    
    @Test("Count ← IX.min == nil")
    func initSameSizeSignedIntegerMinValueIsNil() {
        #expect(Count(load:      (IX.min)) == nil)
        #expect(Count(load:   IXL(IX.min)) == nil)
        #expect(Count.exactly(   (IX.min)) == nil)
        #expect(Count.exactly(IXL(IX.min)) == nil)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Random
    //=------------------------------------------------------------------------=
    
    @Test("Count ← IX - entropic", arguments: fuzzers)
    func initSameSizeSignedIntegerByFuzzing(randomness: consuming FuzzerInt) {
        for _ in 0 ..< 1024 {
            let random = IX.entropic(using: &randomness)
            
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
    
    @Test("Count ← some BinaryInteger - entropic", arguments: typesAsBinaryInteger, fuzzers)
    func initSomeBinaryIntegerByFuzzing(source: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(source)
        
        func whereIs<T>(_ source: T.Type) where T: BinaryInteger {
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
}
