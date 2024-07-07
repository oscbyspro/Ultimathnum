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
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Division
//*============================================================================*

final class BinaryIntegerTestsOnDivision: XCTestCase {
    
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
            
            Test().division(T.min,      0 as T, nil)
            Test().division(T.min + 1,  0 as T, nil)
            Test().division(T.min + 2,  0 as T, nil)
            Test().division(T.min + 3,  0 as T, nil)

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
            
            Test().division(T.max,      0 as T, nil)
            Test().division(T.max - 1,  0 as T, nil)
            Test().division(T.max - 2,  0 as T, nil)
            Test().division(T.max - 3,  0 as T, nil)
            
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
            
            Test().division(D(low: M.msb + 3, high: -1 as T),  2,  T.min / 2 + 2, -1 as T)
            Test().division(D(low: M.msb + 2, high: -1 as T),  2,  T.min / 2 + 1,  0 as T)
            Test().division(D(low: M.msb + 1, high: -1 as T),  2,  T.min / 2 + 1, -1 as T)
            Test().division(D(low: M.msb + 0, high: -1 as T),  2,  T.min / 2,      0 as T)
            Test().division(D(low: M.msb - 1, high: -1 as T),  2,  T.min / 2,     -1 as T)
            Test().division(D(low: M.msb - 2, high: -1 as T),  2,  T.min / 2 - 1,  0 as T)
            Test().division(D(low: M.msb - 3, high: -1 as T),  2,  T.min / 2 - 1, -1 as T)
            Test().division(D(low: M.msb - 4, high: -1 as T),  2,  T.min / 2 - 2,  0 as T)
            
            Test().division(D(low: M.msb + 3, high: -1 as T),  1,  T.min     + 3,  0 as T)
            Test().division(D(low: M.msb + 2, high: -1 as T),  1,  T.min     + 2,  0 as T)
            Test().division(D(low: M.msb + 1, high: -1 as T),  1,  T.min     + 1,  0 as T)
            Test().division(D(low: M.msb + 0, high: -1 as T),  1,  T.min,          0 as T)
            Test().division(D(low: M.msb - 1, high: -1 as T),  1,  T.max,          0 as T, true)
            Test().division(D(low: M.msb - 2, high: -1 as T),  1,  T.max     - 1,  0 as T, true)
            Test().division(D(low: M.msb - 3, high: -1 as T),  1,  T.max     - 2,  0 as T, true)
            Test().division(D(low: M.msb - 4, high: -1 as T),  1,  T.max     - 3,  0 as T, true)
            
            Test().division(D(low: M.msb + 3, high: -1 as T),  0,  nil)
            Test().division(D(low: M.msb + 2, high: -1 as T),  0,  nil)
            Test().division(D(low: M.msb + 1, high: -1 as T),  0,  nil)
            Test().division(D(low: M.msb + 0, high: -1 as T),  0,  nil)
            Test().division(D(low: M.msb - 1, high: -1 as T),  0,  nil)
            Test().division(D(low: M.msb - 2, high: -1 as T),  0,  nil)
            Test().division(D(low: M.msb - 3, high: -1 as T),  0,  nil)
            Test().division(D(low: M.msb - 4, high: -1 as T),  0,  nil)
            
            Test().division(D(low: M.msb + 3, high: -1 as T), -1,  T.max     - 2,  0 as T)
            Test().division(D(low: M.msb + 2, high: -1 as T), -1,  T.max     - 1,  0 as T)
            Test().division(D(low: M.msb + 1, high: -1 as T), -1,  T.max,          0 as T)
            Test().division(D(low: M.msb + 0, high: -1 as T), -1,  T.min,          0 as T, true)
            Test().division(D(low: M.msb - 1, high: -1 as T), -1,  T.min     + 1,  0 as T, true)
            Test().division(D(low: M.msb - 2, high: -1 as T), -1,  T.min     + 2,  0 as T, true)
            Test().division(D(low: M.msb - 3, high: -1 as T), -1,  T.min     + 3,  0 as T, true)
            Test().division(D(low: M.msb - 4, high: -1 as T), -1,  T.min     + 4,  0 as T, true)
            
            Test().division(D(low: M.msb + 3, high: -1 as T), -2,  T.max / 2 - 1, -1 as T)
            Test().division(D(low: M.msb + 2, high: -1 as T), -2,  T.max / 2,      0 as T)
            Test().division(D(low: M.msb + 1, high: -1 as T), -2,  T.max / 2,     -1 as T)
            Test().division(D(low: M.msb + 0, high: -1 as T), -2,  T.max / 2 + 1,  0 as T)
            Test().division(D(low: M.msb - 1, high: -1 as T), -2,  T.max / 2 + 1, -1 as T)
            Test().division(D(low: M.msb - 2, high: -1 as T), -2,  T.max / 2 + 2,  0 as T)
            Test().division(D(low: M.msb - 3, high: -1 as T), -2,  T.max / 2 + 2, -1 as T)
            Test().division(D(low: M.msb - 4, high: -1 as T), -2,  T.max / 2 + 3,  0 as T)
        }
                
        for type in systemsIntegersWhereIsSigned {
            whereIsSigned(type)
        }
    }
    
    func testDivision2111NearMinTimesTwoByZeroAsSigned() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger & SignedInteger {
            typealias M = T.Magnitude
            typealias D = Doublet<T>
            
            Test().division(D(low: M.min + 3, high: -1 as T),  2,  T.min + 2, -1 as T)
            Test().division(D(low: M.min + 2, high: -1 as T),  2,  T.min + 1,  0 as T)
            Test().division(D(low: M.min + 1, high: -1 as T),  2,  T.min + 1, -1 as T)
            Test().division(D(low: M.min,     high: -1 as T),  2,  T.min,      0 as T)
            Test().division(D(low: M.max,     high: -2 as T),  2,  T.min,     -1 as T)
            Test().division(D(low: M.max - 1, high: -2 as T),  2,  T.max,      0 as T, true)
            Test().division(D(low: M.max - 2, high: -2 as T),  2,  T.max,     -1 as T, true)
            Test().division(D(low: M.max - 3, high: -2 as T),  2,  T.max - 1,  0 as T, true)
            
            Test().division(D(low: M.min + 3, high: -1 as T),  1,  00003,      0 as T, true)
            Test().division(D(low: M.min + 2, high: -1 as T),  1,  00002,      0 as T, true)
            Test().division(D(low: M.min + 1, high: -1 as T),  1,  00001,      0 as T, true)
            Test().division(D(low: M.min,     high: -1 as T),  1,  00000,      0 as T, true)
            Test().division(D(low: M.max,     high: -2 as T),  1, -00001,      0 as T, true)
            Test().division(D(low: M.max - 1, high: -2 as T),  1, -00002,      0 as T, true)
            Test().division(D(low: M.max - 2, high: -2 as T),  1, -00003,      0 as T, true)
            Test().division(D(low: M.max - 3, high: -2 as T),  1, -00004,      0 as T, true)
            
            Test().division(D(low: M.min + 3, high: -1 as T),  0, nil)
            Test().division(D(low: M.min + 2, high: -1 as T),  0, nil)
            Test().division(D(low: M.min + 1, high: -1 as T),  0, nil)
            Test().division(D(low: M.min,     high: -1 as T),  0, nil)
            Test().division(D(low: M.max,     high: -2 as T),  0, nil)
            Test().division(D(low: M.max - 1, high: -2 as T),  0, nil)
            Test().division(D(low: M.max - 2, high: -2 as T),  0, nil)
            Test().division(D(low: M.max - 3, high: -2 as T),  0, nil)
            
            Test().division(D(low: M.min + 3, high: -1 as T), -1, -00003,      0 as T, true)
            Test().division(D(low: M.min + 2, high: -1 as T), -1, -00002,      0 as T, true)
            Test().division(D(low: M.min + 1, high: -1 as T), -1, -00001,      0 as T, true)
            Test().division(D(low: M.min,     high: -1 as T), -1,  00000,      0 as T, true)
            Test().division(D(low: M.max,     high: -2 as T), -1,  00001,      0 as T, true)
            Test().division(D(low: M.max - 1, high: -2 as T), -1,  00002,      0 as T, true)
            Test().division(D(low: M.max - 2, high: -2 as T), -1,  00003,      0 as T, true)
            Test().division(D(low: M.max - 3, high: -2 as T), -1,  00004,      0 as T, true)
            
            Test().division(D(low: M.min + 3, high: -1 as T), -2,  T.max - 1, -1 as T)
            Test().division(D(low: M.min + 2, high: -1 as T), -2,  T.max,      0 as T)
            Test().division(D(low: M.min + 1, high: -1 as T), -2,  T.max,     -1 as T)
            Test().division(D(low: M.min,     high: -1 as T), -2,  T.min,      0 as T, true)
            Test().division(D(low: M.max,     high: -2 as T), -2,  T.min,     -1 as T, true)
            Test().division(D(low: M.max - 1, high: -2 as T), -2,  T.min + 1,  0 as T, true)
            Test().division(D(low: M.max - 2, high: -2 as T), -2,  T.min + 1, -1 as T, true)
            Test().division(D(low: M.max - 3, high: -2 as T), -2,  T.min + 2,  0 as T, true)
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
}
