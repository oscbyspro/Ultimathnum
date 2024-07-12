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
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Multiplication
//*============================================================================*

final class BinaryIntegerTestsOnMultiplication: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplication112As08Is111As16() throws {
        func whereIs<A, B>(x08: A.Type, x16: B.Type) where A: SystemsInteger, B: SystemsInteger {
            precondition(A.size == Count(08))
            precondition(B.size == Count(16))
            precondition(A.isSigned == B.isSigned)
            
            var success = U32.zero
            
            for lhs in A.min ... A.max {
                for rhs in A.min ... A.max {
                    let result = lhs.multiplication((rhs))
                    let expectation = B(lhs).times(B(rhs))
            
                    guard !expectation.error else { break }
                    guard result.low  == A.Magnitude(load:    expectation.value) else { break }
                    guard result.high == A(load: expectation.value.down(A.size)) else { break }
                    
                    success += 1
                }
            }
            
            Test().same(success, 256 * 256)
        }
        
        #if DEBUG
        throw XCTSkip("req. release mode")
        #else
        whereIs(x08: I8.self, x16: I16.self)
        whereIs(x08: I8.self, x16: DoubleInt<I8>.self)
        whereIs(x08: U8.self, x16: U16.self)
        whereIs(x08: U8.self, x16: DoubleInt<U8>.self)
        #endif
    }
}
