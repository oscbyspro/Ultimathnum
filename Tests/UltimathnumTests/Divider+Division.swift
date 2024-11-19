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
// MARK: * Divider x Division
//*============================================================================*

@Suite struct DividerTestsOnDivision {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Divider/division: each (U8, U8) vs BinaryInteger",
        Tag.List.tags(.exhaustive)
    )   func eachBytePairVersusBinaryInteger() {
        withOnlyOneCallToExpect { expect in
            for dividend in U8.all {
                for divisor in U8.all {
                    if  let divider = Divider(exactly: divisor) {
                        let expectation: Division = dividend.division(Nonzero(divider.div))
                        expect(divider.division(dividing: dividend) == expectation)
                        expect(divider.quotient(dividing: dividend) == expectation.quotient)
                    }
                }
            }
        }
    }
    
    @Test(
        "Divider/division: values",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsIntegerAsUnsigned, fuzzers
    )   func values(
        type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 1024, release: 8192) {
                let divider  = Divider(T.random(in: T.positives, using: &randomness))
                let dividend = T.random(using: &randomness)
                let expectation: Division = dividend.division(Nonzero(divider.div))
                try Ɣrequire(dividend, division: divider, is: expectation)
             }
        }
    }
    
    @Test(
        "Divider/division: entropies",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsIntegerAsUnsigned, fuzzers
    )   func entropies(
        type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 1024, release: 8192) {
                if  let divider  = Divider(exactly: T.entropic(using: &randomness)) {
                    let dividend = T.entropic(using: &randomness)
                    let expectation: Division = dividend.division(Nonzero(divider.div))
                    try Ɣrequire(dividend, division: divider, is: expectation)
                }
            }
        }
    }
    
    @Test(
        "Divider/division: where divisor is power of 2",
        Tag.List.tags(.generic, .important, .random),
        arguments: typesAsSystemsIntegerAsUnsigned, fuzzers
    )   func whereDivisorIsPowersOf2(
        type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 1024, release: 8192) {
                let divider = Divider(T.lsb.up(Shift.random(using: &randomness)))
                let dividend: T = T.entropic(using: &randomness)
                let expectation: Division = dividend.division(Nonzero(divider.div))
                try Ɣrequire(dividend, division: divider, is: expectation)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    private func Ɣrequire<T>(
        _  dividend: T,
        division divider: Divider<T>,
        is expectation: Division<T, T>,
        at location: SourceLocation = #_sourceLocation
    )   throws {
        let quotient = expectation.quotient
        try #require(dividend.division(divider) == expectation, sourceLocation: location)
        try #require(dividend.quotient(divider) == quotient,    sourceLocation: location)
    }
}

//*============================================================================*
// MARK: * Divider21 x Division x 2-by-1
//*============================================================================*

@Suite struct DividerTestsOnDivision21 {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    @Test(
        "Divider21/division: values",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsIntegerAsUnsigned, fuzzers
    )   func values(
        type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 1024, release: 8192) {
                let divider = Divider21(T.random(in: T.positives, using: &randomness))
                let low  = T.random(using: &randomness)
                let high = T.random(using: &randomness)
                let dividend = Doublet(low: low, high: high)
                let expectation = T.division(dividend, by: Nonzero(divider.div))
                try Ɣrequire(dividend, division: divider, is: expectation)
             }
        }
    }
    
    @Test(
        "Divider21/division: entropies",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsIntegerAsUnsigned, fuzzers
    )   func entropies(
        type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 1024, release: 8192) {
                if  let divider = Divider21(exactly: T.entropic(using: &randomness)) {
                    let low  = T.entropic(using: &randomness)
                    let high = T.entropic(using: &randomness)
                    let dividend = Doublet(low: low, high: high)
                    let expectation = T.division(dividend, by: Nonzero(divider.div))
                    try Ɣrequire(dividend, division: divider, is: expectation)
                }
            }
        }
    }
    
    @Test(
        "Divider21/division: where divisor is power of 2",
        Tag.List.tags(.generic, .important, .random),
        arguments: typesAsSystemsIntegerAsUnsigned, fuzzers
    )   func whereDivisorIsPowersOf2(
        type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 1024, release: 8192) {
                let divider  = Divider21(T.lsb.up(Shift.random(using: &randomness)))
                let low:  T  = T.entropic(using: &randomness)
                let high: T  = T.entropic(using: &randomness)
                let dividend = Doublet(low: low, high: high)
                let expectation = T.division(dividend, by: Nonzero(divider.div))
                try Ɣrequire(dividend, division: divider, is: expectation)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    private func Ɣrequire<T>(
        _  dividend: Doublet<T>,
        division divider: Divider21<T>,
        is expectation: Fallible<Division<T, T>>,
        at location: SourceLocation = #_sourceLocation
    )   throws {
        let quotient = expectation.map({ $0.quotient })
        try #require(divider.division(dividing: dividend) == expectation, sourceLocation: location)
        try #require(divider.quotient(dividing: dividend) == quotient,    sourceLocation: location)
    }
}
