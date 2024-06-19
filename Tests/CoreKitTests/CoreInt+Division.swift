//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Core Int x Division
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivision() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            IntegerInvariants(T.self).divisionOfMsbEsque()
            IntegerInvariants(T.self).divisionOfSmallBySmall()
            IntegerInvariants(T.self).divisionByZero(SystemsIntegerID())
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            IntegerInvariants(T.self).divisionLongCodeCoverage(SystemsIntegerID())
        }
        
        for type in Self.types {
            whereIs(type)
        }
        
        for type in Self.typesWhereIsUnsigned {
            whereIsUnsigned(type)
        }        
    }
    
    func testDivision2111() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias D = Division<T, T>
            typealias F = Fallible<D>
            typealias X = Doublet<T>
            //=----------------------------------=
            Test().division(X(low:  1 as M, high:  T .max >> 1    ), T.max, F(D(quotient: T.max, remainder:         0)))
            Test().division(X(low: ~M .msb, high:  T .max >> 1    ), T.max, F(D(quotient: T.max, remainder: T.max - 1)))
            Test().division(X(low:  M .msb, high:  T .max >> 1    ), T.max, F(D(quotient: T.min, remainder:         0), error: true))
            Test().division(X(low:  0 as M, high:  T .max >> 1 + 1), T.min, F(D(quotient: T.min, remainder:         0)))
            Test().division(X(low: ~M .msb, high:  T .max >> 1 + 1), T.min, F(D(quotient: T.min, remainder: T.max - 0)))
            Test().division(X(low:  M .msb, high:  T .max >> 1 + 1), T.min, F(D(quotient: T.max, remainder:         0), error: true))
            //=----------------------------------=
            Test().division(X(low:  1 as M, high:  0 as T), -2 as T, F(D(quotient:  0,     remainder:  1)))
            Test().division(X(low: ~0 as M, high: -1 as T),  2 as T, F(D(quotient:  0,     remainder: -1)))
            Test().division(X(low:  7 as M, high:  0 as T),  0 as T, nil)
            Test().division(X(low:  7 as M, high: -1 as T),  0 as T, nil)
            Test().division(X(low: ~M .msb, high:  0 as T), -1 as T, F(D(quotient: -T.max, remainder:  0)))
            Test().division(X(low:  M .msb, high: -1 as T), -1 as T, F(D(quotient:  T.min, remainder:  0), error: true))
            //=----------------------------------=
            Test().division(X(low:  0 as M, high: ~0 as T),  0 as T, nil)
            Test().division(X(low:  0 as M, high: ~0 as T),  1 as T, F(D(quotient: ~0 << T(raw: T.size - 0), remainder: 0), error: true))
            Test().division(X(low:  0 as M, high: ~0 as T),  2 as T, F(D(quotient: ~0 << T(raw: T.size - 1), remainder: 0)))
            Test().division(X(low:  0 as M, high: ~0 as T),  4 as T, F(D(quotient: ~0 << T(raw: T.size - 2), remainder: 0)))
            Test().division(X(low:  0 as M, high: ~0 as T),  8 as T, F(D(quotient: ~0 << T(raw: T.size - 3), remainder: 0)))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias D = Division<T, T>
            typealias F = Fallible<D>
            typealias X = Doublet<T>
            //=----------------------------------=
            Test().division(X(low:  1 as M, high: ~1 as T), ~0 as T, F(D(quotient: ~0, remainder:  0)))
            Test().division(X(low: ~0 as M, high: ~1 as T), ~0 as T, F(D(quotient: ~0, remainder: ~1)))
            //=----------------------------------=
            Test().division(X(low:  7 as M, high:  0 as T),  0 as T, nil)
            Test().division(X(low:  7 as M, high: ~0 as T),  0 as T, nil)
            Test().division(X(low:  0 as M, high: ~0 as T), ~0 as T, F(D(quotient:  0, remainder:  0), error: true))
            Test().division(X(low: ~0 as M, high: ~1 as T), ~0 as T, F(D(quotient: ~0, remainder: ~1)))
            //=----------------------------------=
            Test().division(X(low:  0 as M, high: ~0 as T),  0 as T, nil)
            Test().division(X(low:  0 as M, high: ~0 as T),  1 as T, F(D(quotient: ~0 << T(raw: T.size - 0), remainder: 0), error: true))
            Test().division(X(low:  0 as M, high: ~0 as T),  2 as T, F(D(quotient: ~0 << T(raw: T.size - 1), remainder: 0), error: true))
            Test().division(X(low:  0 as M, high: ~0 as T),  4 as T, F(D(quotient: ~0 << T(raw: T.size - 2), remainder: 0), error: true))
            Test().division(X(low:  0 as M, high: ~0 as T),  8 as T, F(D(quotient: ~0 << T(raw: T.size - 3), remainder: 0), error: true))
        }
        
        for type in Self.typesWhereIsSigned {
            whereIsSigned(type)
        }
        
        for type in Self.typesWhereIsUnsigned {
            whereIsUnsigned(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x RELEASE
    //=------------------------------------------------------------------------=
    
    func testDivision2111I8() throws {
        #if DEBUG
        throw XCTSkip("req. release mode")
        #else
        var success: UX = 0
        var failure: UX = 0
        
        for divisor     in I8.min...I8.max {
            for high    in I8.min...I8.max {
                for low in U8.min...U8.max {
                    if  let divisor = Divisor(exactly: divisor), !I8.division(Doublet(low: low, high: high), by: divisor).error {
                        success += 1
                    }   else {
                        failure += 1
                    }
                }
            }
        }
        
        XCTAssertEqual(success, 04210433)
        XCTAssertEqual(failure, 12566783)
        #endif
    }
    
    func testDivision2111U8() throws {
        #if DEBUG
        throw XCTSkip("req. release mode")
        #else
        var success: UX = 0
        var failure: UX = 0
        
        for divisor     in U8.min...U8.max {
            for high    in U8.min...U8.max {
                for low in U8.min...U8.max {
                    if  let divisor = Divisor(exactly: divisor), !U8.division(Doublet(low: low, high: high), by: divisor).error {
                        success += 1
                    }   else {
                        failure += 1
                    }
                }
            }
        }
        
        XCTAssertEqual(success, 08355840)
        XCTAssertEqual(failure, 08421376)
        #endif
    }
}
