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
// MARK: * Binary Integer x Division
//*============================================================================*

final class BinaryIntegerTestsOnDivision: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivisionOfMinMaxEsque() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            //=----------------------------------=
            let size = IX(raw: T.size)
            let msb: T = Esque<T>.msb
            let bot: T = Esque<T>.bot
            //=----------------------------------=
            if  T.isSigned {
                Test().division(msb, msb >> 1,  2 as T, 0 as T)
                Test().division(bot, msb >> 1, -1 as T, (msb >> 1 + 1).complement())
            }   else {
                Test().division(msb, msb >> 1,  2 as T, 0 as T)
                Test().division(bot, msb >> 1,  1 as T, (msb >> 1 - 1))
            }
            
            if  T.isSigned {
                Test().division(bot, ~3 as T, (msb >> 2) + 1, 3 as T)
                Test().division(bot, ~1 as T, (msb >> 1) + 1, 1 as T)
                Test().division(bot, ~0 as T, (msb >> 0) + 1, 0 as T)
                Test().division(bot,  0 as T, (nil))
                Test().division(bot,  1 as T, (bot),          0 as T)
                Test().division(bot,  2 as T, (bot >> 1),     1 as T)
                Test().division(bot,  4 as T, (bot >> 2),     3 as T)
                
                Test().division(msb, ~3 as T, (msb >> 2).complement(), 0 as T)
                Test().division(msb, ~1 as T, (msb >> 1).complement(), 0 as T)
                Test().division(msb, ~0 as T, (msb >> 0).complement(), 0 as T, msb.ascending(0) == Count(raw: size - 1))
                Test().division(msb,  0 as T, (nil))
                Test().division(msb,  1 as T, (msb),          0 as T)
                Test().division(msb,  2 as T, (msb >> 1),     0 as T)
                Test().division(msb,  4 as T, (msb >> 2),     0 as T)
            }   else {
                Test().division(bot, ~3 as T, (000 as T),     bot)
                Test().division(bot, ~1 as T, (000 as T),     bot)
                Test().division(bot, ~0 as T, (000 as T),     bot)
                Test().division(bot,  0 as T, (nil))
                Test().division(bot,  1 as T, (bot),          0 as T)
                Test().division(bot,  2 as T, (bot >> 1),     1 as T)
                
                Test().division(msb, ~1 as T, (000 as T),     msb)
                Test().division(msb, ~0 as T, (000 as T),     msb)
                Test().division(msb,  0 as T, (nil))
                Test().division(msb,  1 as T, (msb),          0 as T)
                Test().division(msb,  2 as T, (msb >> 1),     0 as T)
                Test().division(msb,  4 as T, (msb >> 2),     0 as T)
            }
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testDivisionOfSmallBySmall() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            //=----------------------------------=
            let x0 = 0 as T
            let x7 = 7 as T
            //=----------------------------------=
            for divisor: T in [4, 3, 2, 1, ~0, ~1, ~2, ~3, ~4] as [T] {
                Test().division( x0, divisor, x0, x0)
            }
            
            if  T.isSigned {
                Test().division( x7,  3 as T,  2 as T,  1 as T)
                Test().division( x7, -3 as T, -2 as T,  1 as T)
                Test().division(-x7,  3 as T, -2 as T, -1 as T)
                Test().division(-x7, -3 as T,  2 as T, -1 as T)
            }   else {
                Test().division( x7,  1 as T,  7 as T,  0 as T)
                Test().division( x7,  2 as T,  3 as T,  1 as T)
                Test().division( x7,  3 as T,  2 as T,  1 as T)
                Test().division( x7,  4 as T,  1 as T,  3 as T)
            }
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testDivisionByZero() {
        func whereIsBinaryInteger<T>(_ type: T.Type) where T: BinaryInteger {
            var values: [T] = [4, 3, 2, 1, 0, ~0, ~1, ~2, ~3, ~4]
            values.append(T.exactly(0x0000000000000000000000000000007F).value)
            values.append(T.exactly(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0).value)
            
            for value in values {
                Test().division(value, T.zero, nil)
            }
        }
        
        func whereIsSystemsInteger<T>(_ type: T.Type) where T: SystemsInteger {
            let values: [T] = [4, 3, 2, 1, 0, ~0, ~1, ~2, ~3, ~4]

            for high: T in values {
                for low: T.Magnitude in values.lazy.map(T.Magnitude.init(raw:)) {
                    Test().division(Doublet(low: low, high: high), T.zero, nil)
                }
            }
        }
        
        for type in binaryIntegers {
            whereIsBinaryInteger(type)
        }
        
        for type in systemsIntegers {
            whereIsSystemsInteger(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Signed
    //=------------------------------------------------------------------------=
    
    func testDivisionNearMinByZeroAsSigned() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger & SignedInteger {
            Test().division(T.min,      2 as T, -(T.max / 2 + 1),  0 as T)
            Test().division(T.min + 1,  2 as T, -(T.max / 2    ), -1 as T)
            Test().division(T.min + 2,  2 as T, -(T.max / 2    ),  0 as T)
            Test().division(T.min + 3,  2 as T, -(T.max / 2 - 1), -1 as T)
            
            Test().division(T.min,      1 as T,  (T.min        ),  0 as T)
            Test().division(T.min + 1,  1 as T,  (T.min     + 1),  0 as T)
            Test().division(T.min + 2,  1 as T,  (T.min     + 2),  0 as T)
            Test().division(T.min + 3,  1 as T,  (T.min     + 3),  0 as T)
            
            Test().division(T.min,      0 as T,  nil)
            Test().division(T.min + 1,  0 as T,  nil)
            Test().division(T.min + 2,  0 as T,  nil)
            Test().division(T.min + 3,  0 as T,  nil)

            Test().division(T.min,     -1 as T,  (T.min        ),  0 as T, true)
            Test().division(T.min + 1, -1 as T,  (T.max        ),  0 as T)
            Test().division(T.min + 2, -1 as T,  (T.max     - 1),  0 as T)
            Test().division(T.min + 3, -1 as T,  (T.max     - 2),  0 as T)

            Test().division(T.min,     -2 as T,  (T.max / 2 + 1),  0 as T)
            Test().division(T.min + 1, -2 as T,  (T.max / 2    ), -1 as T)
            Test().division(T.min + 2, -2 as T,  (T.max / 2    ),  0 as T)
            Test().division(T.min + 3, -2 as T,  (T.max / 2 - 1), -1 as T)
        }
        
        for type in systemsIntegersWhereIsSigned {
            whereIsSigned(type)
        }
    }
    
    func testDivisionNearMaxByZeroAsSigned() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger & SignedInteger {
            Test().division(T.max,      2 as T,  (T.max / 2    ),  1 as T)
            Test().division(T.max - 1,  2 as T,  (T.max / 2    ),  0 as T)
            Test().division(T.max - 2,  2 as T,  (T.max / 2 - 1),  1 as T)
            Test().division(T.max - 3,  2 as T,  (T.max / 2 - 1),  0 as T)
            
            Test().division(T.max,      1 as T,  (T.max        ),  0 as T)
            Test().division(T.max - 1,  1 as T,  (T.max     - 1),  0 as T)
            Test().division(T.max - 2,  1 as T,  (T.max     - 2),  0 as T)
            Test().division(T.max - 3,  1 as T,  (T.max     - 3),  0 as T)
            
            Test().division(T.max,      0 as T,  nil)
            Test().division(T.max - 1,  0 as T,  nil)
            Test().division(T.max - 2,  0 as T,  nil)
            Test().division(T.max - 3,  0 as T,  nil)
            
            Test().division(T.max,     -1 as T, -(T.max        ),  0 as T)
            Test().division(T.max - 1, -1 as T, -(T.max     - 1),  0 as T)
            Test().division(T.max - 2, -1 as T, -(T.max     - 2),  0 as T)
            Test().division(T.max - 3, -1 as T, -(T.max     - 3),  0 as T)
            
            Test().division(T.max,     -2 as T, -(T.max / 2    ),  1 as T)
            Test().division(T.max - 1, -2 as T, -(T.max / 2    ),  0 as T)
            Test().division(T.max - 2, -2 as T, -(T.max / 2 - 1),  1 as T)
            Test().division(T.max - 3, -2 as T, -(T.max / 2 - 1),  0 as T)

        }
        
        for type in systemsIntegersWhereIsSigned {
            whereIsSigned(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 2 by 1
    //=------------------------------------------------------------------------=
    
    func testDivision2111CaseCount() throws {
        func whereIs<T>(_ type: T.Type, success: U32) where T: SystemsInteger  {
            var counter = U32.zero
            
            for divisor:  T in (T.min...T.max) where !divisor.isZero {
                for high: T in (T.min...T.max) {
                    for low: T.Magnitude in (T.Magnitude.min...T.Magnitude.max) {
                        counter += U32(Bit(!T.division(Doublet(low: low, high: high), by: Divisor(divisor)).error))
                    }
                }
            }
            
            Test().same(counter, success)
        }
        
        #if DEBUG
        throw XCTSkip("req. release mode")
        #else
        whereIs(I8.self, success: 4210433)
        whereIs(U8.self, success: 8355840)
        #endif
    }
    
    func testDivision2111As08Is1111As16() throws {
        func whereIs<A, B>(x08: A.Type, x16: B.Type) where A: SystemsInteger, B: SystemsInteger {
            precondition(A.size == Count(08))
            precondition(B.size == Count(16))
            precondition(A.isSigned == B.isSigned)
            
            var success = U32.zero
            
            for divisor:  A in (A.min...A.max) where !divisor.isZero {
                for high: A in (A.min...A.max) {
                    for low: A.Magnitude in (A.Magnitude.min...A.Magnitude.max) {
                        let result = A.division(Doublet(low: low, high: high), by: Divisor(divisor))
                        let expectation = (B(low) | B(high).up(A.size)).division(Divisor(B(divisor)))
                        guard result.map(\.quotient) == expectation.map(\.quotient).map(A.exactly) else { break }
                        guard result.value.remainder == A.exactly(expectation.value.remainder).optional() else { break }
                        success += 1
                    }
                }
            }
            
            Test().same(success, 255 * 256 * 256)
        }
        
        #if DEBUG
        throw XCTSkip("req. release mode")
        #else
        whereIs(x08: I8.self, x16: I16.self)
        whereIs(x08: I8.self, x16: DoubleInt<I8>.self)
        whereIs(x08: U8.self, x16: U16.self)
        whereIs(x08: U8.self, x16: DoubleInt<U8>.self)
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 2 by 1 as Signed
    //=------------------------------------------------------------------------=
    
    func testDivision2111NearMinByZeroAsSigned() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger & SignedInteger {
            typealias M = T.Magnitude
            typealias D = Doublet<T>
            
            Test().division(D(low: M.msb + 3, high: -1 as T),  2 as T,  T.min / 2 + 2, -1 as T)
            Test().division(D(low: M.msb + 2, high: -1 as T),  2 as T,  T.min / 2 + 1,  0 as T)
            Test().division(D(low: M.msb + 1, high: -1 as T),  2 as T,  T.min / 2 + 1, -1 as T)
            Test().division(D(low: M.msb + 0, high: -1 as T),  2 as T,  T.min / 2,      0 as T)
            Test().division(D(low: M.msb - 1, high: -1 as T),  2 as T,  T.min / 2,     -1 as T)
            Test().division(D(low: M.msb - 2, high: -1 as T),  2 as T,  T.min / 2 - 1,  0 as T)
            Test().division(D(low: M.msb - 3, high: -1 as T),  2 as T,  T.min / 2 - 1, -1 as T)
            Test().division(D(low: M.msb - 4, high: -1 as T),  2 as T,  T.min / 2 - 2,  0 as T)
            
            Test().division(D(low: M.msb + 3, high: -1 as T),  1 as T,  T.min     + 3,  0 as T)
            Test().division(D(low: M.msb + 2, high: -1 as T),  1 as T,  T.min     + 2,  0 as T)
            Test().division(D(low: M.msb + 1, high: -1 as T),  1 as T,  T.min     + 1,  0 as T)
            Test().division(D(low: M.msb + 0, high: -1 as T),  1 as T,  T.min,          0 as T)
            Test().division(D(low: M.msb - 1, high: -1 as T),  1 as T,  T.max,          0 as T, true)
            Test().division(D(low: M.msb - 2, high: -1 as T),  1 as T,  T.max     - 1,  0 as T, true)
            Test().division(D(low: M.msb - 3, high: -1 as T),  1 as T,  T.max     - 2,  0 as T, true)
            Test().division(D(low: M.msb - 4, high: -1 as T),  1 as T,  T.max     - 3,  0 as T, true)
            
            Test().division(D(low: M.msb + 3, high: -1 as T),  0 as T,  nil)
            Test().division(D(low: M.msb + 2, high: -1 as T),  0 as T,  nil)
            Test().division(D(low: M.msb + 1, high: -1 as T),  0 as T,  nil)
            Test().division(D(low: M.msb + 0, high: -1 as T),  0 as T,  nil)
            Test().division(D(low: M.msb - 1, high: -1 as T),  0 as T,  nil)
            Test().division(D(low: M.msb - 2, high: -1 as T),  0 as T,  nil)
            Test().division(D(low: M.msb - 3, high: -1 as T),  0 as T,  nil)
            Test().division(D(low: M.msb - 4, high: -1 as T),  0 as T,  nil)
            
            Test().division(D(low: M.msb + 3, high: -1 as T), -1 as T,  T.max     - 2,  0 as T)
            Test().division(D(low: M.msb + 2, high: -1 as T), -1 as T,  T.max     - 1,  0 as T)
            Test().division(D(low: M.msb + 1, high: -1 as T), -1 as T,  T.max,          0 as T)
            Test().division(D(low: M.msb + 0, high: -1 as T), -1 as T,  T.min,          0 as T, true)
            Test().division(D(low: M.msb - 1, high: -1 as T), -1 as T,  T.min     + 1,  0 as T, true)
            Test().division(D(low: M.msb - 2, high: -1 as T), -1 as T,  T.min     + 2,  0 as T, true)
            Test().division(D(low: M.msb - 3, high: -1 as T), -1 as T,  T.min     + 3,  0 as T, true)
            Test().division(D(low: M.msb - 4, high: -1 as T), -1 as T,  T.min     + 4,  0 as T, true)
            
            Test().division(D(low: M.msb + 3, high: -1 as T), -2 as T,  T.max / 2 - 1, -1 as T)
            Test().division(D(low: M.msb + 2, high: -1 as T), -2 as T,  T.max / 2,      0 as T)
            Test().division(D(low: M.msb + 1, high: -1 as T), -2 as T,  T.max / 2,     -1 as T)
            Test().division(D(low: M.msb + 0, high: -1 as T), -2 as T,  T.max / 2 + 1,  0 as T)
            Test().division(D(low: M.msb - 1, high: -1 as T), -2 as T,  T.max / 2 + 1, -1 as T)
            Test().division(D(low: M.msb - 2, high: -1 as T), -2 as T,  T.max / 2 + 2,  0 as T)
            Test().division(D(low: M.msb - 3, high: -1 as T), -2 as T,  T.max / 2 + 2, -1 as T)
            Test().division(D(low: M.msb - 4, high: -1 as T), -2 as T,  T.max / 2 + 3,  0 as T)
        }
                
        for type in systemsIntegersWhereIsSigned {
            whereIsSigned(type)
        }
    }
    
    func testDivision2111NearMinTimesTwoByZeroAsSigned() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger & SignedInteger {
            typealias M = T.Magnitude
            typealias D = Doublet<T>
            
            Test().division(D(low: M.min + 3, high: -1 as T),  2 as T,  T.min + 2, -1 as T)
            Test().division(D(low: M.min + 2, high: -1 as T),  2 as T,  T.min + 1,  0 as T)
            Test().division(D(low: M.min + 1, high: -1 as T),  2 as T,  T.min + 1, -1 as T)
            Test().division(D(low: M.min,     high: -1 as T),  2 as T,  T.min,      0 as T)
            Test().division(D(low: M.max,     high: -2 as T),  2 as T,  T.min,     -1 as T)
            Test().division(D(low: M.max - 1, high: -2 as T),  2 as T,  T.max,      0 as T, true)
            Test().division(D(low: M.max - 2, high: -2 as T),  2 as T,  T.max,     -1 as T, true)
            Test().division(D(low: M.max - 3, high: -2 as T),  2 as T,  T.max - 1,  0 as T, true)
            
            Test().division(D(low: M.min + 3, high: -1 as T),  1 as T,  3 as T,     0 as T, true)
            Test().division(D(low: M.min + 2, high: -1 as T),  1 as T,  2 as T,     0 as T, true)
            Test().division(D(low: M.min + 1, high: -1 as T),  1 as T,  1 as T,     0 as T, true)
            Test().division(D(low: M.min,     high: -1 as T),  1 as T,  0 as T,     0 as T, true)
            Test().division(D(low: M.max,     high: -2 as T),  1 as T, -1 as T,     0 as T, true)
            Test().division(D(low: M.max - 1, high: -2 as T),  1 as T, -2 as T,     0 as T, true)
            Test().division(D(low: M.max - 2, high: -2 as T),  1 as T, -3 as T,     0 as T, true)
            Test().division(D(low: M.max - 3, high: -2 as T),  1 as T, -4 as T,     0 as T, true)
            
            Test().division(D(low: M.min + 3, high: -1 as T),  0 as T,  nil)
            Test().division(D(low: M.min + 2, high: -1 as T),  0 as T,  nil)
            Test().division(D(low: M.min + 1, high: -1 as T),  0 as T,  nil)
            Test().division(D(low: M.min,     high: -1 as T),  0 as T,  nil)
            Test().division(D(low: M.max,     high: -2 as T),  0 as T,  nil)
            Test().division(D(low: M.max - 1, high: -2 as T),  0 as T,  nil)
            Test().division(D(low: M.max - 2, high: -2 as T),  0 as T,  nil)
            Test().division(D(low: M.max - 3, high: -2 as T),  0 as T,  nil)
            
            Test().division(D(low: M.min + 3, high: -1 as T), -1 as T, -3 as T,     0 as T, true)
            Test().division(D(low: M.min + 2, high: -1 as T), -1 as T, -2 as T,     0 as T, true)
            Test().division(D(low: M.min + 1, high: -1 as T), -1 as T, -1 as T,     0 as T, true)
            Test().division(D(low: M.min,     high: -1 as T), -1 as T,  0 as T,     0 as T, true)
            Test().division(D(low: M.max,     high: -2 as T), -1 as T,  1 as T,     0 as T, true)
            Test().division(D(low: M.max - 1, high: -2 as T), -1 as T,  2 as T,     0 as T, true)
            Test().division(D(low: M.max - 2, high: -2 as T), -1 as T,  3 as T,     0 as T, true)
            Test().division(D(low: M.max - 3, high: -2 as T), -1 as T,  4 as T,     0 as T, true)
            
            Test().division(D(low: M.min + 3, high: -1 as T), -2 as T,  T.max - 1, -1 as T)
            Test().division(D(low: M.min + 2, high: -1 as T), -2 as T,  T.max,      0 as T)
            Test().division(D(low: M.min + 1, high: -1 as T), -2 as T,  T.max,     -1 as T)
            Test().division(D(low: M.min,     high: -1 as T), -2 as T,  T.min,      0 as T, true)
            Test().division(D(low: M.max,     high: -2 as T), -2 as T,  T.min,     -1 as T, true)
            Test().division(D(low: M.max - 1, high: -2 as T), -2 as T,  T.min + 1,  0 as T, true)
            Test().division(D(low: M.max - 2, high: -2 as T), -2 as T,  T.min + 1, -1 as T, true)
            Test().division(D(low: M.max - 3, high: -2 as T), -2 as T,  T.min + 2,  0 as T, true)
        }
        
        for type in systemsIntegersWhereIsSigned {
            whereIsSigned(type)
        }
    }
    
    func testDivision2111NearMaxByZeroAsSigned() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger & SignedInteger {
            typealias M = T.Magnitude
            typealias D = Doublet<T>
            
            Test().division(D(low: M.msb - 4, high: 0 as T),  2,  T.max / 2 - 1,  0 as T)
            Test().division(D(low: M.msb - 3, high: 0 as T),  2,  T.max / 2 - 1,  1 as T)
            Test().division(D(low: M.msb - 2, high: 0 as T),  2,  T.max / 2,      0 as T)
            Test().division(D(low: M.msb - 1, high: 0 as T),  2,  T.max / 2,      1 as T)
            Test().division(D(low: M.msb + 0, high: 0 as T),  2,  T.max / 2 + 1,  0 as T)
            Test().division(D(low: M.msb + 1, high: 0 as T),  2,  T.max / 2 + 1,  1 as T)
            Test().division(D(low: M.msb + 2, high: 0 as T),  2,  T.max / 2 + 2,  0 as T)
            Test().division(D(low: M.msb + 3, high: 0 as T),  2,  T.max / 2 + 2,  1 as T)
            
            Test().division(D(low: M.msb - 4, high: 0 as T),  1,  T.max     - 3,  0 as T)
            Test().division(D(low: M.msb - 3, high: 0 as T),  1,  T.max     - 2,  0 as T)
            Test().division(D(low: M.msb - 2, high: 0 as T),  1,  T.max     - 1,  0 as T)
            Test().division(D(low: M.msb - 1, high: 0 as T),  1,  T.max     - 0,  0 as T)
            Test().division(D(low: M.msb + 0, high: 0 as T),  1,  T.min,          0 as T, true)
            Test().division(D(low: M.msb + 1, high: 0 as T),  1,  T.min     + 1,  0 as T, true)
            Test().division(D(low: M.msb + 2, high: 0 as T),  1,  T.min     + 2,  0 as T, true)
            Test().division(D(low: M.msb + 3, high: 0 as T),  1,  T.min     + 3,  0 as T, true)
            
            Test().division(D(low: M.msb - 4, high: 0 as T),  0,  nil)
            Test().division(D(low: M.msb - 3, high: 0 as T),  0,  nil)
            Test().division(D(low: M.msb - 2, high: 0 as T),  0,  nil)
            Test().division(D(low: M.msb - 1, high: 0 as T),  0,  nil)
            Test().division(D(low: M.msb + 0, high: 0 as T),  0,  nil)
            Test().division(D(low: M.msb + 1, high: 0 as T),  0,  nil)
            Test().division(D(low: M.msb + 2, high: 0 as T),  0,  nil)
            Test().division(D(low: M.msb + 3, high: 0 as T),  0,  nil)
            
            Test().division(D(low: M.msb - 4, high: 0 as T), -1,  T.min     + 4,  0 as T)
            Test().division(D(low: M.msb - 3, high: 0 as T), -1,  T.min     + 3,  0 as T)
            Test().division(D(low: M.msb - 2, high: 0 as T), -1,  T.min     + 2,  0 as T)
            Test().division(D(low: M.msb - 1, high: 0 as T), -1,  T.min     + 1,  0 as T)
            Test().division(D(low: M.msb + 0, high: 0 as T), -1,  T.min,          0 as T)
            Test().division(D(low: M.msb + 1, high: 0 as T), -1,  T.max     - 0,  0 as T, true)
            Test().division(D(low: M.msb + 2, high: 0 as T), -1,  T.max     - 1,  0 as T, true)
            Test().division(D(low: M.msb + 3, high: 0 as T), -1,  T.max     - 2,  0 as T, true)
            
            Test().division(D(low: M.msb - 4, high: 0 as T), -2,  T.min / 2 + 2,  0 as T)
            Test().division(D(low: M.msb - 3, high: 0 as T), -2,  T.min / 2 + 2,  1 as T)
            Test().division(D(low: M.msb - 2, high: 0 as T), -2,  T.min / 2 + 1,  0 as T)
            Test().division(D(low: M.msb - 1, high: 0 as T), -2,  T.min / 2 + 1,  1 as T)
            Test().division(D(low: M.msb + 0, high: 0 as T), -2,  T.min / 2,      0 as T)
            Test().division(D(low: M.msb + 1, high: 0 as T), -2,  T.min / 2,      1 as T)
            Test().division(D(low: M.msb + 2, high: 0 as T), -2,  T.min / 2 - 1,  0 as T)
            Test().division(D(low: M.msb + 3, high: 0 as T), -2,  T.min / 2 - 1,  1 as T)
        }
        
        for type in systemsIntegersWhereIsSigned {
            whereIsSigned(type)
        }
    }
    
    func testDivision2111NearMaxTimesTwoByZeroAsSigned() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger & SignedInteger {
            typealias M = T.Magnitude
            typealias D = Doublet<T>
                        
            Test().division(D(low: M.max - 4, high: 0 as T),  2,  T.max - 2,  1 as T)
            Test().division(D(low: M.max - 3, high: 0 as T),  2,  T.max - 1,  0 as T)
            Test().division(D(low: M.max - 2, high: 0 as T),  2,  T.max - 1,  1 as T)
            Test().division(D(low: M.max - 1, high: 0 as T),  2,  T.max,      0 as T)
            Test().division(D(low: M.max - 0, high: 0 as T),  2,  T.max,      1 as T)
            Test().division(D(low: M.min + 0, high: 1 as T),  2,  T.min,      0 as T, true)
            Test().division(D(low: M.min + 1, high: 1 as T),  2,  T.min,      1 as T, true)
            Test().division(D(low: M.min + 2, high: 1 as T),  2,  T.min + 1,  0 as T, true)
            
            Test().division(D(low: M.max - 4, high: 0 as T),  1, -00005,      0 as T, true)
            Test().division(D(low: M.max - 3, high: 0 as T),  1, -00004,      0 as T, true)
            Test().division(D(low: M.max - 2, high: 0 as T),  1, -00003,      0 as T, true)
            Test().division(D(low: M.max - 1, high: 0 as T),  1, -00002,      0 as T, true)
            Test().division(D(low: M.max - 0, high: 0 as T),  1, -00001,      0 as T, true)
            Test().division(D(low: M.min + 0, high: 1 as T),  1,  00000,      0 as T, true)
            Test().division(D(low: M.min + 1, high: 1 as T),  1,  00001,      0 as T, true)
            Test().division(D(low: M.min + 2, high: 1 as T),  1,  00002,      0 as T, true)
            
            Test().division(D(low: M.max - 4, high: 0 as T),  0,  nil)
            Test().division(D(low: M.max - 3, high: 0 as T),  0,  nil)
            Test().division(D(low: M.max - 2, high: 0 as T),  0,  nil)
            Test().division(D(low: M.max - 1, high: 0 as T),  0,  nil)
            Test().division(D(low: M.max + 0, high: 0 as T),  0,  nil)
            Test().division(D(low: M.min + 0, high: 1 as T),  0,  nil)
            Test().division(D(low: M.min + 1, high: 1 as T),  0,  nil)
            Test().division(D(low: M.min + 2, high: 1 as T),  0,  nil)
            
            Test().division(D(low: M.max - 4, high: 0 as T), -1,  00005,      0 as T, true)
            Test().division(D(low: M.max - 3, high: 0 as T), -1,  00004,      0 as T, true)
            Test().division(D(low: M.max - 2, high: 0 as T), -1,  00003,      0 as T, true)
            Test().division(D(low: M.max - 1, high: 0 as T), -1,  00002,      0 as T, true)
            Test().division(D(low: M.max - 0, high: 0 as T), -1,  00001,      0 as T, true)
            Test().division(D(low: M.min + 0, high: 1 as T), -1,  00000,      0 as T, true)
            Test().division(D(low: M.min + 1, high: 1 as T), -1, -00001,      0 as T, true)
            Test().division(D(low: M.min + 2, high: 1 as T), -1, -00002,      0 as T, true)

            Test().division(D(low: M.max - 4, high: 0 as T), -2,  T.min + 3,  1 as T)
            Test().division(D(low: M.max - 3, high: 0 as T), -2,  T.min + 2,  0 as T)
            Test().division(D(low: M.max - 2, high: 0 as T), -2,  T.min + 2,  1 as T)
            Test().division(D(low: M.max - 1, high: 0 as T), -2,  T.min + 1,  0 as T)
            Test().division(D(low: M.max - 0, high: 0 as T), -2,  T.min + 1,  1 as T)
            Test().division(D(low: M.min + 0, high: 1 as T), -2,  T.min,      0 as T)
            Test().division(D(low: M.min + 1, high: 1 as T), -2,  T.min,      1 as T)
            Test().division(D(low: M.min + 2, high: 1 as T), -2,  T.max,      0 as T, true)
        }
        
        for type in systemsIntegersWhereIsSigned {
            whereIsSigned(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Random
    //=------------------------------------------------------------------------=
    
    func testDivisionByFuzzing() {
        func whereIs<T>(_ type: T.Type, size: IX, rounds: IX, randomness: consuming FuzzerInt) where T: BinaryInteger {
            func random() -> T {
                let index = IX.random(in: 00000 ..< size, using: &randomness)!
                let pattern = T.Signitude.random(through: Shift(Count(index)), using: &randomness)
                return T(raw: pattern) // do not forget about infinite values!
            }
            
            for _  in 0 ..< rounds {
                let a = random()
                let b = random()
                
                if  let b = Divisor(exactly: b) {
                    let c = a.division(b).value
                    Test().same(a, c.quotient &* b.value &+ c.remainder)
                }
                
                if  let a = Divisor(exactly: a) {
                    let c = b.division(a).value
                    Test().same(b, c.quotient &* a.value &+ c.remainder)
                }
            }
        }
        
        for type in binaryIntegers {
            #if DEBUG
            whereIs(type, size: IX(size: type) ?? 1024, rounds: 16, randomness: fuzzer)
            #else
            whereIs(type, size: IX(size: type) ?? 8192, rounds: 16, randomness: fuzzer)
            #endif
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Code Coverage
//=----------------------------------------------------------------------------=

extension BinaryIntegerTestsOnDivision {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivisionLongCodeCoverageAsUnsignedInteger() {
        func whereIsBinaryInteger<T>(_ type: T.Type) where T: UnsignedInteger {
            //=----------------------------------=
            let size = (Esque<T>.shl + 1)
            let ones = (T(repeating: 001) << size).toggled()
            //=----------------------------------=
            var dividend: T, divisor: T, quotient: T, remainder: T
            //=----------------------------------=
            dividend   = (ones     << ((size *  5) >> 3)) & ones // [ 0,  0,  0,  0,  0, ~0, ~0, ~0]
            divisor    = (ones     >> ((size >> 1))) //............ [~0, ~0, ~0, ~0,  0,  0,  0,  0]
            quotient   = (dividend >> ((size >> 1))) //............ [ 0, ~0, ~0, ~0,  0,  0,  0,  0]
            remainder  = (quotient)   //........................... [ 0, ~0, ~0, ~0,  0,  0,  0,  0]
                    
            Test().division(dividend, divisor, quotient, remainder)
            
            dividend  += divisor
            quotient  += 1
            
            Test().division(dividend, divisor, quotient, remainder)

            dividend  += 1
            remainder += 1
            
            if  T.size == U8.size {
                Test().same(remainder, divisor)
                quotient  += 1
                remainder  = 0
            }
            
            Test().division(dividend, divisor, quotient, remainder)
        }
        
        func whereIsSystemsInteger<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            //=----------------------------------=
            var dividend = Doublet<T>(low: 0, high: 0)
            var divisor: T, quotient: T, remainder: T
            //=----------------------------------=
            // dividend: [ 0,  0,  0,  0,  0, ~0, ~0, ~0]
            // divisor:  [~0, ~0, ~0, ~0,  0,  0,  0,  0]
            //=----------------------------------=
            dividend.high  = T.max << (UX(size: T.self) >> 2)
            dividend.low   = T.Magnitude.min
            divisor        = T.max
            quotient       = dividend.high
            remainder      = dividend.high
            
            Test().division(dividend, divisor, quotient, remainder)
            
            dividend.low   = T.Magnitude.max
            quotient      += 1
            
            Test().division(dividend, divisor, quotient, remainder)
            
            dividend.low   = T.Magnitude.min
            dividend.high += 1
            remainder     += 1
            
            Test().division(dividend, divisor, quotient, remainder)
        }
        
        for type in binaryIntegersWhereIsUnsigned {
            whereIsBinaryInteger(type)
        }
        
        for type in systemsIntegersWhereIsUnsigned {
            whereIsSystemsInteger(type)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Recoverable
//=----------------------------------------------------------------------------=

extension BinaryIntegerTestsOnDivision {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testErrorPropagationMechanism() {
        func whereIs<T>(_ type: T.Type, size: IX, rounds: IX, randomness: consuming FuzzerInt) where T: BinaryInteger {
            var success: IX = 0
            var (index): IX = 0
            
            func random() -> T {
                let index = IX.random(in: 00000 ..< size, using: &randomness)!
                let pattern = T.Signitude.random(through: Shift(Count(index)), using: &randomness)
                return T(raw: pattern) // do not forget about infinite values!
            }
            
            while (index)  < rounds {
                let lhs: T = random()
                let rhs: T = random()
                
                guard let rhs = Divisor(exactly: rhs) else { continue }
                (index) += 1
                
                let division: Fallible<Division<T, T>> = lhs.division(rhs)
                success &+= IX(Bit(lhs.veto(false).division(rhs) == division))
                success &+= IX(Bit(lhs.veto(true ).division(rhs) == division.veto()))
                
                let quotient: Fallible<T> = lhs.quotient(rhs)
                success &+= IX(Bit(lhs.veto(false).quotient(rhs) == quotient))
                success &+= IX(Bit(lhs.veto(true ).quotient(rhs) == quotient.veto()))
                
                let remainder: Fallible<T> = Fallible(lhs.remainder(rhs))
                success &+= IX(Bit(lhs.veto(false).remainder(rhs) == remainder))
                success &+= IX(Bit(lhs.veto(true ).remainder(rhs) == remainder.veto()))
                
                let ceil: Fallible<T> = division.ceil()
                success &+= IX(Bit(division.veto(false).ceil() == ceil))
                success &+= IX(Bit(division.veto(true ).ceil() == ceil.veto()))
                
                let floor: Fallible<T> = division.floor()
                success &+= IX(Bit(division.veto(false).floor() == floor))
                success &+= IX(Bit(division.veto(true ).floor() == floor.veto()))
            }
            
            Test().same(success, rounds &* 10)
        }
        
        func whereIsUnsignedSystemsInteger<T>(_ type: T.Type, rounds: IX, randomness: consuming FuzzerInt) where T: SystemsInteger & UnsignedInteger {
            var success: IX = 0
            var (index): IX = 0
            
            while (index)  < rounds {
                let lhs: T = T.random()
                let rhs: T = T.random()
                
                guard let rhs = Divisor(exactly: rhs) else { continue }
                (index) += 1
                
                let division: Fallible<Division<T, T>> = lhs.division(rhs)
                success &+= IX(Bit(division.error == false))
                success &+= IX(Bit(lhs.division(rhs) == division.value))
                
                let quotient: Fallible<T> = lhs.quotient(rhs)
                success &+= IX(Bit(quotient.error == false))
                success &+= IX(Bit(lhs.quotient(rhs) == quotient.value))
            }
            
            Test().same(success, rounds &* 4)
        }
        
        for type in binaryIntegers {
            whereIs(type, size: IX(size: type) ?? 256, rounds: 08, randomness: fuzzer)
        }
        
        for type in systemsIntegersWhereIsUnsigned {
            whereIsUnsignedSystemsInteger((((type))),  rounds: 32, randomness: fuzzer)
        }
    }
}
