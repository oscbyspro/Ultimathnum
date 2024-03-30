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
// MARK: * Tuple Binary Integer x Multiplication
//*============================================================================*

extension TupleBinaryIntegerTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplication213() {
        func whereTheBaseIs<Base>(_ type: Base.Type) where Base: SystemsInteger & UnsignedInteger {
            typealias X2 = DoubleIntLayout<Base>
            typealias X3 = TripleIntLayout<Base>
            
            Test.multiplication213(X2(low:  0, high:  0),  0 as Base, X3(low:  0, mid:  0, high:  0))
            Test.multiplication213(X2(low:  0, high:  0), ~0 as Base, X3(low:  0, mid:  0, high:  0))
            Test.multiplication213(X2(low: ~0, high: ~0),  0 as Base, X3(low:  0, mid:  0, high:  0))
            Test.multiplication213(X2(low: ~0, high: ~0), ~0 as Base, X3(low:  1, mid: ~0, high: ~1))

            Test.multiplication213(X2(low:  1, high:  2),  3 as Base, X3(low:  3, mid:  6, high:  0))
            Test.multiplication213(X2(low:  1, high:  2), ~3 as Base, X3(low: ~3, mid: ~7, high:  1))
            Test.multiplication213(X2(low: ~1, high: ~2),  3 as Base, X3(low: ~5, mid: ~6, high:  2))
            Test.multiplication213(X2(low: ~1, high: ~2), ~3 as Base, X3(low:  8, mid:  6, high: ~5))
        }
        
        for base in Self.basesWhereIsUnsigned {
            whereTheBaseIs(base)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    static func multiplication213<Base>(
        _ lhs: DoubleIntLayout<Base>, 
        _ rhs: Base,
        _ expectation: TripleIntLayout<Base>,
        _ test: Test = .init()
    )   where Base: SystemsInteger & UnsignedInteger {
        test.same(TBI.multiplying213(lhs, by: rhs), expectation)
    }
}
