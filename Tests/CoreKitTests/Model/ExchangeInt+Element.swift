//=----------------------------------------------------------------------------=
// This source file is part of the Iltimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Exchange Int x Element
//*============================================================================*

extension ExchangeIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testElement08() {
        Case(Item([1, 2, 3], repeating: nil)).element(000000, is: 0x01 as U8)
        Case(Item([1, 2, 3], repeating: nil)).element(000001, is: 0x02 as U8)
        Case(Item([1, 2, 3], repeating: nil)).element(000002, is: 0x03 as U8)
        Case(Item([1, 2, 3], repeating:   0)).element(123456, is: 0x00 as U8)
        Case(Item([1, 2, 3], repeating:   1)).element(123456, is: 0xff as U8)
        Case(Item([1, 2, 3], repeating:   0)).element(UX.max, is: 0x00 as U8)
        Case(Item([1, 2, 3], repeating:   1)).element(UX.max, is: 0xff as U8)
    }
    
    func testElement16() {
        Case(Item([1, 2, 3], repeating: nil)).element(000000, is: 0x0201 as U16)
        Case(Item([1, 2, 3], repeating:   0)).element(000001, is: 0x0003 as U16)
        Case(Item([1, 2, 3], repeating:   1)).element(000001, is: 0xff03 as U16)
        Case(Item([1, 2, 3], repeating:   0)).element(000002, is: 0x0000 as U16)
        Case(Item([1, 2, 3], repeating:   1)).element(000002, is: 0xffff as U16)
        Case(Item([1, 2, 3], repeating:   0)).element(123456, is: 0x0000 as U16)
        Case(Item([1, 2, 3], repeating:   1)).element(123456, is: 0xffff as U16)
        Case(Item([1, 2, 3], repeating:   0)).element(UX.max, is: 0x0000 as U16)
        Case(Item([1, 2, 3], repeating:   1)).element(UX.max, is: 0xffff as U16)
    }
}
