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
// MARK: * Double Int Layout x Multiplication
//*============================================================================*

extension DoubleIntLayoutTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplication213() {
        func whereTheBaseIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias X = DoubleIntLayout<T>
            typealias Y = TripleIntLayout<T>
            
            Test().same(X(low:  0, high:  0).multiplication( 0 as T), Y(low:  0, mid:  0, high:  0))
            Test().same(X(low:  0, high:  0).multiplication(~0 as T), Y(low:  0, mid:  0, high:  0))
            Test().same(X(low: ~0, high: ~0).multiplication( 0 as T), Y(low:  0, mid:  0, high:  0))
            Test().same(X(low: ~0, high: ~0).multiplication(~0 as T), Y(low:  1, mid: ~0, high: ~1))
            
            Test().same(X(low:  1, high:  2).multiplication( 3 as T), Y(low:  3, mid:  6, high:  0))
            Test().same(X(low:  1, high:  2).multiplication(~3 as T), Y(low: ~3, mid: ~7, high:  1))
            Test().same(X(low: ~1, high: ~2).multiplication( 3 as T), Y(low: ~5, mid: ~6, high:  2))
            Test().same(X(low: ~1, high: ~2).multiplication(~3 as T), Y(low:  8, mid:  6, high: ~5))
        }
        
        for base in Self.basesWhereIsUnsigned {
            whereTheBaseIs(base)
        }
    }
}
