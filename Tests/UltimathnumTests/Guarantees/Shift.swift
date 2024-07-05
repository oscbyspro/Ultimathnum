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
    
    func testInitExactly() {
        func whereTheValueIs<Value>(_ type: Value.Type) where Value: UnsignedInteger {
            typealias T = Shift<Value>
            
            always: do {
                Test().same(T(exactly: Count(raw:  0 as IX))?.value, Count(0))
                Test().same(T(exactly: Count(raw:  1 as IX))?.value, Count(1))
                Test().same(T(exactly: Count(raw:  2 as IX))?.value, Count(2))
            }
            
            if !Value.size.isInfinite {
                Test().none(T(exactly: Count(raw: ~2 as IX)))
                Test().none(T(exactly: Count(raw: ~1 as IX)))
                Test().none(T(exactly: Count(raw: ~0 as IX)))
            }   else {
                Test().same(T(exactly: Count(raw: ~2 as IX))?.value, Count(raw: ~2 as IX))
                Test().same(T(exactly: Count(raw: ~1 as IX))?.value, Count(raw: ~1 as IX))
                Test().none(T(exactly: Count(raw: ~0 as IX)))
            }
            
            if  let size: IX = Value.size.natural().optional() {
                Test().same(T(exactly: Count(size - 1))?.value, Count(size - 1))
                Test().none(T(exactly: Count(size    )))
                Test().none(T(exactly: Count(size + 1)))
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereTheValueIs(type)
        }
        
        whereTheValueIs(DoubleInt<U8>.self)
        whereTheValueIs(DoubleInt<UX>.self)
        
        whereTheValueIs(InfiniInt<U8>.self)
        whereTheValueIs(InfiniInt<UX>.self)
    }
    
    func testInitPrune() {
        func whereTheValueIs<Value>(_ type: Value.Type) where Value: UnsignedInteger {
            typealias T = Shift<Value>
            
            always: do {
                Test().success({ try T(Count(raw:  0 as IX), prune: Bad.code123).value }, Count(0 as IX))
                Test().success({ try T(Count(raw:  1 as IX), prune: Bad.code456).value }, Count(1 as IX))
                Test().success({ try T(Count(raw:  2 as IX), prune: Bad.code789).value }, Count(2 as IX))
            }
            
            if !Value.size.isInfinite {
                Test().failure({ try T(Count(raw: ~2 as IX), prune: Bad.code123)       }, Bad.code123)
                Test().failure({ try T(Count(raw: ~1 as IX), prune: Bad.code456)       }, Bad.code456)
                Test().failure({ try T(Count(raw: ~0 as IX), prune: Bad.code789)       }, Bad.code789)
            }   else {
                Test().success({ try T(Count(raw: ~2 as IX), prune: Bad.code123).value }, Count(raw: ~2 as IX))
                Test().success({ try T(Count(raw: ~1 as IX), prune: Bad.code456).value }, Count(raw: ~1 as IX))
                Test().failure({ try T(Count(raw: ~0 as IX), prune: Bad.code789)       }, Bad.code789)
            }
            
            if  let size: IX = Value.size.natural().optional() {
                Test().success({ try T(Count(size - 1), prune: Bad.code123).value }, Count(size - 1))
                Test().failure({ try T(Count(size    ), prune: Bad.code456)       }, Bad.code456)
                Test().failure({ try T(Count(size + 1), prune: Bad.code789)       }, Bad.code789)
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereTheValueIs(type)
        }
        
        whereTheValueIs(DoubleInt<U8>.self)
        whereTheValueIs(DoubleInt<UX>.self)
        
        whereTheValueIs(InfiniInt<U8>.self)
        whereTheValueIs(InfiniInt<UX>.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsZero() {
        func whereTheValueIs<Value>(_ type: Value.Type) where Value: UnsignedInteger {
            typealias T = Shift<Value>
            
            for relative: IX in IX(I8.min) ..< IX(I8.max) {
                if  let shift = T(exactly: Count(raw: relative)) {
                    Test().same(shift.isZero, relative.isZero)
                    Test().same(shift.isZero, shift.value.isZero)
                }
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereTheValueIs(type)
        }
        
        whereTheValueIs(DoubleInt<U8>.self)
        whereTheValueIs(DoubleInt<UX>.self)
        
        whereTheValueIs(InfiniInt<U8>.self)
        whereTheValueIs(InfiniInt<UX>.self)
    }
    
    func testIsInfinite() {
        func whereTheValueIs<Value>(_ type: Value.Type) where Value: UnsignedInteger {
            typealias T = Shift<Value>
            
            for relative: IX in IX(I8.min) ..< IX(I8.max) {
                if  let shift = T(exactly: Count(raw: relative)) {
                    Test().same(shift.isInfinite, relative.isNegative)
                    Test().same(shift.isInfinite, shift.value.isInfinite)
                }
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereTheValueIs(type)
        }
        
        whereTheValueIs(DoubleInt<U8>.self)
        whereTheValueIs(DoubleInt<UX>.self)
        
        whereTheValueIs(InfiniInt<U8>.self)
        whereTheValueIs(InfiniInt<UX>.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// - 2024-06-15: Checks that the inverse of zero is nil.
    func testInverse() {
        func whereTheValueIs<Value>(_ type: Value.Type) where Value: UnsignedInteger {
            typealias T = Shift<Value>
            //=----------------------------------=
            let size = IX(raw: Value.size)
            //=----------------------------------=
            Test().none(T.min.inverse())
            Test().none(T(Count(0 as IX)).inverse())
            Test().same(T(Count(1 as IX)).inverse(), Shift(Count(raw: size - 1)))
            Test().same(T(Count(2 as IX)).inverse(), Shift(Count(raw: size - 2)))
            Test().same(T(Count(3 as IX)).inverse(), Shift(Count(raw: size - 3)))
            Test().same(T(Count(4 as IX)).inverse(), Shift(Count(raw: size - 4)))
            Test().same(T(Count(5 as IX)).inverse(), Shift(Count(raw: size - 5)))
            Test().same(T(Count(6 as IX)).inverse(), Shift(Count(raw: size - 6)))
            Test().same(T(Count(7 as IX)).inverse(), Shift(Count(raw: size - 7)))
            
            Test().nay (T.predicate(Value.size))
            Test().none(T(exactly:  Value.size))
            Test().same(T.max.inverse(), Shift(Count(1)))
            Test().same(T(Count(raw: size - 1)).inverse(), Shift(Count(1 as IX)))
            Test().same(T(Count(raw: size - 2)).inverse(), Shift(Count(2 as IX)))
            Test().same(T(Count(raw: size - 3)).inverse(), Shift(Count(3 as IX)))
            Test().same(T(Count(raw: size - 4)).inverse(), Shift(Count(4 as IX)))
            Test().same(T(Count(raw: size - 5)).inverse(), Shift(Count(5 as IX)))
            Test().same(T(Count(raw: size - 6)).inverse(), Shift(Count(6 as IX)))
            Test().same(T(Count(raw: size - 7)).inverse(), Shift(Count(7 as IX)))
            
            if  Value.size.isInfinite {
                Test().same(T(Count(raw: IX.max    )).inverse(), Shift(Count(raw: IX.min    )))
                Test().same(T(Count(raw: IX.max - 1)).inverse(), Shift(Count(raw: IX.min + 1)))
                Test().same(T(Count(raw: IX.min    )).inverse(), Shift(Count(raw: IX.max    )))
                Test().same(T(Count(raw: IX.min + 1)).inverse(), Shift(Count(raw: IX.max - 1)))
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereTheValueIs(type)
        }
        
        whereTheValueIs(DoubleInt<U8>.self)
        whereTheValueIs(DoubleInt<UX>.self)
        
        whereTheValueIs(InfiniInt<U8>.self)
        whereTheValueIs(InfiniInt<UX>.self)
    }
    
    func testNatural() {
        func whereTheValueIs<Value>(_ type: Value.Type) where Value: UnsignedInteger {
            typealias T = Shift<Value>
            //=----------------------------------=
            let size = IX(raw: Value.size)
            //=----------------------------------=
            Test().same(T.min.natural(),             Fallible(0 as IX))
            Test().same(T(Count(0 as IX)).natural(), Fallible(0 as IX))
            Test().same(T(Count(1 as IX)).natural(), Fallible(1 as IX))
            Test().same(T(Count(2 as IX)).natural(), Fallible(2 as IX))
            Test().same(T(Count(3 as IX)).natural(), Fallible(3 as IX))
            Test().same(T(Count(4 as IX)).natural(), Fallible(4 as IX))
            Test().same(T(Count(5 as IX)).natural(), Fallible(5 as IX))
            Test().same(T(Count(6 as IX)).natural(), Fallible(6 as IX))
            Test().same(T(Count(7 as IX)).natural(), Fallible(7 as IX))
            
            Test().nay (T.predicate(Value.size))
            Test().none(T(exactly:  Value.size))
            Test().same(T.max.natural(),                   Fallible(size - 1, error: Value.size.isInfinite))
            Test().same(T(Count(raw: size - 1)).natural(), Fallible(size - 1, error: Value.size.isInfinite))
            Test().same(T(Count(raw: size - 2)).natural(), Fallible(size - 2, error: Value.size.isInfinite))
            Test().same(T(Count(raw: size - 3)).natural(), Fallible(size - 3, error: Value.size.isInfinite))
            Test().same(T(Count(raw: size - 4)).natural(), Fallible(size - 4, error: Value.size.isInfinite))
            Test().same(T(Count(raw: size - 5)).natural(), Fallible(size - 5, error: Value.size.isInfinite))
            Test().same(T(Count(raw: size - 6)).natural(), Fallible(size - 6, error: Value.size.isInfinite))
            Test().same(T(Count(raw: size - 7)).natural(), Fallible(size - 7, error: Value.size.isInfinite))
            
            if  Value.size.isInfinite {
                Test().same(T(Count(raw: IX.max    )).natural(), Fallible(IX.max                 ))
                Test().same(T(Count(raw: IX.max - 1)).natural(), Fallible(IX.max - 1             ))
                Test().same(T(Count(raw: IX.min    )).natural(), Fallible(IX.min,     error: true))
                Test().same(T(Count(raw: IX.min + 1)).natural(), Fallible(IX.min + 1, error: true))
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereTheValueIs(type)
        }
        
        whereTheValueIs(DoubleInt<U8>.self)
        whereTheValueIs(DoubleInt<UX>.self)
        
        whereTheValueIs(InfiniInt<U8>.self)
        whereTheValueIs(InfiniInt<UX>.self)
    }
    
    func testPromoted() {
        func whereTheValueIs<Value>(_ type: Value.Type) where Value: UnsignedInteger {
            typealias T = Shift<Value>
            
            for x:  IX in 0 ..< 255 {
                if  let shift = T(exactly: Count(x)) {
                    Test().same(shift.promoted(), Value(load: x))
                }
            }
            
            if  Value.size.isInfinite {
                Test().same(T.max.promoted(),                   Value.max)
                Test().same(T(Count(raw: ~1 as IX)).promoted(), Value.max)
                Test().same(T(Count(raw: ~2 as IX)).promoted(), Value.max - 1)
                Test().same(T(Count(raw: ~3 as IX)).promoted(), Value.max - 2)
                Test().same(T(Count(raw: ~4 as IX)).promoted(), Value.max - 3)
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereTheValueIs(type)
        }
        
        whereTheValueIs(DoubleInt<U8>.self)
        whereTheValueIs(DoubleInt<UX>.self)
        
        whereTheValueIs(InfiniInt<U8>.self)
        whereTheValueIs(InfiniInt<UX>.self)
    }
}
