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
// MARK: * Binary Integer x Count
//*============================================================================*

final class BinaryIntegerTestsOnCount: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBitCountForEachBitSelection() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            //=----------------------------------=
            let relative = IX(raw: T.size)
            //=----------------------------------=
            for bit in [Bit.zero, Bit.one] {
                always: do {
                    Test()     .count( 0 as T, bit, Count(raw: bit.isZero ? relative : IX.zero))
                    Test()     .count(~0 as T, bit, Count(raw: bit == Bit.one  ? relative : IX.zero))
                    Test() .ascending( 0 as T, bit, Count(raw: bit.isZero ? relative : IX.zero))
                    Test() .ascending(~0 as T, bit, Count(raw: bit == Bit.one  ? relative : IX.zero))
                    Test().descending( 0 as T, bit, Count(raw: bit.isZero ? relative : IX.zero))
                    Test().descending(~0 as T, bit, Count(raw: bit == Bit.one  ? relative : IX.zero))
                }
                
                for element: (value: T, bit: Bit) in [(11, Bit.zero), (~11, Bit.one)] {
                    Test()     .count(element.value, bit, Count(raw: bit == element.bit ? (relative - 3) : 3 as IX))
                    Test() .ascending(element.value, bit, Count(raw: bit == element.bit ? (000000000000) : 2 as IX))
                    Test().descending(element.value, bit, Count(raw: bit == element.bit ? (relative - 4) : 0 as IX))
                }
                
                for element: (value: T, bit: Bit) in [(22, Bit.zero), (~22, Bit.one)] {
                    Test()     .count(element.value, bit, Count(raw: bit == element.bit ? (relative - 3) : 3 as IX))
                    Test() .ascending(element.value, bit, Count(raw: bit == element.bit ? (000000000001) : 0 as IX))
                    Test().descending(element.value, bit, Count(raw: bit == element.bit ? (relative - 5) : 0 as IX))
                }
                
                for element: (value: T, bit: Bit) in [(33, Bit.zero), (~33, Bit.one)] {
                    Test()     .count(element.value, bit, Count(raw: bit == element.bit ? (relative - 2) : 2 as IX))
                    Test() .ascending(element.value, bit, Count(raw: bit == element.bit ? (000000000000) : 1 as IX))
                    Test().descending(element.value, bit, Count(raw: bit == element.bit ? (relative - 6) : 0 as IX))
                }
                
                for element: (value: T, bit: Bit) in [(44, Bit.zero), (~44, Bit.one)] {
                    Test()     .count(element.value, bit, Count(raw: bit == element.bit ? (relative - 3) : 3 as IX))
                    Test() .ascending(element.value, bit, Count(raw: bit == element.bit ? (000000000002) : 0 as IX))
                    Test().descending(element.value, bit, Count(raw: bit == element.bit ? (relative - 6) : 0 as IX))
                }
                            
                for element: (value: T, bit: Bit) in [(55, Bit.zero), (~55, Bit.one)] {
                    Test()     .count(element.value, bit, Count(raw: bit == element.bit ? (relative - 5) : 5 as IX))
                    Test() .ascending(element.value, bit, Count(raw: bit == element.bit ? (000000000000) : 3 as IX))
                    Test().descending(element.value, bit, Count(raw: bit == element.bit ? (relative - 6) : 0 as IX))
                }
            }
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
}
