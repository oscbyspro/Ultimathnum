//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import ModelsKit
import TestKit

//*============================================================================*
// MARK: * Fibonacci
//*============================================================================*

final class FibonacciTests: XCTestCase {
    
    typealias Components<T> = (index: T, element: T, next: T)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func check<T>(_ sequence: Fibonacci<T>?, _ expectation: Components<T>?, invariants: Bool = true, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(sequence?.index,   expectation?.index,   file: file, line: line)
        XCTAssertEqual(sequence?.element, expectation?.element, file: file, line: line)
        XCTAssertEqual(sequence?.next,    expectation?.next,    file: file, line: line)
        
        if  invariants, let  expectation, let sequence =  Test.some(sequence) {
            XCTAssertNoThrow(check(index: sequence.index, element: expectation.element, file: file, line: line))
        }
    }
    
    func check<T: Integer>(index: T, element: T?, invariants: Bool = true, file: StaticString = #file, line: UInt = #line) {
        typealias F = Fibonacci<T>
        //=--------------------------------------=
        let sequence = try? F(index)
        //=--------------------------------------=
        XCTAssertEqual(sequence?.element, element, file: file, line: line)
        //=--------------------------------------=
        if  invariants, let sequence {
            for divisor: T in [2, 3, 5, 7].compactMap({ try? T(literally: $0) }) {
                brrrrrr: do {
                    let a = sequence
                    let b = try F(index.quotient(divisor:  divisor))
                    let c = try F(a.index.decremented(by:  b.index))
                    let d = try a.next.divided(by: b.next)
                    let e = try b.element .multiplied (by: c.element)
                    let f = try d.quotient.decremented(by: c.next).multiplied(by: b.next).incremented(by: d.remainder)
                    XCTAssertEqual(e, f, "arithmetic invariant error", file: file, line: line)
                }   catch let error {
                    XCTFail("unexpected arithmetic failure: \(error)", file: file, line: line)
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Min, Max
    //=------------------------------------------------------------------------=
    
    func checkLowerBound<T>(_ sequence: Fibonacci<T>.Type, file: StaticString = #file, line: UInt = #line) {
        typealias F = Fibonacci<T>
        
        if  T.isSigned {
            XCTAssertThrowsError(try F(-1))
        }
                
        if  let one = try? T(literally: 1), var sequence = Test.some(try? F()) {
            XCTAssertNoThrow/**/(try F( ))
            XCTAssertNoThrow/**/(try F(0))
            
            let components  = Components(0, 0, one)
            check(sequence, components, file: file, line: line)
            XCTAssertThrowsError(try sequence.decrement())
            check(sequence, components, file: file, line: line)
            XCTAssertNoThrow/**/(try sequence.double())
            check(sequence, components, file: file, line: line)
        }   else {
            XCTAssertThrowsError(try F( ))
            XCTAssertThrowsError(try F(0))
        }
    }
    
    func checkUpperBound<T>(_ sequence: Fibonacci<T>, _ expectation: Components<T>, file: StaticString = #file, line: UInt = #line) {
        var ((sequence)) = sequence
        check(sequence, expectation, invariants: true,  file: file, line: line)
        XCTAssertThrowsError(try sequence.increment())
        check(sequence, expectation, invariants: false, file: file, line: line)
        XCTAssertThrowsError(try sequence.double())
        check(sequence, expectation, invariants: false, file: file, line: line)
    }
}
