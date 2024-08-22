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

final class DivisionTestsOnRounding: XCTestCase {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
 
    func testCeil() {
        func whereIs<Q, R>(_ quotient: Q.Type, _ remainder: R.Type) where Q: SystemsInteger, R: SystemsInteger {
            func expect(_ quotient: Q, _ remainder: R, _ expectation: Q, _ error: Bool = false, line: UInt = #line) {
                let division = Division(quotient: quotient, remainder: remainder)
                Test(line: line).same(division            .ceil(), Fallible(expectation, error: error))
                Test(line: line).same(division.veto(false).ceil(), Fallible(expectation, error: error))
                Test(line: line).same(division.veto(true ).ceil(), Fallible(expectation, error: true ))
            }
            
            expect(Q.min, R.min, Q.min)
            expect(Q.min, ~0000, R.isSigned ? Q.min : Q.min + 1)
            expect(Q.min, 00000, Q.min)
            expect(Q.min, 00001, Q.min + 1)
            expect(Q.min, R.max, Q.min + 1)
        
            expect(00000, R.min, 0)
            expect(00000, ~0000, R.isSigned ? 0 : 1)
            expect(00000, 00000, 0)
            expect(00000, 00001, 1)
            expect(00000, R.max, 1)

            expect(00001, R.min, 1)
            expect(00001, ~0000, R.isSigned ? 1 : 2)
            expect(00001, 00000, 1)
            expect(00001, 00001, 2)
            expect(00001, R.max, 2)
            
            expect(Q.max, R.min, Q.max)
            expect(Q.max, ~0000, R.isSigned ? Q.max : Q.min, !R.isSigned)
            expect(Q.max, 00000, Q.max)
            expect(Q.max, 00001, Q.min, true)
            expect(Q.max, R.max, Q.min, true)
        }
        
        for quotient in coreSystemsIntegers {
            for remainder in coreSystemsIntegers {
                whereIs(quotient, remainder)
            }
        }
    }
    
    func testFloor() {
        func whereIs<Q, R>(_ quotient: Q.Type, _ remainder: R.Type) where Q: SystemsInteger, R: SystemsInteger {
            func expect(_ quotient: Q, _ remainder: R, _ expectation: Q, _ error: Bool = false, line: UInt = #line) {
                let division = Division(quotient: quotient, remainder: remainder)
                Test(line: line).same(division            .floor(), Fallible(expectation, error: error))
                Test(line: line).same(division.veto(false).floor(), Fallible(expectation, error: error))
                Test(line: line).same(division.veto(true ).floor(), Fallible(expectation, error: true ))
            }
            
            expect(Q.min, R.min, R.isSigned ? Q.max : Q.min, R.isSigned)
            expect(Q.min, ~0000, R.isSigned ? Q.max : Q.min, R.isSigned)
            expect(Q.min, 00000, Q.min)
            expect(Q.min, 00001, Q.min)
            expect(Q.min, R.max, Q.min)
        
            expect(00000, R.min, R.isSigned ? ~0000 : 00000, R.isSigned && !Q.isSigned)
            expect(00000, ~0000, R.isSigned ? ~0000 : 00000, R.isSigned && !Q.isSigned)
            expect(00000, 00000, 0)
            expect(00000, 00001, 0)
            expect(00000, R.max, 0)
            
            expect(00001, R.min, R.isSigned ? 0 : 1)
            expect(00001, ~0000, R.isSigned ? 0 : 1)
            expect(00001, 00000, 1)
            expect(00001, 00001, 1)
            expect(00001, R.max, 1)
            
            expect(Q.max, R.min, R.isSigned ? Q.max - 1 : Q.max)
            expect(Q.max, ~0000, R.isSigned ? Q.max - 1 : Q.max)
            expect(Q.max, 00000, Q.max)
            expect(Q.max, 00001, Q.max)
            expect(Q.max, R.max, Q.max)
        }
        
        for quotient in coreSystemsIntegers {
            for remainder in coreSystemsIntegers {
                whereIs(quotient, remainder)
            }
        }
    }
}
