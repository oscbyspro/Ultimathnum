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
// MARK: * Data Int x Division
//*============================================================================*

extension DataIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivisionByElement() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            
            C([ ] as [T]).division(Divisor(1), quotient:[ ] as [T], remainder: 0)
            C([ ] as [T]).division(Divisor(2), quotient:[ ] as [T], remainder: 0)
            C([0] as [T]).division(Divisor(1), quotient:[0] as [T], remainder: 0)
            C([0] as [T]).division(Divisor(2), quotient:[0] as [T], remainder: 0)
            C([7] as [T]).division(Divisor(1), quotient:[7] as [T], remainder: 0)
            C([7] as [T]).division(Divisor(2), quotient:[3] as [T], remainder: 1)
            
            C([~2,  ~4,  ~6,  9] as [T]).division(Divisor(2), quotient:[~1, ~2, ~3, 4] as [T], remainder: 1)
            C([~3,  ~6,  ~9, 14] as [T]).division(Divisor(3), quotient:[~1, ~2, ~3, 4] as [T], remainder: 2)
            C([~4,  ~8, ~12, 19] as [T]).division(Divisor(4), quotient:[~1, ~2, ~3, 4] as [T], remainder: 3)
            C([~5, ~10, ~15, 24] as [T]).division(Divisor(5), quotient:[~1, ~2, ~3, 4] as [T], remainder: 4)
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    /// Checks that each 2-by-1 as U8 is equivalent to U16 by U16(U8).
    func testDivisionByElementForEach2By1AsU8() throws {
        #if DEBUG
        throw XCTSkip("req. release mode")
        #else
        var success = UX.zero
        var failure = UX.zero
        
        var body = [U8](repeating: 0, count: 2)
        body.withUnsafeMutableBufferPointer {
            let body = MutableDataInt.Body($0)!
            
            for low: U8 in U8.min ... U8.max {
                for high: U8 in U8.min ... U8.max {
                    body[unchecked: 0] = low
                    body[unchecked: 1] = high
                    
                    let dividend: U16 = DataInt(body).load(as: U16.self)
                    for divisor:  U8 in 1 ... U8.max {
                        let expectation = dividend.division(Divisor(U16(divisor))).unwrap()
                        
                        body[unchecked: 0] = low
                        body[unchecked: 1] = high
                        
                        let remainder: U8 = body.divisionSetQuotientGetRemainder(Divisor(divisor))
                        let quotient: U16 = DataInt(body).load(as: U16.self)
                        
                        if  Division(quotient: quotient, remainder: U16(remainder)) == expectation {
                            success  += 1
                        }   else {
                            failure  += 1
                        }
                    }
                }
            }
        }
        
        Test().same(success, 256 * 256 * 255)
        Test().same(failure, 000000000000000)
        #endif
    }
}

//*============================================================================*
// MARK: * Data Int x Multiplication x Assertions
//*============================================================================*

extension DataIntTests.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func division(_ divisor: Divisor<Element>, quotient: [Element], remainder: Element) {
        //=--------------------------------------=
        // division: remainder
        //=--------------------------------------=
        remainder: do {
            var body = self.body
            let result = body.withUnsafeMutableBufferPointer {
                MutableDataInt.Body($0)!.remainder(divisor)
            }
            
            test.same(body,   self.body)
            test.same(result, remainder)
        }
        //=--------------------------------------=
        // division: quotient and remainder
        //=--------------------------------------=
        division: do {
            var result: (quotient: [Element], remainder: Element)
            
            result.quotient  = self.body
            result.remainder = result.quotient.withUnsafeMutableBufferPointer {
                MutableDataInt.Body($0)!.divisionSetQuotientGetRemainder(divisor)
            }
            
            test.same(result.quotient,  quotient)
            test.same(result.remainder, remainder)
        }
    }
}
