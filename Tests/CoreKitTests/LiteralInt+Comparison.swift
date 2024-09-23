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
// MARK: * Literal Int x Comparison
//*============================================================================*

extension LiteralIntTests {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSignum() {
        Test().same(T(-6).signum(), Signum.negative)
        Test().same(T(-5).signum(), Signum.negative)
        Test().same(T(-4).signum(), Signum.negative)
        Test().same(T(-3).signum(), Signum.negative)
        Test().same(T(-2).signum(), Signum.negative)
        Test().same(T(-1).signum(), Signum.negative)
        Test().same(T( 0).signum(), Signum.zero)
        Test().same(T( 1).signum(), Signum.positive)
        Test().same(T( 2).signum(), Signum.positive)
        Test().same(T( 3).signum(), Signum.positive)
        Test().same(T( 4).signum(), Signum.positive)
        Test().same(T( 5).signum(), Signum.positive)
        
        Test().same(T(-0x80000000000000000000000000000000).signum(), Signum.negative)
        Test().same(T( 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF).signum(), Signum.positive)
    }
}
