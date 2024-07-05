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
// MARK: * Root Int x Count
//*============================================================================*

extension RootIntTests {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testEntropy() {
        Test().same(T(-6).entropy(), Count(4 as IX), "010....1")
        Test().same(T(-5).entropy(), Count(4 as IX), "110....1")
        Test().same(T(-4).entropy(), Count(3 as IX), "00.....1")
        Test().same(T(-3).entropy(), Count(3 as IX), "10.....1")
        Test().same(T(-2).entropy(), Count(2 as IX), "0......1")
        Test().same(T(-1).entropy(), Count(1 as IX), ".......1")
        Test().same(T( 0).entropy(), Count(1 as IX), ".......0")
        Test().same(T( 1).entropy(), Count(2 as IX), "1......0")
        Test().same(T( 2).entropy(), Count(3 as IX), "01.....0")
        Test().same(T( 3).entropy(), Count(3 as IX), "11.....0")
        Test().same(T( 4).entropy(), Count(4 as IX), "001....0")
        Test().same(T( 5).entropy(), Count(4 as IX), "101....0")
        
        Test().same(T(-0x80000000000000000000000000000000).entropy(), Count(128 as IX))
        Test().same(T( 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF).entropy(), Count(128 as IX))
    }
}
