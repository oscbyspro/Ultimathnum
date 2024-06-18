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
// MARK: * Shift
//*============================================================================*

final class ShiftTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBitCast() {
        func whereTheValueIs<Value>(_ type: Value.Type) where Value: BinaryInteger {
            typealias T = Shift<Value>
            typealias S = Shift<Value.Signitude>
            typealias M = Shift<Value.Magnitude>
            
            Test().same(T(raw: M(1)).value, 1 as Value)
            Test().same(T(raw: S(2)).value, 2 as Value)
        }
        
        for type in coreSystemsIntegers {
            whereTheValueIs(type)
        }
        
        whereTheValueIs(DoubleInt<I8>.self)
        whereTheValueIs(DoubleInt<U8>.self)
        
        whereTheValueIs(InfiniInt<I8>.self)
        whereTheValueIs(InfiniInt<U8>.self)
    }
    
    func testInitExactly() {
        func whereTheValueIs<Value>(_ type: Value.Type) where Value: BinaryInteger {
            typealias T = Shift<Value>
            
            Test().same(T(exactly: ~0000002)?.value, nil)
            Test().same(T(exactly: ~0000001)?.value, nil)
            Test().same(T(exactly: ~0000000)?.value, nil)
            Test().same(T(exactly: 00000000)?.value, 000)
            Test().same(T(exactly: 00000001)?.value, 001)
            Test().same(T(exactly: 00000002)?.value, 002)
            
            if !Value.size.isInfinite {
                let size = Value(raw: Value.size)
                Test().same(T(exactly: size - 1)?.value, size - 1)
                Test().same(T(exactly: size    )?.value, nil)
                Test().same(T(exactly: size + 1)?.value, nil)
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
    
    func testInitPrune() {
        //=--------------------------------------=
        enum Bad: Error { case code123, code456, code789 }
        //=--------------------------------------=
        func whereTheValueIs<Value>(_ type: Value.Type) where Value: BinaryInteger {
            typealias T = Shift<Value>
            
            Test().failure({ try T(~0000001, prune: Bad.code123).value }, Bad.code123)
            Test().failure({ try T(~0000000, prune: Bad.code456).value }, Bad.code456)
            Test().failure({ try T(~0000000, prune: Bad.code789).value }, Bad.code789)
            Test().success({ try T(00000001, prune: Bad.code123).value }, 00000000001)
            Test().success({ try T(00000002, prune: Bad.code456).value }, 00000000002)
            Test().success({ try T(00000003, prune: Bad.code789).value }, 00000000003)
            
            if !Value.size.isInfinite {
                let size = Value(raw: Value.size)
                Test().success({ try T(size - 1, prune: Bad.code123).value }, size - 0001)
                Test().failure({ try T(size,     prune: Bad.code456).value }, Bad.code456)
                Test().failure({ try T(size + 1, prune: Bad.code789).value }, Bad.code789)
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

//=----------------------------------------------------------------------------=
// MARK: + Edge Cases
//=----------------------------------------------------------------------------=

extension ShiftTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// 2024-06-15: Checks that the inverse of zero is nil.
    func testZeroInvarseIsInvalid() {
        func whereTheValueIs<Value>(_ type: Value.Type) where Value: SystemsInteger {
            Test().nay (Shift.predicate(Value.size))
            Test().same(Shift(0 as Value).inverse(), nil)
            Test().same(Shift(1 as Value).inverse(), Shift(Value(Value.size - 1)))
            Test().same(Shift(2 as Value).inverse(), Shift(Value(Value.size - 2)))
            Test().same(Shift(3 as Value).inverse(), Shift(Value(Value.size - 3)))
            Test().same(Shift(4 as Value).inverse(), Shift(Value(Value.size - 4)))
            Test().same(Shift(5 as Value).inverse(), Shift(Value(Value.size - 5)))
            Test().same(Shift(6 as Value).inverse(), Shift(Value(Value.size - 6)))
            Test().same(Shift(7 as Value).inverse(), Shift(Value(Value.size - 7)))
        }
        
        for type in coreSystemsIntegers {
            whereTheValueIs(type)
        }
        
        whereTheValueIs(DoubleInt<I8>.self)
        whereTheValueIs(DoubleInt<U8>.self)
    }
}