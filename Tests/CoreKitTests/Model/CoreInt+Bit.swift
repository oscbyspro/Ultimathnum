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
                for selection: BitSelection in [.anywhere, .ascending, .descending] {
                    Test().same(( 0 as T).count(bit, where: selection), bit == 0 ? T.bitWidth : 0)
                    Test().same((~0 as T).count(bit, where: selection), bit == 1 ? T.bitWidth : 0)
                }
                
                for element: (value: T, bit: Bit) in [(11, 0), (~11, 1)] {
                    Test().same(element.value.count(bit, where:   .anywhere), bit == element.bit ? T.bitWidth - 3 : 3)
                    Test().same(element.value.count(bit, where:  .ascending), bit == element.bit ?              0 : 2)
                    Test().same(element.value.count(bit, where: .descending), bit == element.bit ? T.bitWidth - 4 : 0)
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
        
    func testInitElements() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias F = Fallible<T>
            
            for isSigned in [true, false] {
                Test().elements(Array(ExchangeInt( T.min).bitPattern.source()), isSigned, F( T.min, error: !isSigned))
                Test().elements(Array(ExchangeInt( T.max).bitPattern.source()), isSigned, F( T.max))
                
                Test().elements(Array(ExchangeInt( M.min).bitPattern.source()), isSigned, F( T( 0)))
                Test().elements(Array(ExchangeInt( M.max).bitPattern.source()), isSigned, F( T(-1), error: !isSigned))
                Test().elements(Array(ExchangeInt( M.msb).bitPattern.source()), isSigned, F( T.min, error: !isSigned))
                Test().elements(Array(ExchangeInt(~M.msb).bitPattern.source()), isSigned, F(~T.msb))
                
                Test().elements(Array(repeating:  0 as T.Element.Magnitude, count: 2), isSigned, F( 0 as T))
                Test().elements(Array(repeating:  1 as T.Element.Magnitude, count: 2), isSigned, F( 1 as T, error: true))
                Test().elements(Array(repeating: ~1 as T.Element.Magnitude, count: 2), isSigned, F(~1 as T, error: true))
                Test().elements(Array(repeating: ~0 as T.Element.Magnitude, count: 2), isSigned, F(-1 as T, error: !isSigned))
            }
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias F = Fallible<T>
            
            for isSigned in [true, false] {
                Test().elements(Array(ExchangeInt( M.min).bitPattern.source()), isSigned, F( T( 0)))
                Test().elements(Array(ExchangeInt( M.max).bitPattern.source()), isSigned, F( T.max, error: isSigned))
                Test().elements(Array(ExchangeInt( M.msb).bitPattern.source()), isSigned, F( T.msb, error: isSigned))
                Test().elements(Array(ExchangeInt(~M.msb).bitPattern.source()), isSigned, F(~T.msb))
                
                Test().elements(Array(repeating:  0 as T.Element.Magnitude, count: 2), isSigned, F( 0 as T))
                Test().elements(Array(repeating:  1 as T.Element.Magnitude, count: 2), isSigned, F( 1 as T, error: true))
                Test().elements(Array(repeating: ~1 as T.Element.Magnitude, count: 2), isSigned, F(~1 as T, error: true))
                Test().elements(Array(repeating: ~0 as T.Element.Magnitude, count: 2), isSigned, F(~0 as T, error: true))
            }
        }
        
        for type in coreSystemsIntegers {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testMakeElements() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test().elements(~1 as T, [~1 as T.Element.Magnitude])
            Test().elements(~0 as T, [~0 as T.Element.Magnitude])
            Test().elements( 0 as T, [ 0 as T.Element.Magnitude])
            Test().elements( 1 as T, [ 1 as T.Element.Magnitude])
            
            Test().elements(~1 as T, [U8(truncating: ~1 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test().elements(~0 as T, [U8(truncating: ~0 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test().elements( 0 as T, [U8(truncating:  0 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test().elements( 1 as T, [U8(truncating:  1 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            
            Test().elements(~1 as T, [UX(truncating: ~1 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test().elements(~0 as T, [UX(truncating: ~0 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test().elements( 0 as T, [UX(truncating:  0 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test().elements( 1 as T, [UX(truncating:  1 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
        }

        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
}
