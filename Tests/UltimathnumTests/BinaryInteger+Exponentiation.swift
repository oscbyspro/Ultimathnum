//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import InfiniIntKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Exponentiation
//*============================================================================*

final class BinaryIntegerTestsOnExponentiation: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testRaiseTrivialCases() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            let small: ClosedRange<T> = 0 ... 11
            let large: ClosedRange<T> = Esque<T>.bot.minus(3).unwrap() ... Esque<T>.bot
            
            for exponent: T in [small, large].joined() {
                Test().same(( 0 as T).power(Natural(exponent)), Fallible(exponent.isZero ? 00001 : 0))
                Test().same(( 1 as T).power(Natural(exponent)), Fallible(1))
                Test().same((~0 as T).power(Natural(exponent)), Fallible(Bool(exponent.lsb) ? ~0 : 1, error: !T.isSigned && exponent >= 2))
            }
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    /// https://www.wolframalpha.com/input?i2d=true&i=Power%5B3%2C2239%5D
    func testRaiseThreeToPrime333() {
        let expectation = UXL("""
        0000000000000000000188143542653317364740047262022158266784428791\
        9275755434856235633416147929751345775198585370887106410700145660\
        6941136649945052148587729379215298759841906211465894489332805610\
        3754563980603820020778896725273833377637201111950279005112886290\
        8217517791462710719585984177457155945873475389047023763181890095\
        9473781620831209436384360444149350498181207507201081140457731667\
        8330429216786541702964381293439187677376199748692174845775469107\
        1970497833817135114559784314771606933781164789651479259636951051\
        1939631603190331045111418380453489110302905083967247056298476321\
        3031701771676257422898074561340984020468039563665625492587401150\
        2217805773793168451721091497379753074682133867791141932470210853\
        5500447924439317916852983725285062418604919143133304424502097997\
        8608095945569404820035699584592750436592636252055799816797294408\
        0379347764424614210540528598264992483071934555760511919452459358\
        8835641810301075822245153655314705395817134933252061409024669198\
        8059476349693766699090206318226803178343171280950787682695695659\
        6036250169540192297202679456092601217013126286587177412655204267
        """)!
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            if  let exponent = T.exactly(2239).optional()  {
                Test().same(T(3).power(Natural(exponent)), T.exactly(expectation))
            }
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Random
    //=------------------------------------------------------------------------=
    
    func testRaiseConvenienceForNaturalTypes() {
        func whereIs<T>(_ type: T.Type, randomness: consuming FuzzerInt) where T: SystemsInteger & UnsignedInteger {
            for _  in 0 ..< 4 {
                let a = T.random()
                let b = T.random()
                Test().same(a.power(b), a.power(Natural(b)))
            }
        }
        
        for type in systemsIntegersWhereIsUnsigned {
            whereIs(type, randomness: fuzzer)
        }
    }
    
    func testRaiseRandomByKnownExponent() {
        func whereIs<T>(_ type: T.Type, size: IX, rounds: IX, randomness: consuming FuzzerInt) where T: BinaryInteger {
            func random() -> T {
                let index = IX.random(in: 00000 ..< size, using: &randomness)!
                let pattern = T.Signitude.random(through: Shift(Count(index)), using: &randomness)
                return T(raw: pattern) // do not forget about infinite values!
            }
            
            for _  in 0 ..< rounds {
                let base  = random()
                var power = Fallible(1 as T)
                
                for exponent: T in 0 ..< 8 {
                    Test().same(base.power(Natural(exponent)), power)
                    power = power.times(base)
                }
            }

        }
        
        for type in binaryIntegers {
            #if DEBUG
            whereIs(type, size: IX(size: type) ?? 0032, rounds: 01, randomness: fuzzer)
            #else
            whereIs(type, size: IX(size: type) ?? 0256, rounds: 16, randomness: fuzzer)
            #endif
        }
    }
    
    func testRaiseByFuzzing() {
        func whereIs<T>(_ type: T.Type, rounds: IX, randomness: consuming FuzzerInt) where T: BinaryInteger {
            let max: T = switch true {
            case T.isArbitrary: 255
            case T.isSigned: T.lsb.up(Shift.max).toggled()
            default: T.zero.toggled()
            }
            
            for _  in 0 ..< rounds {
                let x = Natural(T.random(in: T.zero ... max, using: &randomness))
                let a = T(3).times(T(5)).power(x)
                let b = T(3).power(x).times(T(05).power(x))
                Test().same(a, b)
            }
        }
        
        for type in binaryIntegers {
            #if DEBUG
            whereIs(type, rounds: 02, randomness: fuzzer)
            #else
            whereIs(type, rounds: 16, randomness: fuzzer)
            #endif
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

extension BinaryIntegerTestsOnExponentiation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testErrorPropagationMechanism() {
        func whereIs<T>(_ type: T.Type, size: IX, rounds: IX, randomness: consuming FuzzerInt) where T: BinaryInteger {
            func random() -> T {
                let index = IX.random(in: 00000 ..< size, using: &randomness)!
                let pattern = T.Signitude.random(through: Shift(Count(index)), using: &randomness)
                return T(raw: pattern) // do not forget about infinite values!
            }
            
            var success: IX = 0
            let max: T = T.isArbitrary ? 16 : Esque<T>.max
            
            for _ in 0 ..< rounds {
                let base: T  = random()
                let exponent = Natural(T.random(in: 0...max))
                let expectation: Fallible<T> = base.power(exponent)
                success &+= IX(Bit(base            .power(exponent) == expectation))
                success &+= IX(Bit(base.veto(false).power(exponent) == expectation))
                success &+= IX(Bit(base.veto(true ).power(exponent) == expectation.veto()))
            }
            
            Test().same(success, rounds &* 3)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type, rounds: IX, randomness: consuming FuzzerInt) where T: SystemsInteger & UnsignedInteger {
            var success: IX = 0
            
            for _ in 0 ..< rounds {
                let base: T  = T.random()
                let exponent = T.random()
                let expectation: Fallible<T> = base.power(exponent)
                success &+= IX(Bit(base            .power(exponent)             == expectation))
                success &+= IX(Bit(base            .power(exponent.veto(false)) == expectation))
                success &+= IX(Bit(base            .power(exponent.veto(true )) == expectation.veto()))
                success &+= IX(Bit(base.veto(false).power(exponent)             == expectation))
                success &+= IX(Bit(base.veto(false).power(exponent.veto(false)) == expectation))
                success &+= IX(Bit(base.veto(false).power(exponent.veto(true )) == expectation.veto()))
                success &+= IX(Bit(base.veto(true ).power(exponent)             == expectation.veto()))
                success &+= IX(Bit(base.veto(true ).power(exponent.veto(false)) == expectation.veto()))
                success &+= IX(Bit(base.veto(true ).power(exponent.veto(true )) == expectation.veto()))
            }
            
            Test().same(success, rounds &* 9)
        }
        
        for type in binaryIntegers {
            whereIs(type, size: IX(size: type) ?? 32, rounds: 4, randomness: fuzzer)
        }
        
        for type in systemsIntegersWhereIsUnsigned {
            whereIs(type, size: IX(size: type), rounds: 4, randomness: fuzzer)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Documentation
//=----------------------------------------------------------------------------=

extension BinaryIntegerTestsOnExponentiation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBinaryIntegerDocumentation() {
        Test().same(U8(1).power(Natural(2)), Fallible(001))
        Test().same(U8(2).power(Natural(3)), Fallible(008))
        Test().same(U8(3).power(Natural(5)), Fallible(243))
        Test().same(U8(5).power(Natural(7)), Fallible(045, error: true))
        Test().same(U8.exactly((000078125)), Fallible(045, error: true))
    }
}
