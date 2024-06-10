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
// MARK: * Finite
//*============================================================================*

final class FiniteTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testForEachByteAsSystemsInteger() {
        //=--------------------------------------=
        enum Bad: Error { case code123 }
        //=--------------------------------------=
        func whereTheValueIs<Value>(_ type: Value.Type) where Value: SystemsInteger {
            typealias T = Finite<Value>
            
            let min = Value.isSigned ? Value(I8.min) : Value(U8.min)
            let max = Value.isSigned ? Value(I8.max) : Value(U8.max)
            
            for x in min ... max {
                Test().same(T(x).magnitude().value, x.magnitude())
                Test().same(T(x).value,  x)
                Test().same(T(unchecked: x) .value, x)
                Test().same(T(exactly:   x)!.value, x)
                Test().success({ try T(x, prune: Bad.code123).value }, x)
            }
        }
        
        for type in coreSystemsIntegers {
            whereTheValueIs(type)
        }
    }
}
