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
// MARK: * Divisor
//*============================================================================*

final class DivisorTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitExactly() {
        func whereValueIs<Value>(_ type: Value.Type) where Value: SystemsInteger {
            typealias T = Divisor<Value>
            
            Test().same(T(exactly: 0)?.value, nil)
            Test().same(T(exactly: 1)?.value, 001)
            Test().same(T(exactly: 2)?.value, 002)
            Test().same(T(exactly: 3)?.value, 003)
        }
        
        for type in coreSystemsIntegers {
            whereValueIs(type)
        }
    }
    
    func testInitPrune() {
        //=--------------------------------------=
        enum Bad: Error { case code123, code456, code789 }
        //=--------------------------------------=
        func whereValueIs<Value>(_ type: Value.Type) where Value: SystemsInteger {
            typealias T = Divisor<Value>
            
            Test().failure({ try T(0, prune: Bad.code123).value }, Bad.code123)
            Test().failure({ try T(0, prune: Bad.code456).value }, Bad.code456)
            Test().failure({ try T(0, prune: Bad.code789).value }, Bad.code789)
            Test().success({ try T(1, prune: Bad.code123).value }, 00000000001)
            Test().success({ try T(2, prune: Bad.code456).value }, 00000000002)
            Test().success({ try T(3, prune: Bad.code789).value }, 00000000003)
        }
        
        for type in coreSystemsIntegers {
            whereValueIs(type)
        }
    }
}
