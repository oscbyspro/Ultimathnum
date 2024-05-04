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
// MARK: * Division x Rounding
//*============================================================================*

extension DivisionTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
 
    func testCeil() {
        func whereIs<Q, R>(_ quotient: Q.Type, _ remainder: R.Type) where Q: SystemsInteger, R: SystemsInteger {
            typealias C = Case<Q, R>
            typealias F = Fallible<Q>
        
            C(Q.min, R.min).ceil(F(Q.min))
            C(Q.min, ~0000).ceil(F(R.isSigned ? Q.min : Q.min + 1))
            C(Q.min, 00000).ceil(F(Q.min))
            C(Q.min, 00001).ceil(F(Q.min + 1))
            C(Q.min, R.max).ceil(F(Q.min + 1))
        
            C(00000, R.min).ceil(F(0))
            C(00000, ~0000).ceil(F(R.isSigned ? 0 : 1))
            C(00000, 00000).ceil(F(0))
            C(00000, 00001).ceil(F(1))
            C(00000, R.max).ceil(F(1))

            C(00001, R.min).ceil(F(1))
            C(00001, ~0000).ceil(F(R.isSigned ? 1 : 2))
            C(00001, 00000).ceil(F(1))
            C(00001, 00001).ceil(F(2))
            C(00001, R.max).ceil(F(2))
            
            C(Q.max, R.min).ceil(F(Q.max))
            C(Q.max, ~0000).ceil(F(R.isSigned ? Q.max : Q.min, error: !R.isSigned))
            C(Q.max, 00000).ceil(F(Q.max))
            C(Q.max, 00001).ceil(F(Q.min, error: true))
            C(Q.max, R.max).ceil(F(Q.min, error: true))
        }
        
        for quotient in coreSystemsIntegers {
            for remainder in coreSystemsIntegers {
                whereIs(quotient, remainder)
            }
        }
    }
    
    func testFloor() {
        func whereIs<Q, R>(_ quotient: Q.Type, _ remainder: R.Type) where Q: SystemsInteger, R: SystemsInteger {
            typealias C = Case<Q, R>
            typealias F = Fallible<Q>
        
            C(Q.min, R.min).floor(F(R.isSigned ? Q.max : Q.min, error: R.isSigned))
            C(Q.min, ~0000).floor(F(R.isSigned ? Q.max : Q.min, error: R.isSigned))
            C(Q.min, 00000).floor(F(Q.min))
            C(Q.min, 00001).floor(F(Q.min))
            C(Q.min, R.max).floor(F(Q.min))
        
            C(00000, R.min).floor(F(R.isSigned ? ~0000 : 00000, error: R.isSigned && !Q.isSigned))
            C(00000, ~0000).floor(F(R.isSigned ? ~0000 : 00000, error: R.isSigned && !Q.isSigned))
            C(00000, 00000).floor(F(0))
            C(00000, 00001).floor(F(0))
            C(00000, R.max).floor(F(0))
            
            C(00001, R.min).floor(F(R.isSigned ? 0 : 1))
            C(00001, ~0000).floor(F(R.isSigned ? 0 : 1))
            C(00001, 00000).floor(F(1))
            C(00001, 00001).floor(F(1))
            C(00001, R.max).floor(F(1))
            
            C(Q.max, R.min).floor(F(R.isSigned ? Q.max - 1 : Q.max))
            C(Q.max, ~0000).floor(F(R.isSigned ? Q.max - 1 : Q.max))
            C(Q.max, 00000).floor(F(Q.max))
            C(Q.max, 00001).floor(F(Q.max))
            C(Q.max, R.max).floor(F(Q.max))
        }
        
        for quotient in coreSystemsIntegers {
            for remainder in coreSystemsIntegers {
                whereIs(quotient, remainder)
            }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

extension DivisionTests.Case {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
 
    func ceil(_ expectation: Fallible<Quotient>) {
        test.same(item.ceil(), expectation, "Division/ceil()")
        test.same(Fallible(item, error: false).ceil(), expectation, "Fallible/ceil() [0]")
        test.same(Fallible(item, error: true ).ceil(), expectation.veto(true), "Fallible/ceil() [1]")
    }
    
    func floor(_ expectation: Fallible<Quotient>) {
        test.same(item.floor(), expectation, "Division/floor()")
        test.same(Fallible(item, error: false).floor(), expectation, "Fallible/floor() [0]")
        test.same(Fallible(item, error: true ).floor(), expectation.veto(true), "Fallible/floor() [1]")
    }
}
