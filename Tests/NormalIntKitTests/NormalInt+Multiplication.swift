//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import NormalIntKit
import TestKit

//*============================================================================*
// MARK: * Normal Int x Multiplication
//*============================================================================*

extension NormalIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplication() {
        Test.multiplication(T(words:[ 1,  2,  3,  4] as X), T(words:[ 0            ] as X), T(words:[ 0,  0,  0,  0,  0] as X))
        Test.multiplication(T(words:[ 1,  2,  3,  4] as X), T(words:[ 1            ] as X), T(words:[ 1,  2,  3,  4,  0] as X))
        Test.multiplication(T(words:[ 1,  2,  3,  4] as X), T(words:[ 2            ] as X), T(words:[ 2,  4,  6,  8,  0] as X))
        Test.multiplication(T(words:[ 1,  2,  3,  4] as X), T(words:[~0            ] as X), T(words:[~0, ~1, ~1, ~1,  3] as X))
        Test.multiplication(T(words:[ 1,  2,  3,  4] as X), T(words:[~1            ] as X), T(words:[~1, ~3, ~4, ~5,  3] as X))
        Test.multiplication(T(words:[ 1,  2,  3,  4] as X), T(words:[~2            ] as X), T(words:[~2, ~5, ~7, ~9,  3] as X))
        
        Test.multiplication(T(words:[ 1,  2,  3,  4] as X), T(words:[ 2,  0,  0,  0] as X), T(words:[ 2,  4,  6,  8,  0,  0,  0,  0] as X))
        Test.multiplication(T(words:[ 1,  2,  3,  4] as X), T(words:[ 0,  2,  0,  0] as X), T(words:[ 0,  2,  4,  6,  8,  0,  0,  0] as X))
        Test.multiplication(T(words:[ 1,  2,  3,  4] as X), T(words:[ 0,  0,  2,  0] as X), T(words:[ 0,  0,  2,  4,  6,  8,  0,  0] as X))
        Test.multiplication(T(words:[ 1,  2,  3,  4] as X), T(words:[ 0,  0,  0,  2] as X), T(words:[ 0,  0,  0,  2,  4,  6,  8,  0] as X))
        Test.multiplication(T(words:[~1, ~2, ~3, ~4] as X), T(words:[ 2,  0,  0,  0] as X), T(words:[~3, ~4, ~6, ~8,  1,  0,  0,  0] as X))
        Test.multiplication(T(words:[~1, ~2, ~3, ~4] as X), T(words:[ 0,  2,  0,  0] as X), T(words:[ 0, ~3, ~4, ~6, ~8,  1,  0,  0] as X))
        Test.multiplication(T(words:[~1, ~2, ~3, ~4] as X), T(words:[ 0,  0,  2,  0] as X), T(words:[ 0,  0, ~3, ~4, ~6, ~8,  1,  0] as X))
        Test.multiplication(T(words:[~1, ~2, ~3, ~4] as X), T(words:[ 0,  0,  0,  2] as X), T(words:[ 0,  0,  0, ~3, ~4, ~6, ~8,  1] as X))
        
        Test.multiplication(T(words:[ 0,  0,  0,  0] as X), T(words:[ 0,  0,  0,  0] as X), T(words:[ 0,  0,  0,  0,  0,  0,  0,  0] as X))
        Test.multiplication(T(words:[ 1,  2,  3,  4] as X), T(words:[ 1,  2,  3,  4] as X), T(words:[ 1,  4, 10, 20, 25, 24, 16,  0] as X))
        Test.multiplication(T(words:[~1, ~2, ~3, ~4] as X), T(words:[~1, ~2, ~3, ~4] as X), T(words:[ 4,  8, 16, 28, 21, 20, 10, ~7] as X))
        Test.multiplication(T(words:[~0, ~0, ~0, ~0] as X), T(words:[~0, ~0, ~0, ~0] as X), T(words:[ 1,  0,  0,  0, ~1, ~0, ~0, ~0] as X))
    }
}
