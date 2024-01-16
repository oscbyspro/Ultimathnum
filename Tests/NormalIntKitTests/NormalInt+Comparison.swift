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
import NormalIntKit
import TestKit

//*============================================================================*
// MARK: * Normal Int x Comparison
//*============================================================================*

extension NormalIntTests {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComparison() {
        Test.comparison( 0 as T,  0 as T,  0 as Signum)
        Test.comparison( 1 as T,  0 as T,  1 as Signum)
        Test.comparison( 0 as T,  1 as T, -1 as Signum)
        Test.comparison( 1 as T,  1 as T,  0 as Signum)
        
        Test.comparison( 0 as T,  0 as T,  0 as Signum)
        Test.comparison( 1 as T,  1 as T,  0 as Signum)
        Test.comparison( 2 as T,  3 as T, -1 as Signum)
        Test.comparison( 3 as T,  2 as T,  1 as Signum)
        
        Test.comparison(T(words:[0, 2, 3, 4] as X), T(words:[1, 2, 3, 4] as X), -1 as Signum)
        Test.comparison(T(words:[1, 0, 3, 4] as X), T(words:[1, 2, 3, 4] as X), -1 as Signum)
        Test.comparison(T(words:[1, 2, 0, 4] as X), T(words:[1, 2, 3, 4] as X), -1 as Signum)
        Test.comparison(T(words:[1, 2, 3, 0] as X), T(words:[1, 2, 3, 4] as X), -1 as Signum)
        Test.comparison(T(words:[0, 2, 3, 4] as X), T(words:[0, 2, 3, 4] as X),  0 as Signum)
        Test.comparison(T(words:[1, 0, 3, 4] as X), T(words:[1, 0, 3, 4] as X),  0 as Signum)
        Test.comparison(T(words:[1, 2, 0, 4] as X), T(words:[1, 2, 0, 4] as X),  0 as Signum)
        Test.comparison(T(words:[1, 2, 3, 0] as X), T(words:[1, 2, 3, 0] as X),  0 as Signum)
        Test.comparison(T(words:[1, 2, 3, 4] as X), T(words:[0, 2, 3, 4] as X),  1 as Signum)
        Test.comparison(T(words:[1, 2, 3, 4] as X), T(words:[1, 0, 3, 4] as X),  1 as Signum)
        Test.comparison(T(words:[1, 2, 3, 4] as X), T(words:[1, 2, 0, 4] as X),  1 as Signum)
        Test.comparison(T(words:[1, 2, 3, 4] as X), T(words:[1, 2, 3, 0] as X),  1 as Signum)
        
        Test.comparison(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[1, 2, 3, 4, 0, 0, 0, 0] as X),  1 as Signum)
        Test.comparison(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[0, 1, 2, 3, 4, 0, 0, 0] as X),  1 as Signum)
        Test.comparison(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X),  0 as Signum)
        Test.comparison(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[0, 0, 0, 1, 2, 3, 4, 0] as X), -1 as Signum)
        Test.comparison(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[0, 0, 0, 0, 1, 2, 3, 4] as X), -1 as Signum)
        
        Test.comparison(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[4, 3, 2, 1, 0, 0, 0, 0] as X),  1 as Signum)
        Test.comparison(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[0, 4, 3, 2, 1, 0, 0, 0] as X),  1 as Signum)
        Test.comparison(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[0, 0, 4, 3, 2, 1, 0, 0] as X),  1 as Signum)
        Test.comparison(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[0, 0, 0, 4, 3, 2, 1, 0] as X), -1 as Signum)
        Test.comparison(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[0, 0, 0, 0, 4, 3, 2, 1] as X), -1 as Signum)
    }
    
    func testHashValue() {
        var union = Set<T>()
        union.insert(T(words:[0, 0, 0, 0] as X))
        union.insert(T(words:[0, 0, 0, 0] as X))
        union.insert(T(words:[1, 0, 0, 0] as X))
        union.insert(T(words:[1, 0, 0, 0] as X))
        union.insert(T(words:[0, 1, 0, 0] as X))
        union.insert(T(words:[0, 1, 0, 0] as X))
        union.insert(T(words:[0, 0, 1, 0] as X))
        union.insert(T(words:[0, 0, 1, 0] as X))
        union.insert(T(words:[0, 0, 0, 1] as X))
        union.insert(T(words:[0, 0, 0, 1] as X))
        XCTAssertEqual(union.count, 5)
    }
}
