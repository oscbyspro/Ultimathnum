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
// MARK: * Exchange Int x Normalization
//*============================================================================*

extension ExchangeIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNormalization08() {
        for bit: Bit in [0, 1] {
            let a = U8(repeating: bit), b = U8(repeating: bit.toggled())
            
            Case(Item([a, a, a], repeating: bit)).normalized(is:[       ] as [U8])
            Case(Item([1, a, a], repeating: bit)).normalized(is:[1      ] as [U8])
            Case(Item([1, 2, a], repeating: bit)).normalized(is:[1, 2   ] as [U8])
            Case(Item([1, 2, 3], repeating: bit)).normalized(is:[1, 2, 3] as [U8])
            
            Case(Item([b, b, b], repeating: bit)).normalized(is:[b, b, b] as [U8])
            Case(Item([1, b, b], repeating: bit)).normalized(is:[1, b, b] as [U8])
            Case(Item([1, 2, b], repeating: bit)).normalized(is:[1, 2, b] as [U8])
            Case(Item([1, 2, 3], repeating: bit)).normalized(is:[1, 2, 3] as [U8])
        }
    }
    
    func testNormalization16() {
        for bit: Bit in [0, 1] {
            let a = U8 (repeating:  bit), b = U8 (repeating: bit.toggled())
            let x = U16(repeating:  bit), y = U16(repeating: bit.toggled())
            
            Case(Item([a, a, a], repeating: bit)).normalized(is:[                                    ] as [U16])
            Case(Item([1, a, a], repeating: bit)).normalized(is:[(x << 8)|(0x0001)                   ] as [U16])
            Case(Item([1, 2, a], repeating: bit)).normalized(is:[(0x0201)|(0x0000)                   ] as [U16])
            Case(Item([1, 2, 3], repeating: bit)).normalized(is:[(0x0201)|(0x0000), (x << 8)|(0x0003)] as [U16])
            
            Case(Item([b, b, b], repeating: bit)).normalized(is:[(y << 0)|(0x0000), (x << 8)|(y >> 8)] as [U16])
            Case(Item([1, b, b], repeating: bit)).normalized(is:[(y << 8)|(0x0001), (x << 8)|(y >> 8)] as [U16])
            Case(Item([1, 2, b], repeating: bit)).normalized(is:[(0x0201)|(0x0000), (x << 8)|(y >> 8)] as [U16])
            Case(Item([1, 2, 3], repeating: bit)).normalized(is:[(0x0201)|(0x0000), (x << 8)|(0x0003)] as [U16])
        }
    }
}
