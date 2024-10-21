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
// MARK: * Divider x Division
//*============================================================================*

@Suite struct DividerTestsOnDivision {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Divider/division - each (U8, U8)")
    func divisionForEachBytePair() {
        var success: IX = 0
        
        for dividend in U8.all {
            for divisor in U8.all {
                if  let divider = Divider(exactly: divisor) {
                    let expectation: Division = dividend.division(Nonzero(divider.div))
                    success &+= IX(Bit(divider.division(dividing: dividend) == expectation))
                    success &+= IX(Bit(divider.quotient(dividing: dividend) == expectation.quotient))
                }
            }
        }
        
        #expect(success == 2 &* 256 &* 255)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Divider/division(_:) - [uniform]", arguments: typesAsSystemsIntegerAsUnsigned, fuzzers)
    func divisionByFuzzingValues(_ type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 1024, release: 8192) {
                let divider  = Divider(T.random(in: T.positives, using: &randomness))
                let dividend = T.random(using: &randomness)
                let expectation:  Division = dividend.division(Nonzero(divider.div))
                Ɣexpect(dividend, division:  divider,  is: expectation)
             }
        }
    }
    
    @Test("Divider/division(_:) - [entropic]", arguments: typesAsSystemsIntegerAsUnsigned, fuzzers)
    func divisionByFuzzingEntropies(_ type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 1024, release: 8192) {
                if  let divider  = Divider(exactly: T.entropic(using: &randomness)) {
                    let dividend = T.entropic(using: &randomness)
                    let expectation:  Division = dividend.division(Nonzero(divider.div))
                    Ɣexpect(dividend, division:  divider,  is: expectation)
                }
            }
        }
    }
    
    @Test("Divider/division(_:) - [power-of-2]", arguments: typesAsSystemsIntegerAsUnsigned, fuzzers)
    func divisionByFuzzingPowerOf2s(_ type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 1024, release: 8192) {
                let divider = Divider(T.lsb.up(Shift.random(using: &randomness)))
                let dividend: T = T.entropic(using: &randomness)
                let expectation:  Division = dividend.division(Nonzero(divider.div))
                Ɣexpect(dividend, division:  divider,  is: expectation)
            }
        }
    }
}

//*============================================================================*
// MARK: * Divider21 x Division x 2-by-1
//*============================================================================*

@Suite struct DividerTestsOnDivision21 {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("Divider21/division(_:) - [uniform]", arguments: typesAsSystemsIntegerAsUnsigned, fuzzers)
    func divisionByFuzzingValues(_ type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 1024, release: 8192) {
                let divider = Divider21(T.random(in: T.positives, using: &randomness))
                let low  = T.random(using: &randomness)
                let high = T.random(using: &randomness)
                let dividend = Doublet(low: low, high: high)
                let expectation = T.division(dividend, by: Nonzero(divider.div))
                Ɣexpect(dividend, division:  divider,  is: expectation)
             }
        }
    }
    
    @Test("Divider21/division(_:) - [entropic]", arguments: typesAsSystemsIntegerAsUnsigned, fuzzers)
    func divisionByFuzzingEntropies(_ type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 1024, release: 8192) {
                if  let divider = Divider21(exactly: T.entropic(using: &randomness)) {
                    let low  = T.entropic(using: &randomness)
                    let high = T.entropic(using: &randomness)
                    let dividend = Doublet(low: low, high: high)
                    let expectation = T.division(dividend, by: Nonzero(divider.div))
                    Ɣexpect(dividend, division:  divider,  is: expectation)
                }
            }
        }
    }
    
    @Test("Divider21/division(_:) - [power-of-2]", arguments: typesAsSystemsIntegerAsUnsigned, fuzzers)
    func divisionByFuzzingPowerOf2s(_ type: any SystemsIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 1024, release: 8192) {
                let divider  = Divider21(T.lsb.up(Shift.random(using: &randomness)))
                let low:  T  = T.entropic(using: &randomness)
                let high: T  = T.entropic(using: &randomness)
                let dividend = Doublet(low: low, high: high)
                let expectation = T.division(dividend, by: Nonzero(divider.div))
                Ɣexpect(dividend, division:  divider,  is: expectation)
            }
        }
    }
}
