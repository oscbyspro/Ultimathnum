//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import StdlibIntKit
import TestKit

//*============================================================================*
// MARK: * Stdlib Int
//*============================================================================*

/// A test suite about `StdlibInt`.
///
/// `StdlibInt` forwards all relevant calls to the underlying `InfiniInt<IX>` model.
/// This test suite is, therefore, relatively light-weight. Its purpose it primarily 
/// to ensure that `StdlibInt`'s forwarding rules are correct.
///
final class StdlibIntTests: XCTestCase {
    
    typealias T = StdlibInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMetadata() {
        Test().yay(StdlibInt.isSigned)
        Test().yay(StdlibInt.Magnitude.isSigned)
    }
}
