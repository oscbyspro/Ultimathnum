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
    
    func check<T>(_ sequence: Fibonacci<T>?, _ expectation: Components<T>?, invariants: Bool = true, test: Test) {
        test.same(sequence?.index,   expectation?.index)
        test.same(sequence?.element, expectation?.element)
        test.same(sequence?.next,    expectation?.next)
        
        if  invariants, let  expectation, let sequence =  Test().some(sequence) {
            test.success(check(index: sequence.index, element: expectation.element, invariants: invariants, test: test))
        }
    }
    
    func check<T: BinaryInteger>(index: T, element: T?, invariants: Bool = true, test: Test) {
        typealias F = Fibonacci<T>
        //=--------------------------------------=
        let sequence = try? F(index)
        //=--------------------------------------=
        test.same(sequence?.element, element)
        //=--------------------------------------=
        if  invariants, let sequence {
            for divisor: T in [2, 3, 5, 7].compactMap({ T.exactly($0).optional() }) {
                brrrrrr: do {
                    let a = sequence
                    let b = try F(index.quotient(divisor).get())
                    let c = try F(a.index.minus (b.index).get())
                    let d = try a.next.division (b.next ).get()
                    let e = try b.element .times(c.element).get()
                    let f = try d.quotient.minus(c.next).times(b.next).plus(d.remainder).get()
                    test.same(e, f, "arithmetic invariant error")
                }   catch let error {
                    test.fail("unexpected arithmetic failure: \(error)")
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Min, Max
    //=------------------------------------------------------------------------=
    
    func checkInvariantsAtZero<T>(_ sequence: Fibonacci<T>.Type, invariants: Bool = true, test: Test) {
        typealias F = Fibonacci<T>
        
        if  T.isSigned {
            test.failure(try F(-1))
        }
                
        if  let one = T.exactly(1).optional(), var sequence = test.some(try? F()) {
            test.success(try F( ))
            test.success(try F(0))
            
            let components = Components(0, 0, one)
            check(sequence, components, invariants: invariants,  test: test)
            test.failure(try sequence.decrement())
            check(sequence, components, invariants: (((false))), test: test)
            test.success(try sequence.double())
            check(sequence, components, invariants: (((false))), test: test)
        }   else {
            test.failure(try F( ))
            test.failure(try F(0))
        }
    }
    
    func checkInvariantsAtLastElement<T>(_ sequence: Fibonacci<T>, invariants: Bool = true, _ expectation: Components<T>, test: Test = .init()) {
        var ((sequence)) = sequence
        check(sequence, expectation, invariants: invariants,  test: test)
        test.failure(try sequence.increment())
        check(sequence, expectation, invariants: (((false))), test: test)
        test.failure(try sequence.double())
        check(sequence, expectation, invariants: (((false))), test: test)
    }
}
