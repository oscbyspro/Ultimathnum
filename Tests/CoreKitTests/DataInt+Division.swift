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
            typealias Canvas = DataIntTests.Canvas<T>
            
            Canvas([ ] as [T]).division(Divisor(1)!, quotient:[ ] as [T], remainder: 0)
            Canvas([ ] as [T]).division(Divisor(2)!, quotient:[ ] as [T], remainder: 0)
            Canvas([0] as [T]).division(Divisor(1)!, quotient:[0] as [T], remainder: 0)
            Canvas([0] as [T]).division(Divisor(2)!, quotient:[0] as [T], remainder: 0)
            Canvas([7] as [T]).division(Divisor(1)!, quotient:[7] as [T], remainder: 0)
            Canvas([7] as [T]).division(Divisor(2)!, quotient:[3] as [T], remainder: 1)
            
            Canvas([~2,  ~4,  ~6,  9] as [T]).division(Divisor(2)!, quotient:[~1, ~2, ~3, 4] as [T], remainder: 1)
            Canvas([~3,  ~6,  ~9, 14] as [T]).division(Divisor(3)!, quotient:[~1, ~2, ~3, 4] as [T], remainder: 2)
            Canvas([~4,  ~8, ~12, 19] as [T]).division(Divisor(4)!, quotient:[~1, ~2, ~3, 4] as [T], remainder: 3)
            Canvas([~5, ~10, ~15, 24] as [T]).division(Divisor(5)!, quotient:[~1, ~2, ~3, 4] as [T], remainder: 4)
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Multiplication x Assertions
//*============================================================================*

extension DataIntTests.Canvas {
    
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
