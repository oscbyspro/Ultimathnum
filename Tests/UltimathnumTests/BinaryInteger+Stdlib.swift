//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Stdlib
//*============================================================================*

final class BinaryIntegerTestsOnStdlib: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testStdlib() {
        func whereIs<T>(_ type: T.Type, randomness: consuming FuzzerInt, line: UInt = #line)
        where T: BinaryInteger, T: Interoperable, T.Stdlib: Swift.BinaryInteger {
            
            let test  = Test(line: line)
            let range = Esque<T>.min...Esque<T>.max
            
            for _ in 0..<16 {
                var a = T.random(in: range, using: &randomness)
                var b = T.random(in: range, using: &randomness)
                let x = a
                let y = b
                
                test.same(a, x)
                test.same(b, y)
                test.same(T(a.stdlib),   x)
                test.same(T(b.stdlib),   y)
                test.same(T(a.stdlib()), x)
                test.same(T(b.stdlib()), y)
                
                a.stdlib ^= b.stdlib
                b.stdlib ^= a.stdlib
                a.stdlib ^= b.stdlib
                
                test.same(a, y)
                test.same(b, x)
                test.same(T(a.stdlib),   y)
                test.same(T(b.stdlib),   x)
                test.same(T(a.stdlib()), y)
                test.same(T(b.stdlib()), x)
            }
        }
        
        whereIs( IX.self, randomness: fuzzer)
        whereIs( UX.self, randomness: fuzzer)
        whereIs( I8.self, randomness: fuzzer)
        whereIs( U8.self, randomness: fuzzer)
        whereIs(I16.self, randomness: fuzzer)
        whereIs(U16.self, randomness: fuzzer)
        whereIs(I32.self, randomness: fuzzer)
        whereIs(U32.self, randomness: fuzzer)
        whereIs(I64.self, randomness: fuzzer)
        whereIs(U64.self, randomness: fuzzer)
    }
}
