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
// MARK: * Shift
//*============================================================================*

final class ShiftTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitExactly() {
        func whereValueIs<Value>(_ type: Value.Type) where Value: SystemsInteger {
            typealias T = Shift<Value>
            //=----------------------------------=
            let size = Value(raw: Value.size)
            //=----------------------------------=
            Test().same(T(exactly: ~0000002)?.value, nil)
            Test().same(T(exactly: ~0000001)?.value, nil)
            Test().same(T(exactly: ~0000000)?.value, nil)
            Test().same(T(exactly: 00000000)?.value, 000)
            Test().same(T(exactly: 00000001)?.value, 001)
            Test().same(T(exactly: 00000002)?.value, 002)
            Test().same(T(exactly: size - 1)?.value, size - 1)
            Test().same(T(exactly: size    )?.value, nil)
            Test().same(T(exactly: size + 1)?.value, nil)
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
            typealias T = Shift<Value>
            //=----------------------------------=
            let size = Value(raw: Value.size)
            //=----------------------------------=
            Test().failure({ try T(~0000001, prune: Bad.code123).value }, Bad.code123)
            Test().failure({ try T(~0000000, prune: Bad.code456).value }, Bad.code456)
            Test().failure({ try T(~0000000, prune: Bad.code789).value }, Bad.code789)
            Test().success({ try T(00000001, prune: Bad.code123).value }, 00000000001)
            Test().success({ try T(00000002, prune: Bad.code456).value }, 00000000002)
            Test().success({ try T(00000003, prune: Bad.code789).value }, 00000000003)
            Test().success({ try T(size - 1, prune: Bad.code123).value }, size - 0001)
            Test().failure({ try T(size,     prune: Bad.code456).value }, Bad.code456)
            Test().failure({ try T(size + 1, prune: Bad.code789).value }, Bad.code789)
        }
        
        for type in coreSystemsIntegers {
            whereValueIs(type)
        }
    }
}
