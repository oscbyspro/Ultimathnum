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
// MARK: * Binary Integer x Comparison
//*============================================================================*

/// - Important: Please disable code coverage because it is always on by default.
final class BinaryIntegerBenchmarksOnComparison: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testHashOneMillionValuesNearZeroAs008() {
        for pattern in (-500_000 as I32) ..< (500_000 as I32) {
            blackHole(I8 (load: pattern).hashValue)
            blackHole(U8 (load: pattern).hashValue)
        }
    }
    
    func testHashOneMillionValuesNearZeroAs016() {
        for pattern in (-500_000 as I32) ..< (500_000 as I32) {
            blackHole(I16(load: pattern).hashValue)
            blackHole(U16(load: pattern).hashValue)
        }
    }
    
    func testHashOneMillionValuesNearZeroAs032() {
        for pattern in (-500_000 as I32) ..< (500_000 as I32) {
            blackHole(I32(load: pattern).hashValue)
            blackHole(U32(load: pattern).hashValue)
        }
    }
    
    func testHashOneMillionValuesNearZeroAs064() {
        for pattern in (-500_000 as I32) ..< (500_000 as I32) {
            blackHole(I64(load: pattern).hashValue)
            blackHole(U64(load: pattern).hashValue)
        }
    }
    
    func testHashOneMillionValuesNearZeroAs128() {
        for pattern in (-500_000 as I32) ..< (500_000 as I32) {
            blackHole(I128(load: pattern).hashValue)
            blackHole(U128(load: pattern).hashValue)
        }
    }
    
    func testHashOneMillionValuesNearZeroAs256() {
        for pattern in (-500_000 as I32) ..< (500_000 as I32) {
            blackHole(I256(load: pattern).hashValue)
            blackHole(U256(load: pattern).hashValue)
        }
    }
    
    func testHashOneMillionValuesNearZeroAsXL() {
        for pattern in (-500_000 as I32) ..< (500_000 as I32) {
            blackHole(IXL(load: pattern).hashValue)
            blackHole(UXL(load: pattern).hashValue)
        }
    }
}
