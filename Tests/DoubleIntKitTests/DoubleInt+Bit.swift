//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
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
    // MARK: Tests x Initializers
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
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Accessors
    //=------------------------------------------------------------------------=
    
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
}
