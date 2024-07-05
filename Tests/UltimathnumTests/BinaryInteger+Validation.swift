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
// MARK: * Binary Integer x Validation
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Edge Cases
//=----------------------------------------------------------------------------=

final class BinaryIntegerTestsAboutValidation: XCTestCase {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// 2024-06-20: Signed systems integers should successfully clamp `∞`.
    func testSystemsIntegersCanClampInfiniteValues() {
        func whereIs<A, B>(_ source: A.Type, _ destinaiton: B.Type) where A: UnsignedInteger, B: SystemsInteger {
            precondition(A.size.isInfinite)
            Test().same(B(clamping: A.max    ), B.max)
            Test().same(B(clamping: A.max - 1), B.max)
        }
        
        for source in arbitraryIntegersWhereIsUnsigned {
            for destinaiton in systemsIntegers {
                whereIs(source, destinaiton)
            }
        }
    }
}
