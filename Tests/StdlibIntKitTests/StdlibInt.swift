//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit
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
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let min128: StdlibInt = -0x80000000000000000000000000000000
    static let max128: StdlibInt =  0x7fffffffffffffffffffffffffffffff
    static let min256: StdlibInt = -0x8000000000000000000000000000000000000000000000000000000000000000
    static let max256: StdlibInt =  0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMetadata() {
        Test().yay(StdlibInt.isSigned)
        Test().yay(StdlibInt.Magnitude.isSigned)
    }
    
    func testBitCast() {
        for x: StdlibInt in [0, 1, -1, Self.min128, Self.max128, Self.min256, Self.max256] {
            Test().same(StdlibInt(raw: IXL(raw: x)), x)
            Test().same(StdlibInt(raw: UXL(raw: x)), x)
        }
    }
}
