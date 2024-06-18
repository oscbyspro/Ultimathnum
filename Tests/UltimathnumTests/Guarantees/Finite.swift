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
        //=--------------------------------------=
        enum Bad: Error { case code123 }
        //=--------------------------------------=
        func whereTheValueIs<Value>(_ type: Value.Type) where Value: BinaryInteger {
            typealias T = Finite<Value>
            
            for x in (I8.min...I8.max).lazy.map(Value.init(load:)) {
                if !x.isInfinite {
                    Test().same(T(x).magnitude().value, x.magnitude())
                    Test().same(T(x).value,  x)
                    Test().same(T(unchecked: x) .value, x)
                    Test().same(T(exactly:   x)!.value, x)
                    Test().success({ try T(x, prune: Bad.code123).value }, x)
                }   else {
                    Test().none(T(exactly: x))
                    Test().failure({ try T(x, prune: Bad.code123).value }, Bad.code123)
                }
            }
        }
        
        for type in coreSystemsIntegers {
            whereTheValueIs(type)
        }
        
        whereTheValueIs(DoubleInt<I8>.self)
        whereTheValueIs(DoubleInt<U8>.self)
        
        whereTheValueIs(InfiniInt<I8>.self)
        whereTheValueIs(InfiniInt<U8>.self)
    }
}
