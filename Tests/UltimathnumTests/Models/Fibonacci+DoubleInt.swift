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
// MARK: * Fibonacci x Double Int
//*============================================================================*

extension FibonacciTests {

    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    private static let doubleIntList: [any SystemsInteger.Type] = [
        DoubleInt<I8>.self, DoubleInt<DoubleInt<I8>>.self, // DoubleInt<DoubleInt<DoubleInt<I8>>>.self,
        DoubleInt<U8>.self, DoubleInt<DoubleInt<U8>>.self, // DoubleInt<DoubleInt<DoubleInt<U8>>>.self,
        DoubleInt<IX>.self, DoubleInt<DoubleInt<IX>>.self, // DoubleInt<DoubleInt<DoubleInt<IX>>>.self,
        DoubleInt<UX>.self, DoubleInt<DoubleInt<UX>>.self, // DoubleInt<DoubleInt<DoubleInt<IX>>>.self,
    ]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDoubleInt() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fibonacci<T>
            
            min: do {
                checkInvariantsAtZero(F.self)
            }
            
            brr: do {
                check(try? F(  ), (index: 0, element: 0, next: 1))
                check(try? F( 0), (index: 0, element: 0, next: 1))
                check(try? F( 1), (index: 1, element: 1, next: 1))
                check(try? F( 2), (index: 2, element: 1, next: 2))
                check(try? F( 3), (index: 3, element: 2, next: 3))
                check(try? F( 4), (index: 4, element: 3, next: 5))
                check(try? F( 5), (index: 5, element: 5, next: 8))
            }
            
            if  var sequence =  Test().some(try? F(0)) {
                check(sequence, (index: 0, element: 0, next: 1))
                XCTAssertNoThrow/**/(try sequence.increment())
                check(sequence, (index: 1, element: 1, next: 1))
                XCTAssertNoThrow/**/(try sequence.increment())
                check(sequence, (index: 2, element: 1, next: 2))
                XCTAssertNoThrow/**/(try sequence.increment())
                check(sequence, (index: 3, element: 2, next: 3))
                XCTAssertNoThrow/**/(try sequence.increment())
                check(sequence, (index: 4, element: 3, next: 5))
                XCTAssertNoThrow/**/(try sequence.increment())
                check(sequence, (index: 5, element: 5, next: 8))
            }
            
            if  var sequence =  Test().some(try? F(5)) {
                check(sequence, (index: 5, element: 5, next: 8))
                XCTAssertNoThrow/**/(try sequence.decrement())
                check(sequence, (index: 4, element: 3, next: 5))
                XCTAssertNoThrow/**/(try sequence.decrement())
                check(sequence, (index: 3, element: 2, next: 3))
                XCTAssertNoThrow/**/(try sequence.decrement())
                check(sequence, (index: 2, element: 1, next: 2))
                XCTAssertNoThrow/**/(try sequence.decrement())
                check(sequence, (index: 1, element: 1, next: 1))
                XCTAssertNoThrow/**/(try sequence.decrement())
                check(sequence, (index: 0, element: 0, next: 1))
            }
        }
        
        for type in Self.doubleIntList {
            whereIs(type)
        }
    }
    
    func testDoubleIntLimit() {
        if  let sequence = Test().some(try? Fibonacci<DoubleInt<I8>>(22)) {
            checkInvariantsAtLastElement(sequence, (index: 22, element: 17711, next: 28657))
        }
        
        if  let sequence = Test().some(try? Fibonacci<DoubleInt<DoubleInt<I8>>>(45)) {
            checkInvariantsAtLastElement(sequence, (index: 45, element: 1134903170, next: 1836311903))
        }
        
        if  let sequence = Test().some(try? Fibonacci<DoubleInt<DoubleInt<DoubleInt<I8>>>>(91)) {
            checkInvariantsAtLastElement(sequence, (index: 91, element: 4660046610375530309, next: 07540113804746346429))
        }
        
        if  let sequence = Test().some(try? Fibonacci<DoubleInt<U8>>(23)) {
            checkInvariantsAtLastElement(sequence, (index: 23, element: 28657, next: 46368))
        }
        
        if  let sequence = Test().some(try? Fibonacci<DoubleInt<DoubleInt<U8>>>(46)) {
            checkInvariantsAtLastElement(sequence, (index: 46, element: 1836311903, next: 2971215073))
        }
        
        if  let sequence = Test().some(try? Fibonacci<DoubleInt<DoubleInt<DoubleInt<U8>>>>(92)) {
            checkInvariantsAtLastElement(sequence, (index: 92, element: 7540113804746346429, next: 12200160415121876738))
        }
    }
}
