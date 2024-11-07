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
// MARK: * Binary Integer x Geometry
//*============================================================================*

/// - Important: Please disable code coverage because it is always on by default.
final class BinaryIntegerBenchmarksOnGeometry: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSquareRootsAsU64() {
        typealias T = U64
                
        for power: UX in 0 ..< 1_000_000 {
            blackHole(T(load: power).isqrt())
        }
    }
    
    func testSquareRootsAsU256() {
        typealias T = U256
                
        for power: UX in 0 ..< 1_000_000 {
            blackHole(T(load: power).isqrt())
        }
    }
    
    func testSquareRootsAsUXL() {
        typealias T = UXL
        
        for power: UX in 0 ..< 1_000_000 {
            blackHole(T(load: power).isqrt())
        }
    }
}
