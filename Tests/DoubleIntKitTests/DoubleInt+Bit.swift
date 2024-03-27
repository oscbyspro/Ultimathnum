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
import TestKit

//*============================================================================*
// MARK: * Double Int x Bit
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            
            XCTAssertEqual(T(repeating: 0 as Bit),  0 as T)
            XCTAssertEqual(T(repeating: 1 as Bit), ~0 as T)
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    func testBitCountSelection() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            
            for bit: Bit in [0, 1] {
                for selection: Bit.Selection in [.all, .ascending, .descending] {
                    XCTAssertEqual(T(low:  0, high:  0).count(bit, option: selection), bit == 0 ? T.bitWidth : 0)
                    XCTAssertEqual(T(low: ~0, high: ~0).count(bit, option: selection), bit == 1 ? T.bitWidth : 0)
                }
                
                for selection: Bit.Selection in [.all] {
                    XCTAssertEqual(T(low:  .lsb, high:  .msb).count(bit, option: selection), bit == 0 ? T.bitWidth - 2 : 2)
                    XCTAssertEqual(T(low:  .lsb, high: ~.msb).count(bit, option: selection), M(low: Base.bitWidth))
                    XCTAssertEqual(T(low: ~.lsb, high:  .msb).count(bit, option: selection), M(low: Base.bitWidth))
                    XCTAssertEqual(T(low: ~.lsb, high: ~.msb).count(bit, option: selection), bit == 1 ? T.bitWidth - 2 : 2)
                }
                
                for selection: Bit.Selection in [.ascending, .descending] {
                    XCTAssertEqual(T(low:  .lsb, high:  .msb).count(bit, option: selection), (bit == 0) ? 0 : 1)
                    XCTAssertEqual(T(low:  .lsb, high: ~.msb).count(bit, option: selection), (bit == 0) == (selection == .ascending) ? 0 : 1)
                    XCTAssertEqual(T(low: ~.lsb, high:  .msb).count(bit, option: selection), (bit == 1) == (selection == .ascending) ? 0 : 1)
                    XCTAssertEqual(T(low: ~.lsb, high: ~.msb).count(bit, option: selection), (bit == 1) ? 0 : 1)
                }
                
                for element: (value: T, bit: Bit) in [(11, 0), (~11, 1)] {
                    XCTAssertEqual(element.value.count(bit, option:        .all), bit == element.bit ? T.bitWidth - 3 : 3)
                    XCTAssertEqual(element.value.count(bit, option:  .ascending), bit == element.bit ?              0 : 2)
                    XCTAssertEqual(element.value.count(bit, option: .descending), bit == element.bit ? T.bitWidth - 4 : 0)
                }
            }
        }

        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    func testLeastSignificantBit() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            
            XCTAssertEqual(( T .min).leastSignificantBit, 0 as Bit)
            XCTAssertEqual(( T .max).leastSignificantBit, 1 as Bit)
            XCTAssertEqual((~1 as T).leastSignificantBit, 0 as Bit)
            XCTAssertEqual((~0 as T).leastSignificantBit, 1 as Bit)
            XCTAssertEqual(( 0 as T).leastSignificantBit, 0 as Bit)
            XCTAssertEqual(( 1 as T).leastSignificantBit, 1 as Bit)
            XCTAssertEqual(( 2 as T).leastSignificantBit, 0 as Bit)
            XCTAssertEqual(( 3 as T).leastSignificantBit, 1 as Bit)
            
            XCTAssertEqual(T(low:  0, high:  0).leastSignificantBit, 0 as Bit)
            XCTAssertEqual(T(low:  0, high: ~0).leastSignificantBit, 0 as Bit)
            XCTAssertEqual(T(low: ~0, high:  0).leastSignificantBit, 1 as Bit)
            XCTAssertEqual(T(low: ~0, high: ~0).leastSignificantBit, 1 as Bit)
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Elements
    //=------------------------------------------------------------------------=
    
    func testInitToken() {
        func whereTheBaseTypeIsSigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
                        
            XCTAssertEqual(T(load:  0 as IX), T(truncating:  0 as IX))
            XCTAssertEqual(T(load: -1 as IX), T(truncating: ~0 as IX))
            XCTAssertEqual(M(load:  0 as IX), M(truncating:  0 as IX))
            XCTAssertEqual(M(load: -1 as IX), M(truncating: ~0 as IX))
            
            XCTAssertEqual(T(load:  0 as UX), T(truncating:  0 as UX))
            XCTAssertEqual(T(load: ~0 as UX), T(truncating: ~0 as UX))
            XCTAssertEqual(M(load:  0 as UX), M(truncating:  0 as UX))
            XCTAssertEqual(M(load: ~0 as UX), M(truncating: ~0 as UX))
        }
        
        for base in Self.bases where base.isSigned {
            whereTheBaseTypeIsSigned(base)
        }
    }
    
    func testMakeToken() {
        func whereTheBaseTypeIsSigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            
            XCTAssertEqual(( 0 as T).load(as: IX.self), IX(truncating:  0 as T))
            XCTAssertEqual((~0 as T).load(as: IX.self), IX(truncating: ~0 as T))
            XCTAssertEqual(( 0 as M).load(as: IX.self), IX(truncating:  0 as M))
            XCTAssertEqual((~0 as M).load(as: IX.self), IX(truncating: ~0 as M))
            
            XCTAssertEqual(( 0 as T).load(as: UX.self), UX(truncating:  0 as T))
            XCTAssertEqual((~0 as T).load(as: UX.self), UX(truncating: ~0 as T))
            XCTAssertEqual(( 0 as M).load(as: UX.self), UX(truncating:  0 as M))
            XCTAssertEqual((~0 as M).load(as: UX.self), UX(truncating: ~0 as M))
        }
        
        for base in Self.bases where base.isSigned {
            whereTheBaseTypeIsSigned(base)
        }
    }
    
    func testInitElement() {
        func whereTheBaseTypeIsSigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            
            Test.load( 0 as T.Element,  0 as T)
            Test.load(-1 as T.Element, ~0 as T)
            Test.load( 0 as T.Element,  0 as M)
            Test.load(-1 as T.Element, ~0 as M)
            
            Test.load( 0 as M.Element,  T( 0 as M.Element))
            Test.load(~0 as M.Element,  T(~0 as M.Element))
            Test.load( 0 as M.Element,  M( 0 as M.Element))
            Test.load(~0 as M.Element,  M(~0 as M.Element))
        }
        
        for base in Self.bases where base.isSigned {
            whereTheBaseTypeIsSigned(base)
        }
    }
    
    func testMakeElement() {
        func whereTheBaseTypeIsSigned<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias T = DoubleInt<Base>
            typealias M = DoubleInt<Base>.Magnitude
            
            Test.load( 0 as T,  0 as T.Element)
            Test.load(-1 as T, ~0 as T.Element)
            Test.load( 0 as T,  0 as M.Element)
            Test.load(-1 as T, ~0 as M.Element)
            
            Test.load( 0 as M,  0 as M.Element)
            Test.load(~0 as M, ~0 as M.Element)
            Test.load( 0 as M,  0 as M.Element)
            Test.load(~0 as M, ~0 as M.Element)
        }
        
        for base in Self.bases where base.isSigned {
            whereTheBaseTypeIsSigned(base)
        }
    }
    
    func testInitElements() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            let count = MemoryLayout<T>.size / MemoryLayout<T.Element>.stride
            for isSigned in [true, false] {
                Test.elements(Array(ExchangeInt( T.min).bitPattern.source()), isSigned,  isSigned ? T.min : nil)
                Test.elements(Array(ExchangeInt( T.max).bitPattern.source()), isSigned,  T.max)
                
                Test.elements(Array(ExchangeInt( M.min).bitPattern.source()), isSigned,  00000 as T)
                Test.elements(Array(ExchangeInt( M.max).bitPattern.source()), isSigned,  isSigned ? -1 as T : nil as T?)
                Test.elements(Array(ExchangeInt( M.msb).bitPattern.source()), isSigned,  isSigned ?  T .min : nil as T?)
                Test.elements(Array(ExchangeInt(~M.msb).bitPattern.source()), isSigned, ~T.msb)
                
                Test.elements(Array(repeating:  0 as T.Element.Magnitude, count: 1 + count), isSigned, 000 as T?)
                Test.elements(Array(repeating:  1 as T.Element.Magnitude, count: 1 + count), isSigned, nil as T?)
                Test.elements(Array(repeating: ~1 as T.Element.Magnitude, count: 1 + count), isSigned, nil as T?)
                Test.elements(Array(repeating: ~0 as T.Element.Magnitude, count: 1 + count), isSigned, isSigned ? -1 as T : nil as T?)
            }
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            let count = MemoryLayout<T>.size / MemoryLayout<T.Element>.stride
            for isSigned in [true, false] {
                Test.elements(Array(ExchangeInt( M.min).bitPattern.source()), isSigned,  00000 as T?)
                Test.elements(Array(ExchangeInt( M.max).bitPattern.source()), isSigned,  isSigned ? nil : T.max as T?)
                Test.elements(Array(ExchangeInt( M.msb).bitPattern.source()), isSigned,  isSigned ? nil : T.msb as T?)
                Test.elements(Array(ExchangeInt(~M.msb).bitPattern.source()), isSigned, ~T.msb as T?)
                
                Test.elements(Array(repeating:  0 as T.Element.Magnitude, count: 1 + count), isSigned, 000 as T?)
                Test.elements(Array(repeating:  1 as T.Element.Magnitude, count: 1 + count), isSigned, nil as T?)
                Test.elements(Array(repeating: ~1 as T.Element.Magnitude, count: 1 + count), isSigned, nil as T?)
                Test.elements(Array(repeating: ~0 as T.Element.Magnitude, count: 1 + count), isSigned, nil as T?)
            }
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testMakeElements() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            typealias EX = T.Element.Magnitude
            
            Test.elements(~1 as T, [EX(truncating: ~1 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<EX>.size))
            Test.elements(~0 as T, [EX(truncating: ~0 as T)] + Array(repeating: ~0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<EX>.size))
            Test.elements( 0 as T, [EX(truncating:  0 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<EX>.size))
            Test.elements( 1 as T, [EX(truncating:  1 as T)] + Array(repeating:  0, count: (MemoryLayout<T>.size - 1) / MemoryLayout<EX>.size))
            
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
