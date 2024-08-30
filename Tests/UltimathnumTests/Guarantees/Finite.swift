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
// MARK: * Finite
//*============================================================================*

final class FiniteTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testForEachByteEntropyExtension() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            typealias G = Finite<T>
            
            for pattern in I8.min...I8.max {
                let value = T(load: pattern)
                
                Test().same(G.predicate(value), !value.isInfinite)
                
                if  let guarantee = G(exactly: value) {
                    Test().same(guarantee.value, value)
                    Test().same(guarantee.magnitude().value, value.magnitude())
                }
            }
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
        
        whereIs(DoubleInt<I8>.self)
        whereIs(DoubleInt<U8>.self)
        
        whereIs(InfiniInt<I8>.self)
        whereIs(InfiniInt<U8>.self)
    }
}
