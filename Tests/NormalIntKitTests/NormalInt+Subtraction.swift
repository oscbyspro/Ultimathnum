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
// MARK: * Normal Int x Subtraction
//*============================================================================*

extension NormalIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtraction() {
        Test.subtraction(T( 0 as UX), T( 0 as UX), T(words:[ 0,  0] as [UX]))
        Test.subtraction(T( 0 as UX), T( 1 as UX), T(words:[~0,  0] as [UX]), true)
        Test.subtraction(T( 0 as UX), T( 2 as UX), T(words:[~1,  0] as [UX]), true)
        Test.subtraction(T( 0 as UX), T( 3 as UX), T(words:[~2,  0] as [UX]), true)
        
        Test.subtraction(T( 1 as UX), T( 0 as UX), T(words:[ 1,  0] as [UX]))
        Test.subtraction(T( 1 as UX), T( 1 as UX), T(words:[ 0,  0] as [UX]))
        Test.subtraction(T( 1 as UX), T( 2 as UX), T(words:[~0,  0] as [UX]), true)
        Test.subtraction(T( 1 as UX), T( 3 as UX), T(words:[~1,  0] as [UX]), true)
        
        Test.subtraction(T(words:[~0, ~0, ~0, ~0] as X), T(words:[ 1,  2,  3,  0] as X), T(words:[~1, ~2, ~3, ~0] as X))
        Test.subtraction(T(words:[ 0, ~0, ~0, ~0] as X), T(words:[ 1,  2,  3,  0] as X), T(words:[~0, ~3, ~3, ~0] as X))
        Test.subtraction(T(words:[ 0,  0, ~0, ~0] as X), T(words:[ 1,  2,  3,  0] as X), T(words:[~0, ~2, ~4, ~0] as X))
        Test.subtraction(T(words:[ 0,  0,  0, ~0] as X), T(words:[ 1,  2,  3,  0] as X), T(words:[~0, ~2, ~3, ~1] as X))
        
        Test.subtraction(T(words:[ 1,  2,  3,  0] as X), T(words:[~0, ~0, ~0, ~0] as X), T(words:[ 2,  2,  3,  0, ~0] as X), true)
        Test.subtraction(T(words:[ 1,  2,  3,  0] as X), T(words:[ 0, ~0, ~0, ~0] as X), T(words:[ 1,  3,  3,  0, ~0] as X), true)
        Test.subtraction(T(words:[ 1,  2,  3,  0] as X), T(words:[ 0,  0, ~0, ~0] as X), T(words:[ 1,  2,  4,  0, ~0] as X), true)
        Test.subtraction(T(words:[ 1,  2,  3,  0] as X), T(words:[ 0,  0,  0, ~0] as X), T(words:[ 1,  2,  3,  1, ~0] as X), true)
        
        Test.subtraction(T(words:[~0, ~0, ~0, ~0] as X), T(words:[ 0,  1,  2,  3] as X), T(words:[~0, ~1, ~2, ~3] as X))
        Test.subtraction(T(words:[ 0, ~0, ~0, ~0] as X), T(words:[ 0,  1,  2,  3] as X), T(words:[ 0, ~1, ~2, ~3] as X))
        Test.subtraction(T(words:[ 0,  0, ~0, ~0] as X), T(words:[ 0,  1,  2,  3] as X), T(words:[ 0, ~0, ~3, ~3] as X))
        Test.subtraction(T(words:[ 0,  0,  0, ~0] as X), T(words:[ 0,  1,  2,  3] as X), T(words:[ 0, ~0, ~2, ~4] as X))
        
        Test.subtraction(T(words:[ 0,  1,  2,  3] as X), T(words:[~0, ~0, ~0, ~0] as X), T(words:[ 1,  1,  2,  3, ~0] as X), true)
        Test.subtraction(T(words:[ 0,  1,  2,  3] as X), T(words:[ 0, ~0, ~0, ~0] as X), T(words:[ 0,  2,  2,  3, ~0] as X), true)
        Test.subtraction(T(words:[ 0,  1,  2,  3] as X), T(words:[ 0,  0, ~0, ~0] as X), T(words:[ 0,  1,  3,  3, ~0] as X), true)
        Test.subtraction(T(words:[ 0,  1,  2,  3] as X), T(words:[ 0,  0,  0, ~0] as X), T(words:[ 0,  1,  2,  4, ~0] as X), true)
    }
}
