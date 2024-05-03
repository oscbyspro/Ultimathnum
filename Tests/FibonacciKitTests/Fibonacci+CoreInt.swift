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
// MARK: * Fibonacci x Core Int
//*============================================================================*

extension FibonacciTests {

    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    private static let coreIntList: [any SystemsInteger.Type] = [
        IX .self,
        I8 .self,
        I16.self,
        I32.self,
        I64.self,
        UX .self,
        U8 .self,
        U16.self,
        U32.self,
        U64.self,
    ]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testCoreInt() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Case<T>.checkInstancesNearZeroIndex(Test())
        }
        
        for type in Self.coreIntList {
            whereIs(type)
        }
    }
    
    func testCoreIntLimit() {
        if  let (item) = Test().some(try? Fibonacci<I8>(10)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).same(
                index:   10,
                element: 00000000000000000055,
                next:    00000000000000000089
            )
        }
        
        if  let (item) = Test().some(try? Fibonacci<U8>(12)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).same(
                index:   12,
                element: 00000000000000000144,
                next:    00000000000000000233
            )
        }
                
        if  let (item) = Test().some(try? Fibonacci<I16>(22)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).same(
                index:   22,
                element: 00000000000000017711,
                next:    00000000000000028657
            )
        }
        
        if  let (item) = Test().some(try? Fibonacci<U16>(23)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).same(
                index:   23,
                element: 00000000000000028657,
                next:    00000000000000046368
            )
        }
        
        if  let (item) = Test().some(try? Fibonacci<I32>(45)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).same(
                index:   45,
                element: 00000000001134903170,
                next:    00000000001836311903
            )
        }
        
        if  let (item) = Test().some(try? Fibonacci<U32>(46)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).same(
                index:   46,
                element: 00000000001836311903,
                next:    00000000002971215073
            )
        }
        
        if  let (item) = Test().some(try? Fibonacci<I64>(91)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).same(
                index:   91,
                element: 04660046610375530309,
                next:    07540113804746346429
            )
        }
        
        if  let (item) = Test().some(try? Fibonacci<U64>(92)) {
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
