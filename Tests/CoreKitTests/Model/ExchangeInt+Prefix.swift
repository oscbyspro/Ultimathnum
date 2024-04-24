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
// MARK: * Exchange Int x Prefix
//*============================================================================*

extension ExchangeIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testPrefix08() {
        Case(Item([1, 2, 3], repeating: nil)).prefix(0, is:[                      ] as [U8])
        Case(Item([1, 2, 3], repeating: nil)).prefix(1, is:[0x01                  ] as [U8])
        Case(Item([1, 2, 3], repeating: nil)).prefix(2, is:[0x01, 0x02            ] as [U8])
        Case(Item([1, 2, 3], repeating: nil)).prefix(3, is:[0x01, 0x02, 0x03      ] as [U8])
        Case(Item([1, 2, 3], repeating:   0)).prefix(4, is:[0x01, 0x02, 0x03, 0x00] as [U8])
        Case(Item([1, 2, 3], repeating:   1)).prefix(4, is:[0x01, 0x02, 0x03, 0xff] as [U8])
    }
    
    func testPrefix16() {
        Case(Item([1, 2, 3], repeating: nil)).prefix(0, is:[                              ] as [U16])
        Case(Item([1, 2, 3], repeating: nil)).prefix(1, is:[0x0201                        ] as [U16])
        Case(Item([1, 2, 3], repeating:   0)).prefix(2, is:[0x0201, 0x0003                ] as [U16])
        Case(Item([1, 2, 3], repeating:   1)).prefix(2, is:[0x0201, 0xff03                ] as [U16])
        Case(Item([1, 2, 3], repeating:   0)).prefix(3, is:[0x0201, 0x0003, 0x0000        ] as [U16])
        Case(Item([1, 2, 3], repeating:   1)).prefix(3, is:[0x0201, 0xff03, 0xffff        ] as [U16])
        Case(Item([1, 2, 3], repeating:   0)).prefix(4, is:[0x0201, 0x0003, 0x0000, 0x0000] as [U16])
        Case(Item([1, 2, 3], repeating:   1)).prefix(4, is:[0x0201, 0xff03, 0xffff, 0xffff] as [U16])
    }
}
