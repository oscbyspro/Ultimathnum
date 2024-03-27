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
            XCTAssertEqual(T(repeating: 0 as Bit),  0 as T)
            XCTAssertEqual(T(repeating: 1 as Bit), ~0 as T)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testBitCountSelection() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            for bit: Bit in [0, 1] {
                for selection: Bit.Selection in [.all, .ascending, .descending] {
                    XCTAssertEqual(( 0 as T).count(bit, option: selection), bit == 0 ? T.bitWidth : 0)
                    XCTAssertEqual((~0 as T).count(bit, option: selection), bit == 1 ? T.bitWidth : 0)
                }
                
                for element: (value: T, bit: Bit) in [(11, 0), (~11, 1)] {
                    XCTAssertEqual(element.value.count(bit, option:        .all), bit == element.bit ? T.bitWidth - 3 : 3)
                    XCTAssertEqual(element.value.count(bit, option:  .ascending), bit == element.bit ?              0 : 2)
                    XCTAssertEqual(element.value.count(bit, option: .descending), bit == element.bit ? T.bitWidth - 4 : 0)
                }
            }
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLeastSignificantBit() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(( T .min).leastSignificantBit, 0 as Bit)
            XCTAssertEqual(( T .max).leastSignificantBit, 1 as Bit)
            XCTAssertEqual((~1 as T).leastSignificantBit, 0 as Bit)
            XCTAssertEqual((~0 as T).leastSignificantBit, 1 as Bit)
            XCTAssertEqual(( 0 as T).leastSignificantBit, 0 as Bit)
            XCTAssertEqual(( 1 as T).leastSignificantBit, 1 as Bit)
            XCTAssertEqual(( 2 as T).leastSignificantBit, 0 as Bit)
            XCTAssertEqual(( 3 as T).leastSignificantBit, 1 as Bit)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
        
    func testInitElements() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            for isSigned in [true, false] {
                Test.elements(Array(ExchangeInt( T.min).bitPattern.source()), isSigned,  isSigned ? T.min : nil)
                Test.elements(Array(ExchangeInt( T.max).bitPattern.source()), isSigned,  T.max)
                
                Test.elements(Array(ExchangeInt( M.min).bitPattern.source()), isSigned,  00000 as T)
                Test.elements(Array(ExchangeInt( M.max).bitPattern.source()), isSigned,  isSigned ? -1 as T : nil as T?)
                Test.elements(Array(ExchangeInt( M.msb).bitPattern.source()), isSigned,  isSigned ?  T .min : nil as T?)
                Test.elements(Array(ExchangeInt(~M.msb).bitPattern.source()), isSigned, ~T.msb)
                
                Test.elements(Array(repeating:  0 as T.Element.Magnitude, count: 2), isSigned, 000 as T?)
                Test.elements(Array(repeating:  1 as T.Element.Magnitude, count: 2), isSigned, nil as T?)
                Test.elements(Array(repeating: ~1 as T.Element.Magnitude, count: 2), isSigned, nil as T?)
                Test.elements(Array(repeating: ~0 as T.Element.Magnitude, count: 2), isSigned, isSigned ? -1 as T : nil as T?)
            }
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            for isSigned in [true, false] {
                Test.elements(Array(ExchangeInt( M.min).bitPattern.source()), isSigned,  00000 as T?)
                Test.elements(Array(ExchangeInt( M.max).bitPattern.source()), isSigned,  isSigned ? nil : T.max as T?)
                Test.elements(Array(ExchangeInt( M.msb).bitPattern.source()), isSigned,  isSigned ? nil : T.msb as T?)
                Test.elements(Array(ExchangeInt(~M.msb).bitPattern.source()), isSigned, ~T.msb as T?)
                
                Test.elements(Array(repeating:  0 as T.Element.Magnitude, count: 2), isSigned, 000 as T?)
                Test.elements(Array(repeating:  1 as T.Element.Magnitude, count: 2), isSigned, nil as T?)
                Test.elements(Array(repeating: ~1 as T.Element.Magnitude, count: 2), isSigned, nil as T?)
                Test.elements(Array(repeating: ~0 as T.Element.Magnitude, count: 2), isSigned, nil as T?)
            }
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testMakeElements() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Test.elements(~1 as T, [~1 as T.Element.Magnitude])
            Test.elements(~0 as T, [~0 as T.Element.Magnitude])
            Test.elements( 0 as T, [ 0 as T.Element.Magnitude])
            Test.elements( 1 as T, [ 1 as T.Element.Magnitude])
            
            Test.elements(~1 as T, [U8(truncating: ~1 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test.elements(~0 as T, [U8(truncating: ~0 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test.elements( 0 as T, [U8(truncating:  0 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            Test.elements( 1 as T, [U8(truncating:  1 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<U8>.size))
            
            Test.elements(~1 as T, [UX(truncating: ~1 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test.elements(~0 as T, [UX(truncating: ~0 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test.elements( 0 as T, [UX(truncating:  0 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
            Test.elements( 1 as T, [UX(truncating:  1 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<UX>.size))
        }

        for type in Self.types {
            whereIs(type)
        }
    }
}
