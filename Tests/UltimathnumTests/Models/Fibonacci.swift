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
            XCTAssertNoThrow(check(index: sequence.index, element: expectation.element, invariants: invariants, file: file, line: line))
        }
    }
    
    #warning("reduce the get() count with conveniences")
    func check<T: BinaryInteger>(index: T, element: T?, invariants: Bool = true, file: StaticString = #file, line: UInt = #line) {
        typealias F = Fibonacci<T>
        //=--------------------------------------=
        let sequence = try? F(index)
        //=--------------------------------------=
        XCTAssertEqual(sequence?.element, element, file: file, line: line)
        //=--------------------------------------=
        if  invariants, let sequence {
            for divisor: T in [2, 3, 5, 7].compactMap({ try? T.exactly($0).get() }) {
                brrrrrr: do {
                    let a = sequence
                    let b = try F(index.quotient(divisor: divisor).get())
                    let c = try F(a.index.minus(b.index).get())
                    let d = try a.next.divided(by:  b.next).get()
                    let e = try b.element .times(c.element).get()
                    let f = try d.quotient.minus(c.next).get().times(b.next).get().plus(d.remainder).get()
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
    
    func checkInvariantsAtZero<T>(_ sequence: Fibonacci<T>.Type, invariants: Bool = true, file: StaticString = #file, line: UInt = #line) {
        typealias F = Fibonacci<T>
        
        if  T.isSigned {
            XCTAssertThrowsError(try F(-1))
        }
                
        if  let one = try? T.exactly(1).get(), var sequence = Test.some(try? F()) {
            XCTAssertNoThrow/**/(try F( ))
            XCTAssertNoThrow/**/(try F(0))
            
            let components = Components(0, 0, one)
            check(sequence, components, invariants: invariants,  file: file, line: line)
            XCTAssertThrowsError(try sequence.decrement())
            check(sequence, components, invariants: (((false))), file: file, line: line)
            XCTAssertNoThrow/**/(try sequence.double())
            check(sequence, components, invariants: (((false))), file: file, line: line)
        }   else {
            XCTAssertThrowsError(try F( ))
            XCTAssertThrowsError(try F(0))
        }
    }
    
    func checkInvariantsAtLastElement<T>(_ sequence: Fibonacci<T>, invariants: Bool = true, _ expectation: Components<T>, file: StaticString = #file, line: UInt = #line) {
        var ((sequence)) = sequence
        check(sequence, expectation, invariants: invariants,  file: file, line: line)
        XCTAssertThrowsError(try sequence.increment())
        check(sequence, expectation, invariants: (((false))), file: file, line: line)
        XCTAssertThrowsError(try sequence.double())
        check(sequence, expectation, invariants: (((false))), file: file, line: line)
    }
}
