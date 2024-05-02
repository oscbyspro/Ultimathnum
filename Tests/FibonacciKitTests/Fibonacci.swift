//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import FibonacciKit
import TestKit

//*============================================================================*
// MARK: * Fibonacci
//*============================================================================*

final class FibonacciTests: XCTestCase {
    
    //*========================================================================*
    // MARK: * Failure
    //*========================================================================*
    
    enum Failure: Error {
        case any
        case addition
        case division
        case multiplication
        case substraction
    }
    
    //*========================================================================*
    // MARK: * Case
    //*========================================================================*
    
    struct Case<Value: BinaryInteger> {
        
        typealias Item = Fibonacci<Value>
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=

        var test: Test
        var item: Item
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=

        init(_ item: Item, test: Test) {
            self.test = test
            self.item = item
        }
        
        init(_ item: Item, file: StaticString = #file, line: UInt = #line) {
            self.init(item, test: Test(file: file, line: line))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

extension FibonacciTests.Case {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func check(_ element: Value?) {
        test.same(item.element, element)
    }
    
    func check(index: Value, element: Value, next: Value) {
        test.same(item.index,   index,   "index")
        test.same(item.element, element, "element")
        test.same(item.next,    next,    "next")
    }
    
    func checkTextInvariants() {
        test.description(roundtripping: item.element)
        test.description(roundtripping: item.next)
    }
    
    func checkMathInvariants() {
        typealias Failure = FibonacciTests.Failure
        for divisor: Divisor<Value> in [2, 3, 5, 7, 11].map(Divisor.init) {
            always: do {
                var a = item
                let b = try Item(a.index.quotient(divisor).prune(Failure.division))
                try a.decrement(by: b)
                let c = try item.next.division(Divisor(b.next)!).prune(Failure.division)
                let d = try b.element.times(a.element).prune(Failure.multiplication)
                let e = try c.quotient.minus(a.next).times(b.next).plus(c.remainder).prune(Failure.any)
                try a.increment(by: b)
                test.same(d, e, "arithmetic invariant error")
                check(index: a.index, element: a.element, next: a.next)
                
            }   catch let error {
                test.fail("unexpected arithmetic failure: \(error)")
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Min, Max
    //=------------------------------------------------------------------------=
    
    func checkIsAtZeroIndex() {
        test.same(item.index, Value.zero)
        
        var copy = self
        copy.test.success({ try copy.item.double() })
        copy.check(index: item.index, element: item.element, next: item.next)
        
        copy = self
        copy.test.failure({ try copy.item.decrement() })
        copy.check(index: item.index, element: item.element, next: item.next)
    }
    
    func checkIsLastIndex() {
        var copy = copy self
        copy.test.failure({ try copy.item.double() })
        copy.check(index: item.index, element: item.element, next: item.next)
        
        copy = self
        copy.test.failure({ try copy.item.increment() })
        copy.check(index: item.index, element: item.element, next: item.next)
    }
    
    static func checkInstancesNearZeroIndex(_ test: Test, invariants: Bool = true) {
        func make(_ item: Item) -> Self {
            Self(item, test: test)
        }
        
        if  Value.isSigned {
            test.failure({ try Item(-1) })
            test.failure({ try Item(-2) })
            test.failure({ try Item(-3) })
            test.failure({ try Item(-4) })
            test.failure({ try Item(-5) })
        }
        
        zero: do {
            make(    Item( )).checkIsAtZeroIndex()
            make(try Item(0)).checkIsAtZeroIndex()
        }   catch {
            test.fail(error.localizedDescription)
        }
        
        index: do {
            make(    Item( )).check(index: 0, element: 0, next: 1)
            make(try Item(0)).check(index: 0, element: 0, next: 1)
            make(try Item(1)).check(index: 1, element: 1, next: 1)
            make(try Item(2)).check(index: 2, element: 1, next: 2)
            make(try Item(3)).check(index: 3, element: 2, next: 3)
            make(try Item(4)).check(index: 4, element: 3, next: 5)
            make(try Item(5)).check(index: 5, element: 5, next: 8)
        }   catch {
            test.fail(error.localizedDescription)
        }
        
        increment: if let item = test.some(try? Item(0)) {
            var instance = make(item)
            
            instance.check(index: 0, element: 0, next: 1)
            instance.test.success({ try instance.item.increment() })
            instance.check(index: 1, element: 1, next: 1)
            instance.test.success({ try instance.item.increment() })
            instance.check(index: 2, element: 1, next: 2)
            instance.test.success({ try instance.item.increment() })
            instance.check(index: 3, element: 2, next: 3)
            instance.test.success({ try instance.item.increment() })
            instance.check(index: 4, element: 3, next: 5)
            instance.test.success({ try instance.item.increment() })
            instance.check(index: 5, element: 5, next: 8)
        }
        
        decrement: if let item = test.some(try? Item(5)) {
            var instance = make(item)
            
            instance.check(index: 5, element: 5, next: 8)
            instance.test.success({ try instance.item.decrement() })
            instance.check(index: 4, element: 3, next: 5)
            instance.test.success({ try instance.item.decrement() })
            instance.check(index: 3, element: 2, next: 3)
            instance.test.success({ try instance.item.decrement() })
            instance.check(index: 2, element: 1, next: 2)
            instance.test.success({ try instance.item.decrement() })
            instance.check(index: 1, element: 1, next: 1)
            instance.test.success({ try instance.item.decrement() })
            instance.check(index: 0, element: 0, next: 1)
        }
        
        double: if let item = test.some(try? Item(1)) {
            var instance = make(item)
            
            instance.check(index: 1, element: 1, next: 1)
            instance.test.success({ try instance.item.double() })
            instance.check(index: 2, element: 1, next: 2)
            instance.test.success({ try instance.item.double() })
            instance.check(index: 4, element: 3, next: 5)
        }
        
        increment: if let item = test.some(try? Item(1)) {
            var lhs = make(item)
            var rhs = make(item)
            
            lhs.check(index: 01, element: 01, next: 01)
            rhs.check(index: 01, element: 01, next: 01)
            
            test.success({ try lhs.item.increment(by: rhs.item) })
            lhs.check(index: 02, element: 01, next: 02)
            test.success({ try rhs.item.increment(by: lhs.item) })
            rhs.check(index: 03, element: 02, next: 03)
            test.success({ try lhs.item.increment(by: rhs.item) })
            lhs.check(index: 05, element: 05, next: 08)
            test.success({ try rhs.item.increment(by: lhs.item) })
            rhs.check(index: 08, element: 21, next: 34)
        }
        
        decrement: if let low = test.some(try? Item(5)), let high = test.some(try? Item(8)) {
            var lhs = make(low )
            var rhs = make(high)
            
            lhs.check(index: 05, element: 05, next: 08)
            rhs.check(index: 08, element: 21, next: 34)
            
            test.success({ try rhs.item.decrement(by: lhs.item) })
            rhs.check(index: 03, element: 02, next: 03)
            test.success({ try lhs.item.decrement(by: rhs.item) })
            lhs.check(index: 02, element: 01, next: 02)
            test.success({ try rhs.item.decrement(by: lhs.item) })
            rhs.check(index: 01, element: 01, next: 01)
            test.success({ try lhs.item.decrement(by: rhs.item) })
            lhs.check(index: 01, element: 01, next: 01)
            test.success({ try rhs.item.decrement(by: lhs.item) })
            rhs.check(index: 00, element: 00, next: 01)
            test.success({ try lhs.item.decrement(by: rhs.item) })
            lhs.check(index: 01, element: 01, next: 01)
            test.failure({ try rhs.item.decrement(by: lhs.item) })
            rhs.check(index: 00, element: 00, next: 01)
        }
    }
}
