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
// MARK: * Core Int x Bit
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().same(T(0 as Bit),             0 as T)
            Test().same(T(1 as Bit),             1 as T)
            Test().same(T(repeating: 0 as Bit),  0 as T)
            Test().same(T(repeating: 1 as Bit), ~0 as T)
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    func testBitCountSelection() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            for bit: Bit in [0, 1] {
                for selection: Bit.Selection in [.anywhere, .ascending, .descending] {
                    Test().same(( 0 as T).count(bit, where: selection), bit == 0 ? T.size : 0)
                    Test().same((~0 as T).count(bit, where: selection), bit == 1 ? T.size : 0)
                }
                
                for element: (value: T, bit: Bit) in [(11, 0), (~11, 1)] {
                    Test().same(element.value.count(bit, where:   .anywhere), bit == element.bit ? T.size - 3 : 3)
                    Test().same(element.value.count(bit, where:  .ascending), bit == element.bit ?              0 : 2)
                    Test().same(element.value.count(bit, where: .descending), bit == element.bit ? T.size - 4 : 0)
                }
            }
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    func testLeastSignificantBit() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().same(( T .min).leastSignificantBit, 0 as Bit)
            Test().same(( T .max).leastSignificantBit, 1 as Bit)
            Test().same((~1 as T).leastSignificantBit, 0 as Bit)
            Test().same((~0 as T).leastSignificantBit, 1 as Bit)
            Test().same(( 0 as T).leastSignificantBit, 0 as Bit)
            Test().same(( 1 as T).leastSignificantBit, 1 as Bit)
            Test().same(( 2 as T).leastSignificantBit, 0 as Bit)
            Test().same(( 3 as T).leastSignificantBit, 1 as Bit)
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
        
    func testInitBody() {
        func whereIsSigned<T, U>(_ type: T.Type, _ mode: U) where T: SystemsInteger, U: Signedness {
            typealias M = T.Magnitude
            typealias F = Fallible<T>
            
            Test().elements(( T.min).body(), mode, F( T.min, error: !mode.isSigned))
            Test().elements(( T.max).body(), mode, F( T.max))
            
            Test().elements(( M.min).body(), mode, F( T( 0)))
            Test().elements(( M.max).body(), mode, F( T(-1), error: !mode.isSigned))
            Test().elements(( M.msb).body(), mode, F( T.min, error: !mode.isSigned))
            Test().elements((~M.msb).body(), mode, F(~T.msb))
            
            Test().elements(Array(repeating:  0 as T.Element.Magnitude, count: 2), mode, F( 0 as T))
            Test().elements(Array(repeating:  1 as T.Element.Magnitude, count: 2), mode, F( 1 as T, error: true))
            Test().elements(Array(repeating: ~1 as T.Element.Magnitude, count: 2), mode, F(~1 as T, error: true))
            Test().elements(Array(repeating: ~0 as T.Element.Magnitude, count: 2), mode, F(-1 as T, error: !mode.isSigned))
        }
        
        func whereIsUnsigned<T, U>(_ type: T.Type, _ mode: U) where T: SystemsInteger, U: Signedness {
            typealias M = T.Magnitude
            typealias F = Fallible<T>
            
            Test().elements(( M.min).body(), mode, F( T( 0)))
            Test().elements(( M.max).body(), mode, F( T.max, error: mode.isSigned))
            Test().elements(( M.msb).body(), mode, F( T.msb, error: mode.isSigned))
            Test().elements((~M.msb).body(), mode, F(~T.msb))
            
            Test().elements(Array(repeating:  0 as T.Element.Magnitude, count: 2), mode, F( 0 as T))
            Test().elements(Array(repeating:  1 as T.Element.Magnitude, count: 2), mode, F( 1 as T, error: true))
            Test().elements(Array(repeating: ~1 as T.Element.Magnitude, count: 2), mode, F(~1 as T, error: true))
            Test().elements(Array(repeating: ~0 as T.Element.Magnitude, count: 2), mode, F(~0 as T, error: true))
        }
        
        for type in coreSystemsIntegers {
            for mode: any Signedness in [Signed(), Unsigned()] {
                type.isSigned ? whereIsSigned(type, mode) : whereIsUnsigned(type, mode)
            }
        }
    }
    
    func testMakeBody() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().elements(~1 as T, [~1 as T.Element.Magnitude])
            Test().elements(~0 as T, [~0 as T.Element.Magnitude])
            Test().elements( 0 as T, [ 0 as T.Element.Magnitude])
            Test().elements( 1 as T, [ 1 as T.Element.Magnitude])
            
            Test().elements(~1 as T, [U8(load: ~1 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test().elements(~0 as T, [U8(load: ~0 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test().elements( 0 as T, [U8(load:  0 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test().elements( 1 as T, [U8(load:  1 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            
            Test().elements(~1 as T, [UX(load: ~1 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test().elements(~0 as T, [UX(load: ~0 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test().elements( 0 as T, [UX(load:  0 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test().elements( 1 as T, [UX(load:  1 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
        }

        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
}
