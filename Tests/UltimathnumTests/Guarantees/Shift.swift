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
    
    func testBitCast() {
        func whereValueIs<Value>(_ type: Value.Type) where Value: SystemsInteger {
            typealias T = Shift<Value>
            typealias S = Shift<Value.Signitude>
            typealias M = Shift<Value.Magnitude>
            
            Test().same(T(raw: M(1)).value, 1 as T.Value)
            Test().same(T(raw: S(2)).value, 2 as T.Value)
        }
        
        for type in coreSystemsIntegers {
            whereValueIs(type)
        }
    }
    
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

//=----------------------------------------------------------------------------=
// MARK: + Edge Cases
//=----------------------------------------------------------------------------=

extension ShiftTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// 2024-06-15: Checks that the inverse of zero is nil.
    func testZeroInvarseIsInvalid() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().nay (Shift.predicate(T.size))
            Test().same(Shift(0 as T).inverse(), nil)
            Test().same(Shift(1 as T).inverse(), Shift(T(T.size - 1)))
            Test().same(Shift(2 as T).inverse(), Shift(T(T.size - 2)))
            Test().same(Shift(3 as T).inverse(), Shift(T(T.size - 3)))
            Test().same(Shift(4 as T).inverse(), Shift(T(T.size - 4)))
            Test().same(Shift(5 as T).inverse(), Shift(T(T.size - 5)))
            Test().same(Shift(6 as T).inverse(), Shift(T(T.size - 6)))
            Test().same(Shift(7 as T).inverse(), Shift(T(T.size - 7)))
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
}
