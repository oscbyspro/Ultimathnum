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
// MARK: * Division
//*============================================================================*

final class DivisionTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBitCast() {
        Test().same(Division<I16, I8>(raw: Division<U16, U8>(quotient: ~0, remainder: ~1)).quotient,  -1)
        Test().same(Division<I16, I8>(raw: Division<U16, U8>(quotient: ~0, remainder: ~1)).remainder, -2)
        Test().same(Division<U16, U8>(raw: Division<I16, I8>(quotient: -1, remainder: -2)).quotient,  ~0)
        Test().same(Division<U16, U8>(raw: Division<I16, I8>(quotient: -1, remainder: -2)).remainder, ~1)
    }
    
    func testComponents() {
        let (quotient, remainder) = Division<I16, I8>(quotient: 1, remainder: 2).components()
        Test().same(quotient,  1)
        Test().same(remainder, 2)
    }
}
