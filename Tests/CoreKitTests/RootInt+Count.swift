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
        Test().same(T(-6).entropy(), 4 as UX, "010....1")
        Test().same(T(-5).entropy(), 4 as UX, "110....1")
        Test().same(T(-4).entropy(), 3 as UX, "00.....1")
        Test().same(T(-3).entropy(), 3 as UX, "10.....1")
        Test().same(T(-2).entropy(), 2 as UX, "0......1")
        Test().same(T(-1).entropy(), 1 as UX, ".......1")
        Test().same(T( 0).entropy(), 1 as UX, ".......0")
        Test().same(T( 1).entropy(), 2 as UX, "1......0")
        Test().same(T( 2).entropy(), 3 as UX, "01.....0")
        Test().same(T( 3).entropy(), 3 as UX, "11.....0")
        Test().same(T( 4).entropy(), 4 as UX, "001....0")
        Test().same(T( 5).entropy(), 4 as UX, "101....0")
        
        Test().same(T(-0x80000000000000000000000000000000).entropy(), 128)
        Test().same(T( 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF).entropy(), 128)
    }
}
