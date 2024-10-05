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
import TestKit2

//*============================================================================*
// MARK: * Data Integer x Division
//*============================================================================*

@Suite struct DataIntegerTestsOnDivision {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("DataInt/division(_:) - 0-by-1 [uniform]", arguments: coreIntegersWhereIsUnsigned, fuzzers)
    func division01(type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let dividend = [] as [T]
                let divisor  = Nonzero(T.random(in: T.positives, using: &randomness))
                try Ɣexpect(bidirectional: dividend, division: divisor, is: [], T())
            }
        }
    }
    
    @Test("DataInt/division(_:) - 1-by-1 [uniform]", arguments: coreIntegersWhereIsUnsigned, fuzzers)
    func division11(type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let dividend = T.random(using: &randomness)
                let divisor  = Nonzero(T.random(in: T.positives, using: &randomness))
                let expectation: Division = dividend.division(divisor)
                try Ɣexpect(bidirectional: [dividend], division: divisor, is: [expectation.quotient], expectation.remainder)
            }
        }
    }
    
    @Test("DataInt/division(_:) - 2-by-1 [uniform]", arguments: coreIntegersWhereIsUnsigned, fuzzers)
    func division21(type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let dividend = Doublet(low: T.random(using: &randomness), high: T.random(using: &randomness))
                let divisor  = Nonzero(T.random(in: T.positives, using: &randomness))
                var remainder = T.zero
                var quotient  = dividend
                (quotient.high, remainder) = T.division(Doublet(low: quotient.high, high: remainder), by: divisor).unwrap().components()
                (quotient.low,  remainder) = T.division(Doublet(low: quotient.low,  high: remainder), by: divisor).unwrap().components()
                try Ɣexpect(bidirectional: [dividend.low, dividend.high], division: divisor, is: [quotient.low, quotient.high], remainder)
            }
        }
    }
    
    @Test("DataInt/division(_:) - X-by-1 [uniform]", arguments: coreIntegersWhereIsUnsigned, fuzzers)
    func divisionX1(type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let count    = Swift.Int(IX.random(in: 000...32, using: &randomness))
                let divisor  = Nonzero(T.random(in: T.positives, using: &randomness))
                let dividend = [T](count: count) {
                    T.random(using: &randomness)
                }
                
                try Ɣexpect(bidirectional: dividend, division: divisor)
            }
        }
    }
}
