//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import MainIntKit
import TestKit

//*============================================================================*
// MARK: * Normal Int x Addition
//*============================================================================*

extension NormalIntTests {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddition() {
        Test.addition(T( 0 as UX), T( 0 as UX), T(words:[ 0,  0] as [UX]))
        Test.addition(T( 0 as UX), T( 1 as UX), T(words:[ 1,  0] as [UX]))
        Test.addition(T( 0 as UX), T(~1 as UX), T(words:[~1,  0] as [UX]))
        Test.addition(T( 0 as UX), T(~0 as UX), T(words:[~0,  0] as [UX]))
        
        Test.addition(T(~0 as UX), T( 0 as UX), T(words:[~0,  0] as [UX]))
        Test.addition(T(~0 as UX), T( 1 as UX), T(words:[ 0,  1] as [UX]))
        Test.addition(T(~0 as UX), T(~1 as UX), T(words:[~2,  1] as [UX]))
        Test.addition(T(~0 as UX), T(~0 as UX), T(words:[~1,  1] as [UX]))
        
        Test.addition(T(words:[ 0,  0,  0,  0] as X), T(words:[ 1,  2,  3,  0] as X), T(words:[ 1,  2,  3,  0] as X))
        Test.addition(T(words:[~0,  0,  0,  0] as X), T(words:[ 1,  2,  3,  0] as X), T(words:[ 0,  3,  3,  0] as X))
        Test.addition(T(words:[~0, ~0,  0,  0] as X), T(words:[ 1,  2,  3,  0] as X), T(words:[ 0,  2,  4,  0] as X))
        Test.addition(T(words:[~0, ~0, ~0,  0] as X), T(words:[ 1,  2,  3,  0] as X), T(words:[ 0,  2,  3,  1] as X))
        
        Test.addition(T(words:[ 0,  0,  0,  0] as X), T(words:[ 0,  1,  2,  3] as X), T(words:[ 0,  1,  2,  3] as X))
        Test.addition(T(words:[~0,  0,  0,  0] as X), T(words:[ 0,  1,  2,  3] as X), T(words:[~0,  1,  2,  3] as X))
        Test.addition(T(words:[~0, ~0,  0,  0] as X), T(words:[ 0,  1,  2,  3] as X), T(words:[~0,  0,  3,  3] as X))
        Test.addition(T(words:[~0, ~0, ~0,  0] as X), T(words:[ 0,  1,  2,  3] as X), T(words:[~0,  0,  2,  4] as X))
    }
}
