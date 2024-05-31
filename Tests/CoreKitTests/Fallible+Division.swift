//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Fallible x Multiplication
//*============================================================================*

extension FallibleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBinaryIntegerQuotient() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var success = U32.min
            let values8 = (I8.min ... I8.max).lazy.map(T.init(load:))
            
            for lhs in values8 {
                for rhs in values8.lazy.compactMap(Divisor.init(exactly:)) {
                    let expectation: Fallible<T> =  lhs.quotient(rhs)
                    success &+= U32(Bit(lhs.veto(false).quotient(rhs) == expectation))
                    success &+= U32(Bit(lhs.veto(true ).quotient(rhs) == expectation.veto()))
                }
            }
            
            Test().same(success, 2 &* 256 &* 255)
        }
        
        whereIs(I8.self)
        whereIs(U8.self)
    }
    
    func testBinaryIntegerRemainder() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var success = U32.min
            let values8 = (I8.min ... I8.max).lazy.map(T.init(load:))
            
            for lhs in values8 {
                for rhs in values8.lazy.compactMap(Divisor.init(exactly:)) {
                    let expectation = Fallible(lhs.remainder(rhs))
                    success &+= U32(Bit(lhs.veto(false).remainder(rhs) == expectation))
                    success &+= U32(Bit(lhs.veto(true ).remainder(rhs) == expectation.veto()))
                }
            }
            
            Test().same(success, 2 &* 256 &* 255)
        }
        
        whereIs(I8.self)
        whereIs(U8.self)
    }
    
    func testBinaryIntegerDivision() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            var success = U32.min
            let values8 = (I8.min ... I8.max).lazy.map(T.init(load:))
            
            for lhs in values8 {
                for rhs in values8.lazy.compactMap(Divisor.init(exactly:)) {
                    let expectation: Fallible<Division<T, T>> = lhs.division(rhs)
                    success &+= U32(Bit(lhs.veto(false).division(rhs) == expectation))
                    success &+= U32(Bit(lhs.veto(true ).division(rhs) == expectation.veto()))
                }
            }
            
            Test().same(success, 2 &* 256 &* 255)
        }
        
        whereIs(I8.self)
        whereIs(U8.self)
    }
}
