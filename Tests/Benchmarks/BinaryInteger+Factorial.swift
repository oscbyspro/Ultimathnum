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
// MARK: * Binary Integer x Factorial
//*============================================================================*

/// - Important: Please disable code coverage because it is always on by default.
final class BinaryIntegerBenchmarksOnFactorial: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UXL
    //=------------------------------------------------------------------------=
    
    /// ###### 2024-09-06 (MacBook Pro, 13-inch, M1, 2020):
    ///
    /// - `0.12 seconds`
    ///
    func test1e5AsUXL() {
        let value: UXL = blackHoleIdentity(100_000)
        XCTAssertEqual(value.factorial().value.entropy(), Count(1_516_706))
    }
    
    /// ###### 2024-09-06 (MacBook Pro, 13-inch, M1, 2020):
    ///
    /// - `0.40 seconds`
    ///
    func test2e5AsUXL() {
        let value: UXL = blackHoleIdentity(200_000)
        XCTAssertEqual(value.factorial().value.entropy(), Count(3_233_401))
    }
    
    /// ###### 2024-09-06 (MacBook Pro, 13-inch, M1, 2020):
    ///
    /// - `1.32 seconds`
    ///
    func test4e5AsUXL() {
        let value: UXL = blackHoleIdentity(400_000)
        XCTAssertEqual(value.factorial().value.entropy(), Count(6_866_790))
    }
}
