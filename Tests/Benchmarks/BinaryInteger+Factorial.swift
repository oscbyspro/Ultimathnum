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
    ///     0.12 seconds
    ///     0.04 seconds after (#84)
    ///
    func test1e5AsUXL() {
        let index:   UXL = blackHoleIdentity(100_000)
        let element: UXL = index.factorial().unwrap()
        XCTAssertEqual(element.entropy(), Count(1_516_706))
    }
    
    /// ###### 2024-09-06 (MacBook Pro, 13-inch, M1, 2020):
    ///
    ///     0.40 seconds
    ///     0.12 seconds after (#84)
    ///
    func test2e5AsUXL() {
        let index:   UXL = blackHoleIdentity(200_000)
        let element: UXL = index.factorial().unwrap()
        XCTAssertEqual(element.entropy(), Count(3_233_401))
    }
    
    /// ###### 2024-09-06 (MacBook Pro, 13-inch, M1, 2020):
    ///
    ///     1.32 seconds
    ///     0.37 seconds after (#84)
    ///
    func test4e5AsUXL() {
        let index:   UXL = blackHoleIdentity(400_000)
        let element: UXL = index.factorial().unwrap()
        XCTAssertEqual(element.entropy(), Count(6_866_790))
    }
}
