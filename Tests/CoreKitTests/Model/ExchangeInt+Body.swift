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
// MARK: * Exchange Int x Body
//*============================================================================*

extension ExchangeIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBody08() {
        Case(Item([       ], repeating: nil)).body(is:[       ] as [U8])
        Case(Item([1      ], repeating: nil)).body(is:[1      ] as [U8])
        Case(Item([1, 2   ], repeating: nil)).body(is:[1, 2   ] as [U8])
        Case(Item([1, 2, 3], repeating: nil)).body(is:[1, 2, 3] as [U8])
    }
    
    func testBody16() {
        Case(Item([       ], repeating: nil)).body(is:[              ] as [U16])
        Case(Item([1      ], repeating:   0)).body(is:[0x0001        ] as [U16])
        Case(Item([1      ], repeating:   1)).body(is:[0xff01        ] as [U16])
        Case(Item([1, 2   ], repeating: nil)).body(is:[0x0201        ] as [U16])
        Case(Item([1, 2, 3], repeating:   0)).body(is:[0x0201, 0x0003] as [U16])
        Case(Item([1, 2, 3], repeating:   1)).body(is:[0x0201, 0xff03] as [U16])
    }
}
