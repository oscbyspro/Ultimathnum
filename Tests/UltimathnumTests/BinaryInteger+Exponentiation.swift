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
        
        func whereIs<A, B>(_ type: A.Type, _ exponent: B.Type) where A: BinaryInteger, B: UnsignedInteger {
            if  let exponent = B.exactly(2239).optional() {
                Test().same(A(3).power(exponent), A.exactly(expectation))
            }
        }
        
        #if DEBUG
        whereIs(          IX .self,           UX .self)
        whereIs(          UX .self,           UX .self)
        whereIs(DoubleInt<IX>.self, DoubleInt<UX>.self)
        whereIs(DoubleInt<UX>.self, DoubleInt<UX>.self)
        whereIs(InfiniInt<IX>.self, InfiniInt<UX>.self)
        whereIs(InfiniInt<UX>.self, InfiniInt<UX>.self)
        #else
        for type in binaryIntegers {
            for exponent in binaryIntegersWhereIsUnsigned {
                whereIs(type, exponent)
            }
        }
        #endif
    }
    
    func testCoefficientIsOneByDefault() {
        Test().same(I8(2).power(UX(3)),                     Fallible(8))
        Test().same(U8(2).power(UX(3)),                     Fallible(8))
        Test().same(Fallible(I8(2)).power(UX(3)),           Fallible(8))
        Test().same(Fallible(U8(2)).power(UX(3)),           Fallible(8))
        Test().same(I8(2).power(Fallible(UX(3))),           Fallible(8))
        Test().same(U8(2).power(Fallible(UX(3))),           Fallible(8))
        Test().same(Fallible(I8(2)).power(Fallible(UX(3))), Fallible(8))
        Test().same(Fallible(U8(2)).power(Fallible(UX(3))), Fallible(8))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Random
    //=------------------------------------------------------------------------=
    
    func testRaiseRandomByKnownExponent() {
        func whereIs<T>(_ type: T.Type, size: IX, rounds: IX, randomness: consuming FuzzerInt) where T: BinaryInteger {
            func random() -> T {
                let index = IX.random(in: 00000 ..< size, using: &randomness)!
                let pattern = T.Signitude.random(through: Shift(Count(index)), using: &randomness)
                return T(raw: pattern) // do not forget about infinite values!
            }
            
            for _  in 0 ..< rounds {
                let base  = random()
                let coefficient = random()
                var power = Fallible(coefficient)

                for exponent: T.Magnitude in 0 ..< 8 {
                    Test().same(base.power(exponent, coefficient: coefficient), power)
                    power = power.times(base)
                }
            }
        }
        
        for type in binaryIntegers {
            #if DEBUG
            whereIs(type, size: IX(size: type) ?? 0032, rounds: 04, randomness: fuzzer)
            #else
            whereIs(type, size: IX(size: type) ?? 0256, rounds: 16, randomness: fuzzer)
            #endif
        }
    }
    
    func testRaiseByFuzzing() {
        func whereIs<T>(_ type: T.Type, size: IX, rounds: IX, randomness: consuming FuzzerInt) where T: BinaryInteger {
            let limit = T.isArbitrary ? 255 : T.Magnitude.max
            
            func random() -> T {
                let index = IX.random(in: 00000 ..< size, using: &randomness)!
                let pattern = T.Signitude.random(through: Shift(Count(index)), using: &randomness)
                return T(raw: pattern) // do not forget about infinite values!
            }
                        
            for _  in 0 ..< rounds {
                let coefficient: T = random()
                let exponent = T.Magnitude.random(in: 0...limit, using: &randomness)
                let result = T(3).times(5).power(exponent, coefficient: coefficient)
                                
                if  coefficient.isZero {
                    Test().same(result, Fallible(T.zero))
                }   else {
                    Test().same(result, T(3).power(exponent).times(T(5).power(exponent)).times(coefficient))
                }
            }
        }
        
        for type in binaryIntegers {
            #if DEBUG
            whereIs(type, size: IX(size: type) ?? 255, rounds: 04, randomness: fuzzer)
            #else
            whereIs(type, size: IX(size: type) ?? 255, rounds: 16, randomness: fuzzer)
            #endif
        }
    }
    
    /// - Note: Exponents beyond `T.Magnitude.max` repeat or return zero.
    func testExponentsThatDontFitInMagnitudeAsSystemsInteger() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            let exponent = UXL.lsb << IX(size: type)
            for coefficient: T in (I8(-2)...I8(2)).lazy.map(T.init(load:)) {
                Test().same((~8 as T).power(exponent, coefficient: coefficient), Fallible(coefficient, error: !coefficient.isZero))
                Test().same((~7 as T).power(exponent, coefficient: coefficient), Fallible(00000000000, error: !coefficient.isZero))
                Test().same((~6 as T).power(exponent, coefficient: coefficient), Fallible(coefficient, error: !coefficient.isZero))
                Test().same((~5 as T).power(exponent, coefficient: coefficient), Fallible(00000000000, error: !coefficient.isZero))
                Test().same((~4 as T).power(exponent, coefficient: coefficient), Fallible(coefficient, error: !coefficient.isZero))
                Test().same((~3 as T).power(exponent, coefficient: coefficient), Fallible(00000000000, error: !coefficient.isZero))
                Test().same((~2 as T).power(exponent, coefficient: coefficient), Fallible(coefficient, error: !coefficient.isZero))
                Test().same((~1 as T).power(exponent, coefficient: coefficient), Fallible(00000000000, error: !coefficient.isZero))
                Test().same((~0 as T).power(exponent, coefficient: coefficient), Fallible(coefficient, error: !coefficient.isZero && !T.isSigned))
                Test().same(( 0 as T).power(exponent, coefficient: coefficient), Fallible(00000000000))
                Test().same(( 1 as T).power(exponent, coefficient: coefficient), Fallible(coefficient))
                Test().same(( 2 as T).power(exponent, coefficient: coefficient), Fallible(00000000000, error: !coefficient.isZero))
                Test().same(( 3 as T).power(exponent, coefficient: coefficient), Fallible(coefficient, error: !coefficient.isZero))
                Test().same(( 4 as T).power(exponent, coefficient: coefficient), Fallible(00000000000, error: !coefficient.isZero))
                Test().same(( 5 as T).power(exponent, coefficient: coefficient), Fallible(coefficient, error: !coefficient.isZero))
                Test().same(( 6 as T).power(exponent, coefficient: coefficient), Fallible(00000000000, error: !coefficient.isZero))
                Test().same(( 7 as T).power(exponent, coefficient: coefficient), Fallible(coefficient, error: !coefficient.isZero))
                Test().same(( 8 as T).power(exponent, coefficient: coefficient), Fallible(00000000000, error: !coefficient.isZero))
            }
        }
        
        for type in systemsIntegers {
            whereIs(type)
        }
    }
    
    func testExponentsThatDontFitInMagnitudeAsSystemsIntegerByFuzzing() {
        func whereIs<A, B>(small: A.Type, large: B.Type, rounds: IX, randomness: consuming FuzzerInt) where A: SystemsInteger, B: SystemsInteger {
            guard A.size <= B.size, A.isSigned == B.isSigned else { return }
            
            for _ in 0 ..< rounds {
                let base = A.random(using: &randomness)
                let exponent = B.Magnitude.random(in: B.Magnitude(A.Magnitude.max)...B.Magnitude.max)
                let coefficient = A.random(using: &randomness)
                let small = A(base).power(exponent, coefficient: A(coefficient))
                let large = B(base).power(exponent, coefficient: B(coefficient))
                Test().same(small, A.exactly(large))
            }
        }
        
        for small in systemsIntegers {
            for large in systemsIntegers {
                #if DEBUG
                whereIs(small: small, large: large, rounds: 4, randomness: fuzzer)
                #else
                whereIs(small: small, large: large, rounds: 8, randomness: fuzzer)
                #endif
            }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Edge Cases
//=----------------------------------------------------------------------------=

extension BinaryIntegerTestsOnExponentiation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBasesNearZero() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for exponent: I8 in -2...2 {
                let exponent = T.Magnitude(load: exponent)
                for coefficient: I8 in -2...2 {
                    let coefficient = T(load: coefficient)
                    
                    Test().same(
                        T(Bit.one).power(exponent, coefficient: coefficient),
                        Fallible(coefficient)
                    )
                    
                    Test().same(
                        T(repeating: Bit.zero).power(exponent, coefficient: coefficient),
                        Fallible(exponent.isZero ? coefficient : T.zero)
                    )

                    Test().same(
                        T(repeating: Bit.one ).power(exponent, coefficient: coefficient),
                        coefficient.times(Bool(exponent.lsb) ? ~0 : 1).veto(
                            !T.isSigned && exponent >= 2 && !coefficient.isZero
                        )
                    )
                }
            }
        }
        
        #if DEBUG
        whereIs(UX.self)
        whereIs(DoubleInt<UX>.self)
        whereIs(InfiniInt<UX>.self)
        #else
        for type in binaryIntegers {
            whereIs(type)
        }
        #endif
    }
    
    func testZeroCoefficientsReturnZeroNoError() {
        func whereIs<A, B>(_ type: A.Type, _ exponent: B.Type) where A: BinaryInteger, B: UnsignedInteger {
            Test().same(Esque<A>.min.power(B.max, coefficient: A.zero), Fallible(A.zero))
            Test().same(Esque<A>.max.power(B.max, coefficient: A.zero), Fallible(A.zero))
        }
        
        for type in binaryIntegers {
            for exponent in binaryIntegersWhereIsUnsigned {
                whereIs(type, exponent)
            }
        }
    }
    
    func testZeroExponentsReturnCoefficientNoError() {
        func whereIs<A, B>(_ type: A.Type, _ exponent: B.Type) where A: BinaryInteger, B: UnsignedInteger {
            for coefficient: I8 in -2...2 {
                let coefficient = A(load: coefficient)
                Test().same(Esque<A>.min.power(B.min, coefficient: coefficient), Fallible(coefficient))
                Test().same(Esque<A>.max.power(B.min, coefficient: coefficient), Fallible(coefficient))
            }
        }
        
        for type in binaryIntegers {
            for exponent in binaryIntegersWhereIsUnsigned {
                whereIs(type, exponent)
            }
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
            let max = T.isArbitrary ? 16 : T.Magnitude.max
            
            for _ in 0 ..< rounds {
                let base: T  = random()
                let exponent = T.Magnitude.random(in: 0...max, using: &randomness)
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
            
            for _ in 0 ..< rounds {
                let base: T  = random()
                let exponent = T.Magnitude.random(in: 0...max, using: &randomness)
                let coefficient: T = random()
                let expectation: Fallible<T> = base.power(exponent,             coefficient: coefficient)
                success &+= IX(Bit(base            .power(exponent,             coefficient: coefficient) == expectation))
                success &+= IX(Bit(base            .power(exponent.veto(false), coefficient: coefficient) == expectation))
                success &+= IX(Bit(base            .power(exponent.veto(true ), coefficient: coefficient) == expectation.veto()))
                success &+= IX(Bit(base.veto(false).power(exponent,             coefficient: coefficient) == expectation))
                success &+= IX(Bit(base.veto(false).power(exponent.veto(false), coefficient: coefficient) == expectation))
                success &+= IX(Bit(base.veto(false).power(exponent.veto(true ), coefficient: coefficient) == expectation.veto()))
                success &+= IX(Bit(base.veto(true ).power(exponent,             coefficient: coefficient) == expectation.veto()))
                success &+= IX(Bit(base.veto(true ).power(exponent.veto(false), coefficient: coefficient) == expectation.veto()))
                success &+= IX(Bit(base.veto(true ).power(exponent.veto(true ), coefficient: coefficient) == expectation.veto()))
            }
            
            Test().same(success, rounds &* 18)
        }
        
        // note that existentials are too slow for this
        whereIs(          I8 .self, size:  8, rounds: 8, randomness: fuzzer)
        whereIs(          U8 .self, size:  8, rounds: 8, randomness: fuzzer)
        whereIs(DoubleInt<I8>.self, size: 16, rounds: 8, randomness: fuzzer)
        whereIs(DoubleInt<I8>.self, size: 16, rounds: 8, randomness: fuzzer)
        whereIs(InfiniInt<I8>.self, size: 16, rounds: 8, randomness: fuzzer)
        whereIs(InfiniInt<I8>.self, size: 16, rounds: 8, randomness: fuzzer)
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
        func whereIs<A, B>(_ type: A.Type, _ exponent: B.Type) where A: BinaryInteger, B: UnsignedInteger {
            Test().same(A(0).power(B(1), coefficient: A(2)), A.exactly(   0))
            Test().same(A(1).power(B(2), coefficient: A(3)), A.exactly(   3))
            Test().same(A(2).power(B(3), coefficient: A(5)), A.exactly(  40))
            Test().same(A(3).power(B(5), coefficient: A(7)), A.exactly(1701))
        }
        
        for type in binaryIntegers {
            for exponent in binaryIntegersWhereIsUnsigned {
                whereIs(type, exponent)
            }
        }
    }
}
