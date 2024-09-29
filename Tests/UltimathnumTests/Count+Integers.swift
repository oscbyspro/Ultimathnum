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
    
    typealias Example = (source: IXL, expectation: Fallible<String>?)
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Count.exactly(IX.min) == nil")
    func initSameSizeSignedIntegerMinValueIsNil() {
        #expect(Count.exactly(   (IX.min)) == nil)
        #expect(Count.exactly(IXL(IX.min)) == nil)
    }
    
    @Test("Count.exactly(some BinaryInteger) - [documentation]", .serialized, .tags(.documentation), arguments: [
        
        Example(source: IXL(IX.max ) + 2, expectation: nil),
        Example(source: IXL(IX.max ) + 1, expectation: nil),
        Example(source: IXL(IX.max ),     expectation: Fallible("\(IX.max      )")),
        Example(source: IXL(IX.max ) - 1, expectation: Fallible("\(IX.max  -  1)")),
        Example(source: IXL(IX.max ) - 2, expectation: Fallible("\(IX.max  -  2)")),
        
        Example(source: IXL(IX.zero) + 2, expectation: Fallible("\(IX.zero +  2)")),
        Example(source: IXL(IX.zero) + 1, expectation: Fallible("\(IX.zero +  1)")),
        Example(source: IXL(IX.zero),     expectation: Fallible("\(IX.zero     )")),
        Example(source: IXL(IX.zero) - 1, expectation: Fallible("log2(&0+1)-\(IX.zero + 1)").veto()),
        Example(source: IXL(IX.zero) - 2, expectation: Fallible("log2(&0+1)-\(IX.zero + 2)").veto()),
        
        Example(source: IXL(IX.min ) + 2, expectation: Fallible("log2(&0+1)-\(IX.max  - 1)").veto()),
        Example(source: IXL(IX.min ) + 1, expectation: Fallible("log2(&0+1)-\(IX.max     )").veto()),
        Example(source: IXL(IX.min ),     expectation: nil),
        Example(source: IXL(IX.min ) - 1, expectation: nil),
        Example(source: IXL(IX.min ) - 2, expectation: nil),
        
    ]   as [Example]) func initSomeBinaryIntegerExanples(source: IXL, expectation: Fallible<String>?) {
        #expect(Count.exactly(source)?.map(\.description) == expectation)
    }
    
    @Test("Count.exactly(some BinaryInteger) - [entropic]", arguments: binaryIntegers, fuzzers)
    func initSomeBinaryIntegerByFuzzing(source: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(source)
        
        func whereIs<T>(_ source: T.Type) where T: BinaryInteger {
            for _ in 0 ..< 128 {
                let random = T.entropic(through: Shift.max(or: 255), mode: .signed, using: &randomness)
                
                if  IX.zero <= random, random <= IX.max {
                    let expectation = Fallible(Count(raw: IX(load: random)))
                    #expect(Count.exactly(random) == expectation)
                    #expect(Count   .init(random) == expectation.value)
                    
                }   else if  IX.min < random, random < IX.zero {
                    let expectation = Fallible(Count(raw: IX(load: random - 1)), error: true)
                    #expect(Count.exactly(random) == expectation)
                    
                }   else {
                    #expect(Count.exactly(random) == nil)
                }
            }
        }
    }
}
