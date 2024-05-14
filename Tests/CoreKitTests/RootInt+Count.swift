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
        Test().same(T(-6).count(.entropy), 4 as UX, "010....1")
        Test().same(T(-5).count(.entropy), 4 as UX, "110....1")
        Test().same(T(-4).count(.entropy), 3 as UX, "00.....1")
        Test().same(T(-3).count(.entropy), 3 as UX, "10.....1")
        Test().same(T(-2).count(.entropy), 2 as UX, "0......1")
        Test().same(T(-1).count(.entropy), 1 as UX, ".......1")
        Test().same(T( 0).count(.entropy), 1 as UX, ".......0")
        Test().same(T( 1).count(.entropy), 2 as UX, "1......0")
        Test().same(T( 2).count(.entropy), 3 as UX, "01.....0")
        Test().same(T( 3).count(.entropy), 3 as UX, "11.....0")
        Test().same(T( 4).count(.entropy), 4 as UX, "001....0")
        Test().same(T( 5).count(.entropy), 4 as UX, "101....0")
        
        Test().same(T(-0x80000000000000000000000000000000).count(.entropy), 128)
        Test().same(T( 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF).count(.entropy), 128)
    }
    
    func testNonappendix() {
        Test().same(T(-6).count(.nonappendix), 3 as UX, "010....1")
        Test().same(T(-5).count(.nonappendix), 3 as UX, "110....1")
        Test().same(T(-4).count(.nonappendix), 2 as UX, "00.....1")
        Test().same(T(-3).count(.nonappendix), 2 as UX, "10.....1")
        Test().same(T(-2).count(.nonappendix), 1 as UX, "0......1")
        Test().same(T(-1).count(.nonappendix), 0 as UX, ".......1")
        Test().same(T( 0).count(.nonappendix), 0 as UX, ".......0")
        Test().same(T( 1).count(.nonappendix), 1 as UX, "1......0")
        Test().same(T( 2).count(.nonappendix), 2 as UX, "01.....0")
        Test().same(T( 3).count(.nonappendix), 2 as UX, "11.....0")
        Test().same(T( 4).count(.nonappendix), 3 as UX, "001....0")
        Test().same(T( 5).count(.nonappendix), 3 as UX, "101....0")
        
        Test().same(T(-0x80000000000000000000000000000000).count(.nonappendix), 127)
        Test().same(T( 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF).count(.nonappendix), 127)
    }
}
