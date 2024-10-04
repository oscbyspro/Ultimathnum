//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Core Int x Comparison
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Edge Cases
//=----------------------------------------------------------------------------=

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// 2024-06-16: Checks the use of `init(load:)` or similar.
    func testComparisonDoesNotReinterpretNegativeValuesAsUnsigned() {
        Test().comparison(-1 as I32, 0 as U8,  Signum.negative) // OK
        Test().comparison(-1 as I32, 0 as U16, Signum.negative) // OK
        Test().comparison(-1 as I32, 0 as U32, Signum.negative) // OK
        Test().comparison(-1 as I32, 0 as U64, Signum.negative) // :(
    }
}
