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
        check(Test(), ([1, 2, 3, 4] as [U8]),            ([0x0201, 0x0403] as [U16]))
        check(Test(), ([2, 1, 4, 3] as [U8]).reversed(), ([0x0201, 0x0403] as [U16]).reversed())
        check(Test(), ([3, 4, 1, 2] as [U8]),            ([0x0201, 0x0403] as [U16]).reversed())
        check(Test(), ([4, 3, 2, 1] as [U8]).reversed(), ([0x0201, 0x0403] as [U16]))
    }
    
    func testCustomOrderMinorSequenceAsMajorSequence() {
        check(Test(), ([0x0201, 0x0403] as [U16]),            ([1, 2, 3, 4] as [U8]))
        check(Test(), ([0x0102, 0x0304] as [U16]).reversed(), ([1, 2, 3, 4] as [U8]).reversed())
        check(Test(), ([0x0403, 0x0201] as [U16]).reversed(), ([1, 2, 3, 4] as [U8]))
        check(Test(), ([0x0304, 0x0102] as [U16]),            ([1, 2, 3, 4] as [U8]).reversed())
    }
}
