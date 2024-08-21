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
        func check<T>(_ divisor: T, mul: T, add: T, shr: T, line: UInt = #line) where T: SystemsInteger & UnsignedInteger {
            let divider = Divider(exactly: divisor)!
            Test(line: line).same(divider.multiplier, mul)
            Test(line: line).same(divider.increment,  add)
            Test(line: line).same(divider.shift,      shr)
        }
        
        for distance: IX in 0 ..< 8 {
            check(U8 .lsb << distance, mul: U8 .max, add: U8 .max, shr: 08 + U8 (distance))
            check(U16.lsb << distance, mul: U16.max, add: U16.max, shr: 16 + U16(distance))
            check(U32.lsb << distance, mul: U32.max, add: U32.max, shr: 32 + U32(distance))
            check(U64.lsb << distance, mul: U64.max, add: U64.max, shr: 64 + U64(distance))
        }
        
        check(07 as U8,  mul: 00000000000000000146, add: 00000000000000000146, shr: 08 + 2) // shr: 10
        check(07 as U16, mul: 00000000000000037449, add: 00000000000000037449, shr: 16 + 2) // shr: 18
        check(07 as U32, mul: 00000000002454267026, add: 00000000002454267026, shr: 32 + 2) // shr: 34
        check(07 as U64, mul: 10540996613548315209, add: 10540996613548315209, shr: 64 + 2) // shr: 66
        
        check(10 as U8,  mul: 00000000000000000205, add: 00000000000000000000, shr: 08 + 3) // shr: 11
        check(10 as U16, mul: 00000000000000052429, add: 00000000000000000000, shr: 16 + 3) // shr: 19
        check(10 as U32, mul: 00000000003435973837, add: 00000000000000000000, shr: 32 + 3) // shr: 35
        check(10 as U64, mul: 14757395258967641293, add: 00000000000000000000, shr: 64 + 3) // shr: 67
    }
    
    func testInstances21() {
        func check<T>(_ divisor: T, mul: Doublet<T>, add: Doublet<T>, shr: T, line: UInt = #line) where T: SystemsInteger & UnsignedInteger {
            let divider = Divider21(exactly: divisor)!
            Test(line: line).same(divider.multiplier, mul)
            Test(line: line).same(divider.increment,  add)
            Test(line: line).same(divider.shift,      shr)
        }
        
        for distance: IX in 0 ..< 8 {
            check(U8 .lsb << distance, mul: Doublet(low: U8 .max, high: U8 .max), add: Doublet(low: U8 .max, high: U8 .max), shr: 2 * 08 + U8 (distance))
            check(U16.lsb << distance, mul: Doublet(low: U16.max, high: U16.max), add: Doublet(low: U16.max, high: U16.max), shr: 2 * 16 + U16(distance))
            check(U32.lsb << distance, mul: Doublet(low: U32.max, high: U32.max), add: Doublet(low: U32.max, high: U32.max), shr: 2 * 32 + U32(distance))
            check(U64.lsb << distance, mul: Doublet(low: U64.max, high: U64.max), add: Doublet(low: U64.max, high: U64.max), shr: 2 * 64 + U64(distance))
        }
        
        check(07 as U8,  mul: Doublet(low: 00000000000000000073, high: 00000000000000000146), add: Doublet(low: 00000000000000000073, high: 00000000000000000146), shr: 2 * 08 + 2) // shr:  18
        check(07 as U16, mul: Doublet(low: 00000000000000009362, high: 00000000000000037449), add: Doublet(low: 00000000000000009362, high: 00000000000000037449), shr: 2 * 16 + 2) // shr:  34
        check(07 as U32, mul: Doublet(low: 00000000001227133513, high: 00000000002454267026), add: Doublet(low: 00000000001227133513, high: 00000000002454267026), shr: 2 * 32 + 2) // shr:  66
        check(07 as U64, mul: Doublet(low: 02635249153387078802, high: 10540996613548315209), add: Doublet(low: 02635249153387078802, high: 10540996613548315209), shr: 2 * 64 + 2) // shr: 130
        
        check(10 as U8,  mul: Doublet(low: 00000000000000000205, high: 00000000000000000204), add: Doublet(low: 00000000000000000000, high: 00000000000000000000), shr: 2 * 08 + 3) // shr:  21
        check(10 as U16, mul: Doublet(low: 00000000000000052429, high: 00000000000000052428), add: Doublet(low: 00000000000000000000, high: 00000000000000000000), shr: 2 * 16 + 3) // shr:  35
        check(10 as U32, mul: Doublet(low: 00000000003435973837, high: 00000000003435973836), add: Doublet(low: 00000000000000000000, high: 00000000000000000000), shr: 2 * 32 + 3) // shr:  67
        check(10 as U64, mul: Doublet(low: 14757395258967641293, high: 14757395258967641292), add: Doublet(low: 00000000000000000000, high: 00000000000000000000), shr: 2 * 64 + 3) // shr: 131
    }
    
    func testInitForEachByteEntropyExtension() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            for divisor in (I8.min...I8.max).lazy.map(T.init(load:)) {
                if !divisor.isZero {
                    Test().same(Divider(divisor           ) .divisor, divisor)
                    Test().same(Divider(unchecked: divisor) .divisor, divisor)
                    Test().same(Divider(exactly:   divisor)!.divisor, divisor)
                    Test().success(try Divider(divisor, prune: Bad.any).divisor, divisor)
                }   else {
                    Test().none(Divider(exactly: divisor))
                    Test().failure(try Divider(divisor, prune: Bad.any).divisor, Bad.any)
                }
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    func testInitForEachByteEntropyExtension21() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            for divisor in (I8.min...I8.max).lazy.map(T.init(load:)) {
                if !divisor.isZero {
                    Test().same(Divider21(divisor           ) .divisor, divisor)
                    Test().same(Divider21(unchecked: divisor) .divisor, divisor)
                    Test().same(Divider21(exactly:   divisor)!.divisor, divisor)
                    Test().success(try Divider21(divisor, prune: Bad.any).divisor, divisor)
                }   else {
                    Test().none(Divider21(exactly: divisor))
                    Test().failure(try Divider21(divisor, prune: Bad.any).divisor, Bad.any)
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
                    let expectation = dividend.division(Nonzero(divider.divisor)).unwrap()
                    success &+= IX(Bit(divider.division(dividing: dividend) == expectation))
                    success &+= IX(Bit(divider.quotient(dividing: dividend) == expectation.quotient))
                }
            }
        }
        
        Test().same(success, 2 &* 256 &* 255)
    }
    
    func testDivisionByFuzzingValues() {
        func whereIs<T>(_ type: T.Type, rounds: IX, randomness: consuming FuzzerInt) where T: SystemsInteger & UnsignedInteger {
            for _ in 0 ..< rounds {
                let divider = Divider(T.random(in: 1...T.max, using: &randomness))
                let dividend: T = T.random(using: &randomness)
                let expectation = dividend.division(Nonzero(divider.divisor)).unwrap()
                Test().same(dividend.division(divider),             expectation)
                Test().same(divider .division(dividing:  dividend), expectation)
                Test().same(dividend.quotient(divider),             expectation.quotient)
                Test().same(divider .quotient(dividing:  dividend), expectation.quotient)
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
    
    func testDivisionByFuzzingValues21() {
        func whereIs<T>(_ type: T.Type, rounds: IX, randomness: consuming FuzzerInt) where T: SystemsInteger & UnsignedInteger {
            for _ in 0 ..< rounds {
                let divider = Divider21(T.random(in: 1...T.max, using: &randomness))
                let low:  T = T.random(using: &randomness)
                let high: T = T.random(using: &randomness)
                let dividend = Doublet(low: low, high: high)
                let expectation = T.division(dividend, by: Nonzero(divider.divisor))
                Test().same(divider .division(dividing: dividend), expectation)
                Test().same(divider .quotient(dividing: dividend), expectation.map(\.quotient))
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
                let expectation = dividend.division(Nonzero(divider.divisor)) as Division
                Test().same(dividend.division(divider),             expectation)
                Test().same(divider .division(dividing:  dividend), expectation)
                Test().same(dividend.quotient(divider),             expectation.quotient)
                Test().same(divider .quotient(dividing:  dividend), expectation.quotient)
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
    
    func testDivisionByFuzzingEntropies21() {
        func whereIs<T>(_ type: T.Type, rounds: IX, randomness: consuming FuzzerInt) where T: SystemsInteger & UnsignedInteger {
            func random() -> T {
                let index = IX.random(in: 0 ..< IX(size: T.self), using: &randomness)!
                let pattern = T.Signitude.random(through: Shift(Count(index)), using: &randomness)
                return T(raw: pattern)
            }
            
            for _ in 0 ..< rounds {
                guard let divider = Divider21(exactly: random()) else { continue }
                let low:  T = random()
                let high: T = random()
                let dividend = Doublet(low: low, high: high)
                let expectation = T.division(dividend, by: Nonzero(divider.divisor))
                Test().same(divider.division(dividing: dividend), expectation)
                Test().same(divider.quotient(dividing: dividend), expectation.map(\.quotient))
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
                let divider = Divider(T.lsb.up(random()))
                let dividend: T = T(raw: T.Signitude.random(through: random(), using: &randomness))
                let expectation = dividend.division(Nonzero(divider.divisor)).unwrap()
                Test().same(divider.division(dividing: dividend), expectation)
                Test().same(divider.quotient(dividing: dividend), expectation.quotient)
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
    
    func testDivisionByFuzzingPowerOf2Divisors21() {
        func whereIs<T>(_ type: T.Type, rounds: IX, randomness: consuming FuzzerInt) where T: SystemsInteger & UnsignedInteger {
            func random() -> Shift<T.Magnitude> {
                Shift(Count(IX.random(in: 0 ..< IX(size: T.self), using: &randomness)!))
            }
            
            for _ in 0 ..< rounds {
                let divider  = Divider21(T.lsb.up(random()))
                let low:  T  = T(raw: T.Signitude.random(through: random(), using: &randomness))
                let high: T  = T(raw: T.Signitude.random(through: random(), using: &randomness))
                let dividend = Doublet(low: low, high: high)
                let expectation = T.division(dividend, by: Nonzero(divider.divisor))
                Test().same(divider.division(dividing: dividend), expectation)
                Test().same(divider.quotient(dividing: dividend), expectation.map(\.quotient))
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
        let divisor = Nonzero(U8.random(in: 1...255))
        let divider = Divider(divisor.value)
        let typical = random.division(divisor) as Division<U8, U8> // div
        let magical = random.division(divider) as Division<U8, U8> // mul-add-shr
        precondition(typical == magical) // quotient and remainder
    }
}
