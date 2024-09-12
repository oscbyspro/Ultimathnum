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
// MARK: * Binary Integer x Stride
//*============================================================================*

/// - Important: Please disable code coverage because it is always on by default.
final class BinaryIntegerBenchmarksOnStride: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// ###### 2024-09-12 (MacBook Pro, 13-inch, M1, 2020):
    ///
    ///     0.63 seconds
    ///     0.33 seconds after (#88)
    ///
    func testAdvancedByU8IX() {
        for _ in IX.zero ..< 10_000 {
            for start in U8.min...U8.max {
                let a = blackHoleIdentity(U8.min + start)
                let b = blackHoleIdentity(U8.max - start)
                for distance in -IX(a)...IX(b) {
                    precondition(!start.advanced(by: distance).error)
                }
            }
        }
    }
}
