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
import TestKit

//*============================================================================*
// MARK: * Data Integer x Division
//*============================================================================*

@Suite struct DataIntegerTestsOnDivision {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "DataInt/division: none ÷ some",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegerAsUnsigned, fuzzers
    )   func noneBySome(
        type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let dividend = [] as [T]
                let divisor  = Nonzero(T.random(in: T.positives, using: &randomness))
                try Ɣrequire(dividend, division: divisor, is: [], and: T())
            }
        }
    }
    
    @Test(
        "DataInt/division: some ÷ some",
        arguments: typesAsCoreIntegerAsUnsigned, fuzzers
    )   func someBySome(
        type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let divisor   = Nonzero(T.random(in: T.positives, using: &randomness))
                let remainder = (T).random(in: 0..<divisor.value, using: &randomness)!
                let quotient  = [T].random(count: 1, using: &randomness) + [0]
                var dividend  = quotient
                
                try dividend.withUnsafeMutableBinaryIntegerBody { product in
                    try #require(product.multiply(by: divisor.value, add: remainder).isZero)
                }
                
                try Ɣrequire(dividend, division: divisor, is: quotient, and: remainder)
            }
        }
    }
    
    @Test(
        "DataInt/division: many ÷ some",
        arguments: typesAsCoreIntegerAsUnsigned, fuzzers
    )   func manyBySome(
        type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let divisor   = Nonzero(T.random(in: T.positives, using: &randomness))
                let remainder = (T).random(in: 0..<divisor.value, using: &randomness)!
                let quotient  = [T].random(count: 00...32, using: &randomness) + [0]
                var dividend  = quotient
                
                try dividend.withUnsafeMutableBinaryIntegerBody { product in
                    try #require(product.multiply(by: divisor.value, add: remainder).isZero)
                }
                
                try Ɣrequire(dividend, division: divisor, is: quotient, and: remainder)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    private func Ɣrequire<Element>(
        _   dividend: [Element],
        division divisor: Nonzero<Element>,
        is  quotient: [Element],
        and remainder: Element,
        at  location: SourceLocation = #_sourceLocation
    )   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
        //=--------------------------------------=
        let divider21 = Divider21(divisor)
        //=--------------------------------------=
        if  dividend.count == 1 {
            let expectation: Division = try #require(dividend.first).division(divisor)
            try #require([expectation.quotient ] == quotient,  "division(_:)", sourceLocation: location)
            try #require((expectation.remainder) == remainder, "division(_:)", sourceLocation: location)
        }
        
        remainder: do {
            var i = dividend
            let o = i.withUnsafeMutableBinaryIntegerBody {
                $0.remainder(divisor)
            }
            
            try #require(i == dividend,  "remainder(_:)", sourceLocation: location)
            try #require(o == remainder, "remainder(_:)", sourceLocation: location)
        }
        
        remainder: do {
            var i = dividend
            let o = i.withUnsafeMutableBinaryIntegerBody {
                $0.remainder(divider21)
            }
            
            try #require(i == dividend,  "remainder(_:) - Divider21", sourceLocation: location)
            try #require(o == remainder, "remainder(_:) - Divider21", sourceLocation: location)
        }
        
        division: do {
            var i = dividend
            let o = i.withUnsafeMutableBinaryIntegerBody {
                $0.divisionSetQuotientGetRemainder(divisor)
            }
            
            try #require(i == quotient,  "divisionSetQuotientGetRemainder(_:)", sourceLocation: location)
            try #require(o == remainder, "divisionSetQuotientGetRemainder(_:)", sourceLocation: location)
        }
        
        division: do {
            var i = dividend
            let o = i.withUnsafeMutableBinaryIntegerBody {
                $0.divisionSetQuotientGetRemainder(divider21)
            }
            
            try #require(i == quotient,  "divisionSetQuotientGetRemainder(_:) - Divider21", sourceLocation: location)
            try #require(o == remainder, "divisionSetQuotientGetRemainder(_:) - Divider21", sourceLocation: location)
        }
    }
}
