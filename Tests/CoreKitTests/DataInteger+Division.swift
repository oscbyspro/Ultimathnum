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
    // MARK: Tests x Many ÷ Some
    //=------------------------------------------------------------------------=
    
    @Test("DataInt/division(_:) - 0-by-1 [uniform]", arguments: coreIntegersWhereIsUnsigned, fuzzers)
    func division01(type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let dividend = [] as [T]
                let divisor  = Nonzero(T.random(in: T.positives, using: &randomness))
                try Ɣexpect(dividend, division: divisor, is: [], and: T())
            }
        }
    }
    
    @Test("DataInt/division(_:) - 1-by-1 [uniform]", arguments: coreIntegersWhereIsUnsigned, fuzzers)
    func division11(type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let divisor   = Nonzero(T.random(in: T.positives, using: &randomness))
                let remainder = (T).random(in: 0..<divisor.value, using: &randomness)!
                let quotient  = [T].random(count: 1, using: &randomness) + [0]
                var dividend  = quotient
                
                try dividend.withUnsafeMutableBinaryIntegerBody { product in
                    try #require(product.multiply(by: divisor.value, add: remainder).isZero)
                }
                
                try Ɣexpect(dividend, division: divisor, is: quotient, and: remainder)
            }
        }
    }
    
    @Test("DataInt/division(_:) - X-by-1 [uniform]", arguments: coreIntegersWhereIsUnsigned, fuzzers)
    func divisionX1(type: any SystemsIntegerWhereIsUnsigned.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerWhereIsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let divisor   = Nonzero(T.random(in: T.positives, using: &randomness))
                let remainder = (T).random(in: 0..<divisor.value, using: &randomness)!
                let quotient  = [T].random(count: 00...32, using: &randomness) + [0]
                var dividend  = quotient
                
                try dividend.withUnsafeMutableBinaryIntegerBody { product in
                    try #require(product.multiply(by: divisor.value, add: remainder).isZero)
                }
                
                try Ɣexpect(dividend, division: divisor, is: quotient, and: remainder)
            }
        }
    }
}
