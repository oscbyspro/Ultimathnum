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
    // MARK: * Case
    //*========================================================================*
    
    struct Case<Value: BinaryInteger> {
        
        typealias Item = Fibonacci<Value>
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=

        var test: Test
        var item: Item
        var invariants: Bool
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=

        init(_ item: Item, invariants: Bool = true, test: Test) {
            self.test = test
            self.item = item
            self.invariants = invariants
        }
        
        init(_ item: Item, invariants: Bool = true, file: StaticString = #file, line: UInt = #line) {
            self.init(item, invariants: invariants, test: Test(file: file, line: line))
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
    
    func check(index: Value, element: Value, next: Value) {
        test.same(item.index,   index)
        test.same(item.element, element)
        test.same(item.next,    next)
        
        if  invariants {
            self.checkDivisionInvariants()
        }
    }
    
    func checkDivisionInvariants() {
        for divisor: Value in [2, 3, 5, 7].compactMap({ Value.exactly($0).optional() }) {
            brrrrrr: do {
                let a = self.item
                let b = try Item(self.item.index.quotient(divisor).get())
                let c = try Item(a.index.minus(b.index).get())
                let d = try a.next.division(b.next).get()
                let e = try b.element.times(c.element).get()
                let f = try d.quotient.minus(c.next).times(b.next).plus(d.remainder).get()
                self.test.same(e, f, "arithmetic invariant error")
            }   catch let error {
                self.test.fail("unexpected arithmetic failure: \(error)")
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Min, Max
    //=------------------------------------------------------------------------=
    
    func checkIsAtZeroIndex() {
        test.same(item.index, Value.zero)
        
        var copy = self
        copy.test.failure({ try copy.item.decrement() })
        copy.check(index: item.index, element: item.element, next: item.next)
        
        copy = self
        copy.test.success({ try copy.item.double() })
        copy.check(index: item.index, element: item.element, next: item.next)
    }
    
    func checkIsAtLastIndex() {
        var copy = copy self
        copy.test.failure({ try copy.item.double() })
        copy.check(index: item.index, element: item.element, next: item.next)
        
        copy = self
        copy.test.failure({ try copy.item.increment() })
        copy.check(index: item.index, element: item.element, next: item.next)
    }
    
    static func checkInstancesNearZeroIndex(_ test: Test) {
        if  Value.isSigned {
            test.failure({ try Item(-1) })
            test.failure({ try Item(-2) })
            test.failure({ try Item(-3) })
            test.failure({ try Item(-4) })
            test.failure({ try Item(-5) })
        }
        
        zero: do {
            Self(try Item( )).checkIsAtZeroIndex()
            Self(try Item(0)).checkIsAtZeroIndex()
        }   catch {
            test.fail(error.localizedDescription)
        }
        
        index: do {
            Self(try Item( )).check(index: 0, element: 0, next: 1)
            Self(try Item(0)).check(index: 0, element: 0, next: 1)
            Self(try Item(1)).check(index: 1, element: 1, next: 1)
            Self(try Item(2)).check(index: 2, element: 1, next: 2)
            Self(try Item(3)).check(index: 3, element: 2, next: 3)
            Self(try Item(4)).check(index: 4, element: 3, next: 5)
            Self(try Item(5)).check(index: 5, element: 5, next: 8)
        }   catch {
            test.fail(error.localizedDescription)
        }
        
        increment: if let item = test.some(try? Item(0)) {
            var instance = Self(item, test: test)
            
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
            var instance = Self(item, test: test)
            
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
            var instance = Self(item, test: test)
            
            instance.check(index: 1, element: 1, next: 1)
            instance.test.success({ try instance.item.double() })
            instance.check(index: 2, element: 1, next: 2)
            instance.test.success({ try instance.item.double() })
            instance.check(index: 4, element: 3, next: 5)
        }
    }
}
