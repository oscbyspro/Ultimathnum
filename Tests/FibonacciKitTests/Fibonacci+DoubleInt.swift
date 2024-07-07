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
    // MARK: Metadata
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
    
    /// - Note: `I8x01` and `U8x01` divide-and-conquer a lot.
    func testDoubleIntLimit8x01() {
        typealias I8x01 = I8
        typealias U8x01 = U8
        
        if  let (item) = Test().some(try? Fibonacci(I8x01("10")!)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).checkSequencePairIsCoprime()
            Case(item).same(
                index:   I8x01("10")!,
                element: I8x01("55")!,
                next:    I8x01("89")!
            )
        }
        
        if  let (item) = Test().some(try? Fibonacci(U8x01("12")!)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).checkSequencePairIsCoprime()
            Case(item).same(
                index:   U8x01("12")!,
                element: U8x01("144")!,
                next:    U8x01("233")!
            )
        }
    }
    
    /// - Note: `I8x02` and `U8x02` divide-and-conquer a lot.
    func testDoubleIntLimit8x02() {
        typealias I8x02 = DoubleInt<I8>
        typealias U8x02 = DoubleInt<U8>
        
        if  let (item) = Test().some(try? Fibonacci(I8x02("22")!)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).checkSequencePairIsCoprime()
            Case(item).same(
                index:   I8x02("22")!,
                element: I8x02("17711")!,
                next:    I8x02("28657")!
            )
        }
        
        if  let (item) = Test().some(try? Fibonacci(U8x02("23")!)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).checkSequencePairIsCoprime()
            Case(item).same(
                index:   U8x02("23")!,
                element: U8x02("28657")!,
                next:    U8x02("46368")!
            )
        }
    }
    
    /// - Note: `I8x04` and `U8x04` divide-and-conquer a lot.
    func testDoubleIntLimit8x04() {
        typealias I8x04 = DoubleInt<DoubleInt<I8>>
        typealias U8x04 = DoubleInt<DoubleInt<U8>>
        
        if  let (item) = Test().some(try? Fibonacci(I8x04("45")!)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).checkSequencePairIsCoprime()
            Case(item).same(
                index:   I8x04("45")!,
                element: I8x04("1134903170")!,
                next:    I8x04("1836311903")!
            )
        }
        
        if  let (item) = Test().some(try? Fibonacci(U8x04("46")!)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).checkSequencePairIsCoprime()
            Case(item).same(
                index:   U8x04("46")!,
                element: U8x04("1836311903")!,
                next:    U8x04("2971215073")!
            )
        }
    }
    
    /// - Note: `I8x08` and `U8x08` divide-and-conquer a lot.
    func testDoubleIntLimit8x08() {
        typealias I8x08 = DoubleInt<DoubleInt<DoubleInt<I8>>>
        typealias U8x08 = DoubleInt<DoubleInt<DoubleInt<U8>>>
        
        if  let (item) = Test().some(try? Fibonacci(I8x08("91")!)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).checkSequencePairIsCoprime()
            Case(item).same(
                index:   I8x08("91")!,
                element: I8x08("04660046610375530309")!,
                next:    I8x08("07540113804746346429")!
            )
        }
        
        if  let (item) = Test().some(try? Fibonacci(U8x08("92")!)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).checkSequencePairIsCoprime()
            Case(item).same(
                index:   U8x08("92")!,
                element: U8x08("07540113804746346429")!,
                next:    U8x08("12200160415121876738")!
            )
        }
    }
    
    /// - Note: `I8x16` and `U8x16` divide-and-conquer a lot.
    func testDoubleIntLimit8x16() {
        typealias I8x16 = DoubleInt<DoubleInt<DoubleInt<DoubleInt<I8>>>>
        typealias U8x16 = DoubleInt<DoubleInt<DoubleInt<DoubleInt<U8>>>>
        
        if  let (item) = Test().some(try? Fibonacci(I8x16("183")!)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).checkSequencePairIsCoprime()
            Case(item).same(
                index:   I8x16("183")!,
                element: I8x16("078569350599398894027251472817058687522")!,
                next:    I8x16("127127879743834334146972278486287885163")!
            )
        }
        
        if  let (item) = Test().some(try? Fibonacci(U8x16("185")!)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).checkSequencePairIsCoprime()
            Case(item).same(
                index:   U8x16("185")!,
                element: U8x16("205697230343233228174223751303346572685")!,
                next:    U8x16("332825110087067562321196029789634457848")!
            )
        }
    }
    
    /// - Note: `I8x32` and `U8x32` divide-and-conquer a lot.
    func testDoubleIntLimit8x32() throws {
        typealias I8x32 = DoubleInt<DoubleInt<DoubleInt<DoubleInt<DoubleInt<I8>>>>>
        typealias U8x32 = DoubleInt<DoubleInt<DoubleInt<DoubleInt<DoubleInt<U8>>>>>
        
        if  let (item) = Test().some(try? Fibonacci(I8x32("367")!)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).checkSequencePairIsCoprime()
            Case(item).same(
                index:   I8x32("367")!,
                element: I8x32("22334640661774067356412331900038009953045351020683823507202893507476314037053")!,
                next:    I8x32("36138207717265885328441519836863123286695915870773021050058862406562749608741")!
            )
        }
        
        if  let (item) = Test().some(try? Fibonacci(U8x32("369")!)) {
            Case(item).checkIsLastIndex()
            Case(item).checkMathInvariants()
            Case(item).checkTextInvariants()
            Case(item).checkSequencePairIsCoprime()
            Case(item).same(
                index:   U8x32("369")!,
                element: U8x32("58472848379039952684853851736901133239741266891456844557261755914039063645794")!,
                next:    U8x32("94611056096305838013295371573764256526437182762229865607320618320601813254535")!
            )
        }
    }
}
