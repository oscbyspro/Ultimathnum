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
// MARK: * Exchange Int x Custom Order
//*============================================================================*

extension ExchangeIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testCustomOrderMajorSequenceAsMinorSequence() {
        Test().same([1, 2, 3, 4], Array(T(([0x0201, 0x0403] as [U16]),            isSigned: false, as: U8.self).source()))
        Test().same([2, 1, 4, 3], Array(T(([0x0201, 0x0403] as [U16]).reversed(), isSigned: false, as: U8.self).source()).reversed())
        Test().same([3, 4, 1, 2], Array(T(([0x0201, 0x0403] as [U16]).reversed(), isSigned: false, as: U8.self).source()))
        Test().same([4, 3, 2, 1], Array(T(([0x0201, 0x0403] as [U16]),            isSigned: false, as: U8.self).source()).reversed())
    }
    
    func testCustomOrderMinorSequenceAsMajorSequence() {
        Test().same([0x0201, 0x0403], Array(T(([1, 2, 3, 4] as [U8]),            isSigned: false, as: U16.self).source()))
        Test().same([0x0102, 0x0304], Array(T(([1, 2, 3, 4] as [U8]).reversed(), isSigned: false, as: U16.self).source()).reversed())
        Test().same([0x0403, 0x0201], Array(T(([1, 2, 3, 4] as [U8]),            isSigned: false, as: U16.self).source()).reversed())
        Test().same([0x0304, 0x0102], Array(T(([1, 2, 3, 4] as [U8]).reversed(), isSigned: false, as: U16.self).source()))
    }
}
