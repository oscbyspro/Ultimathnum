//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import FibonacciKit
import TestKit

//*============================================================================*
// MARK: * Fibonacci x Double Int
//*============================================================================*

extension FibonacciTests {

    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    private static let doubleIntList: [any SystemsInteger.Type] = [
        DoubleInt<I8>.self, DoubleInt<DoubleInt<I8>>.self,
        DoubleInt<U8>.self, DoubleInt<DoubleInt<U8>>.self,
        DoubleInt<IX>.self, DoubleInt<DoubleInt<IX>>.self,
        DoubleInt<UX>.self, DoubleInt<DoubleInt<UX>>.self,
    ]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDoubleInt() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Case<T>.checkInstancesNearZeroIndex(Test())
        }
        
        for type in Self.doubleIntList {
            whereIs(type)
        }
    }
    
    func testDoubleIntLimit() {
        if  let (item) = Test().some(try? Fibonacci<DoubleInt<I8>>(22)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).same(
                index:   22,
                element: 17711,
                next:    28657
            )
        }
        
        if  let (item) = Test().some(try? Fibonacci<DoubleInt<DoubleInt<I8>>>(45)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).same(
                index:   45,
                element: 1134903170,
                next:    1836311903
            )
        }
        
        if  let (item) = Test().some(try? Fibonacci<DoubleInt<DoubleInt<DoubleInt<I8>>>>(91)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).same(
                index:   91,
                element: 04660046610375530309,
                next:    07540113804746346429
            )
        }
        
        if  let (item) = Test().some(try? Fibonacci<DoubleInt<U8>>(23)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).same(
                index:   23,
                element: 28657,
                next:    46368
            )
        }
        
        if  let (item) = Test().some(try? Fibonacci<DoubleInt<DoubleInt<U8>>>(46)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).same(
                index:   46,
                element: 1836311903,
                next:    2971215073
            )
        }
        
        if  let (item) = Test().some(try? Fibonacci<DoubleInt<DoubleInt<DoubleInt<U8>>>>(92)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).same(
                index:   92,
                element: 07540113804746346429,
                next:    12200160415121876738
            )
        }
    }
}
