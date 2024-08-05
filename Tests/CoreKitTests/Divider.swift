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
// MARK: * Divider
//*============================================================================*

final class DividerTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInstances() {
        func check<T>(_ divisor: T, mul: T, add: T, shr: T) where T: SystemsInteger & UnsignedInteger {
            let divider = Divider(exactly: divisor)!
            Test().same(divider.multiplier, mul)
            Test().same(divider.increment,  add)
            Test().same(divider.shift.promoted(), shr)
        }
        
        for distance: IX in 0 ..< 8 {
            check(U8 .lsb << distance, mul: U8 .max, add: U8 .max, shr: U8 (distance))
            check(U16.lsb << distance, mul: U16.max, add: U16.max, shr: U16(distance))
            check(U32.lsb << distance, mul: U32.max, add: U32.max, shr: U32(distance))
            check(U64.lsb << distance, mul: U64.max, add: U64.max, shr: U64(distance))
        }
        
        check(07 as U8,  mul: 00000000000000000146, add: 00000000000000000146, shr: 2)
        check(07 as U16, mul: 00000000000000037449, add: 00000000000000037449, shr: 2)
        check(07 as U32, mul: 00000000002454267026, add: 00000000002454267026, shr: 2)
        check(07 as U64, mul: 10540996613548315209, add: 10540996613548315209, shr: 2)
    
        check(10 as U8,  mul: 00000000000000000205, add: 00000000000000000000, shr: 3)
        check(10 as U16, mul: 00000000000000052429, add: 00000000000000000000, shr: 3)
        check(10 as U32, mul: 00000000003435973837, add: 00000000000000000000, shr: 3)
        check(10 as U64, mul: 14757395258967641293, add: 00000000000000000000, shr: 3)
    }
    
    func testInitForEachByteEntropyExtension() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            for divisor in (I8.min...I8.max).lazy.map(T.init(load:)) {
                if !divisor.isZero {
                    Test().same(Divider(divisor).divisor.value, divisor)
                    Test().same(Divider(unchecked: divisor) .divisor.value, divisor)
                    Test().same(Divider(exactly:   divisor)!.divisor.value, divisor)
                    Test().success({ try Divider(divisor, prune: Bad.any).divisor.value }, divisor)
                }   else {
                    Test().none(Divider(exactly: divisor))
                    Test().failure({ try Divider(divisor, prune: Bad.any).divisor.value }, Bad.any)
                }
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Division
    //=------------------------------------------------------------------------=
    
    func testDivisionForEachBytePair() {
        var success: IX = 0
        
        for dividend in U8.min ... U8.max {
            for divisor in U8.min ... U8.max {
                if  let divider = Divider(exactly: divisor) {
                    let expectation = dividend.division(divider.divisor).unwrap()
                    success &+= IX(Bit(divider.quotient(dividing: dividend) == expectation.quotient))
                    success &+= IX(Bit(divider.division(dividing: dividend) == expectation))
                }
            }
        }
        
        Test().same(success, 2 &* 256 &* 255)
    }
    
    func testDivisionByFuzzingValues() {
        func whereIs<T>(_ type: T.Type, rounds: IX, randomness: consuming FuzzerInt) where T: SystemsInteger & UnsignedInteger {
            for _ in 0 ..< rounds {
                let divider = Divider(Nonzero(T.random(in: 1...T.max, using: &randomness)))
                let dividend: T = T.random(using: &randomness)
                let expectation = dividend.division(divider.divisor).unwrap()
                Test().same(divider.quotient(dividing: dividend), expectation.quotient)
                Test().same(divider.division(dividing: dividend), expectation)
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            #if DEBUG
            whereIs(type, rounds: 1024, randomness: fuzzer)
            #else
            whereIs(type, rounds: 8192, randomness: fuzzer)
            #endif
        }
    }
    
    func testDivisionByFuzzingEntropies() {
        func whereIs<T>(_ type: T.Type, rounds: IX, randomness: consuming FuzzerInt) where T: SystemsInteger & UnsignedInteger {
            func random() -> T {
                let index = IX.random(in: 0 ..< IX(size: T.self), using: &randomness)!
                let pattern = T.Signitude.random(through: Shift(Count(index)), using: &randomness)
                return T(raw: pattern)
            }
            
            for _ in 0 ..< rounds {
                guard let divider = Divider(exactly: random()) else { continue }
                let dividend: T = random()
                let expectation = dividend.division(divider.divisor).unwrap()
                Test().same(divider.quotient(dividing: dividend), expectation.quotient)
                Test().same(divider.division(dividing: dividend), expectation)
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            #if DEBUG
            whereIs(type, rounds: 1024, randomness: fuzzer)
            #else
            whereIs(type, rounds: 8192, randomness: fuzzer)
            #endif
        }
    }
    
    func testDivisionByFuzzingPowerOf2Divisors() {
        func whereIs<T>(_ type: T.Type, rounds: IX, randomness: consuming FuzzerInt) where T: SystemsInteger & UnsignedInteger {
            func random() -> Shift<T.Magnitude> {
                Shift(Count(IX.random(in: 0 ..< IX(size: T.self), using: &randomness)!))
            }
            
            for _ in 0 ..< rounds {
                guard let divider = Divider(exactly: T.lsb.up(random())) else { continue }
                let dividend: T = T(raw: T.Signitude.random(through: random(), using: &randomness))
                let expectation = dividend.division(divider.divisor).unwrap()
                Test().same(divider.quotient(dividing: dividend), expectation.quotient)
                Test().same(divider.division(dividing: dividend), expectation)
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            #if DEBUG
            whereIs(type, rounds: 1024, randomness: fuzzer)
            #else
            whereIs(type, rounds: 8192, randomness: fuzzer)
            #endif
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Documentation
//=----------------------------------------------------------------------------=

extension DividerTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testReadmeCodeSnippet() {
        let random  = U8.random()
        let divider = Divider(U8.random(in:    1...255))
        let normal  = random .division(divider .divisor) // division
        let magical = divider.division(dividing: random) // mul-add-shr
        precondition(magical == normal.unwrap())
    }
}
