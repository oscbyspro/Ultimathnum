//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Ultimathnum
import TestKit

//*============================================================================*
// MARK: * Fibonacci x Minimi Int
//*============================================================================*

extension FibonacciTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    private static let minimiIntList: [any SystemsInteger.Type] = [
        I1.self,
        U1.self
    ]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMinimiInt() {
        min: do {
            checkInvariantsAtZero(Fibonacci<I1>.self)
            checkInvariantsAtZero(Fibonacci<U1>.self)
        }
        
        signed: do {
            check(try? Fibonacci<I1>(  ), nil)
            check(try? Fibonacci<I1>(-1), nil)
            check(try? Fibonacci<I1>( 0), nil)
        }
        
        unsigned: do {
            check(try? Fibonacci<U1>(  ), (index: 0, element: 0, next: 1))
            check(try? Fibonacci<U1>( 0), (index: 0, element: 0, next: 1))
            check(try? Fibonacci<U1>( 1), (index: 1, element: 1, next: 1))
        }
        
        if  var sequence =  Test.some(try? Fibonacci<U1>( 0)) {
            check(sequence, (0, 0, 1))
            XCTAssertNoThrow/**/(try sequence.increment())
            check(sequence, (1, 1, 1))
            XCTAssertThrowsError(try sequence.increment())
        }
        
        if  var sequence =  Test.some(try? Fibonacci<U1>( 1)) {
            check(sequence, (1, 1, 1))
            XCTAssertNoThrow/**/(try sequence.decrement())
            check(sequence, (0, 0, 1))
            XCTAssertThrowsError(try sequence.decrement())
        }
        
        if  var sequence =  Test.some(try? Fibonacci<U1>( 0)) {
            check(sequence, (0, 0, 1))
            XCTAssertNoThrow/**/(try sequence.double())
            check(sequence, (0, 0, 1))
        }
        
        if  var sequence =  Test.some(try? Fibonacci<U1>( 1)) {
            check(sequence, (1, 1, 1))
            XCTAssertThrowsError(try sequence.double())
        }
    }
}
