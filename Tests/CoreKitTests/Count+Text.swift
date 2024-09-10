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
// MARK: * Count x Text
//*============================================================================*

final class CountTestsOnText: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDescriptionWhereIsNatural() {
        Test().same(Count(raw: IX( 0)).description, "0")
        Test().same(Count(raw: IX( 1)).description, "1")
        Test().same(Count(raw: IX( 2)).description, "2")
        Test().same(Count(raw: IX( 3)).description, "3")
        Test().same(Count(raw: IX.max).description, "\(IX.max)")
    }
    
    func testDescriptionWhereIsInfinite() {
        Test().same(Count(raw: IX(~0)).description, "log2(&0+1)")
        Test().same(Count(raw: IX(~1)).description, "log2(&0+1)-1")
        Test().same(Count(raw: IX(~2)).description, "log2(&0+1)-2")
        Test().same(Count(raw: IX(~3)).description, "log2(&0+1)-3")
        Test().same(Count(raw: IX.min).description, "log2(&0+1)-\(IX.max)")
    }
}
