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
// MARK: * Exchange Int x Prefix Length
//*============================================================================*

extension ExchangeIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testPrefixLength() {        
        Test().same([          ], Array(T.prefix([0, 0] as [U8], repeating: 0, count: 0, as: U8.self)))
        Test().same([0         ], Array(T.prefix([0, 0] as [U8], repeating: 0, count: 1, as: U8.self)))
        Test().same([0, 0      ], Array(T.prefix([0, 0] as [U8], repeating: 0, count: 2, as: U8.self)))
        Test().same([0, 0, 0   ], Array(T.prefix([0, 0] as [U8], repeating: 0, count: 3, as: U8.self)))
        Test().same([0, 0, 0, 0], Array(T.prefix([0, 0] as [U8], repeating: 0, count: 4, as: U8.self)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Normalization
    //=------------------------------------------------------------------------=
    
    func testNormalEqualSequence() {
        for bit: Bit in [0, 1] {
            let x = U8(repeating:  bit)
            let y = U8(repeating: ~bit)
            
            Test().same([       ],        T.normalized([x, x, x]        as [U8], repeating: bit, as: U8.self))
            Test().same([1      ],        T.normalized([1, x, x]        as [U8], repeating: bit, as: U8.self))
            Test().same([1, 2   ],        T.normalized([1, 2, x]        as [U8], repeating: bit, as: U8.self))
            Test().same([1, 2, 3],        T.normalized([1, 2, 3]        as [U8], repeating: bit, as: U8.self))
            
            Test().same([       ].map(~), T.normalized([y, y, y].map(~) as [U8], repeating: bit, as: U8.self))
            Test().same([1      ].map(~), T.normalized([1, y, y].map(~) as [U8], repeating: bit, as: U8.self))
            Test().same([1, 2   ].map(~), T.normalized([1, 2, y].map(~) as [U8], repeating: bit, as: U8.self))
            Test().same([1, 2, 3].map(~), T.normalized([1, 2, 3].map(~) as [U8], repeating: bit, as: U8.self))
        }
    }
    
    func testNormalMajorSequence() {
        Test().same([              ],        T.normalized([0, 0, 0, 0]        as [U8], repeating: 0, as:  U16.self))
        Test().same([0x0000, 0x0000],        T.normalized([0, 0, 0, 0]        as [U8], repeating: 1, as:  U16.self))
        Test().same([0x0000, 0x0000].map(~), T.normalized([0, 0, 0, 0].map(~) as [U8], repeating: 0, as:  U16.self))
        Test().same([              ],        T.normalized([0, 0, 0, 0].map(~) as [U8], repeating: 1, as:  U16.self))
        
        Test().same([0x8000                ].map(~), T.normalized([0, 0x80, 0, 0, 0, 0].map(~) as [U8], repeating: 1, as:  U16.self))
        Test().same([0x0000, 0x0001        ].map(~), T.normalized([0, 0, 0x01, 0, 0, 0].map(~) as [U8], repeating: 1, as:  U16.self))
        Test().same([0x0000, 0x8000        ].map(~), T.normalized([0, 0, 0, 0x80, 0, 0].map(~) as [U8], repeating: 1, as:  U16.self))
        Test().same([0x0000, 000000, 0x0001].map(~), T.normalized([0, 0, 0, 0, 0x01, 0].map(~) as [U8], repeating: 1, as:  U16.self))
        
        for bit: Bit in [0, 1] {
            let x = U8(repeating: bit)
            
            Test().same([0x8000                ], T.normalized([0, 0x80, x, x, x, x] as [U8], repeating: bit, as:  U16.self))
            Test().same([0x0000, 0x0001        ], T.normalized([0, 0, 0x01, 0, x, x] as [U8], repeating: bit, as:  U16.self))
            Test().same([0x0000, 0x8000        ], T.normalized([0, 0, 0, 0x80, x, x] as [U8], repeating: bit, as:  U16.self))
            Test().same([0x0000, 000000, 0x0001], T.normalized([0, 0, 0, 0, 0x01, 0] as [U8], repeating: bit, as:  U16.self))
        }
    }
    
    func testNormalMinorSequence() {
        Test().same([          ],        T.normalized([0, 0]        as [U16], repeating: 0, as:  U8.self))
        Test().same([0, 0, 0, 0],        T.normalized([0, 0]        as [U16], repeating: 1, as:  U8.self))
        Test().same([0, 0, 0, 0].map(~), T.normalized([0, 0].map(~) as [U16], repeating: 0, as:  U8.self))
        Test().same([          ].map(~), T.normalized([0, 0].map(~) as [U16], repeating: 1, as:  U8.self))
        
        Test().same([0, 0x80         ], T.normalized([0x8000, 0x0000, 0x0000] as [U16], repeating: 0, as:  U8.self))
        Test().same([0, 0, 0x01      ], T.normalized([0x0000, 0x0001, 0x0000] as [U16], repeating: 0, as:  U8.self))
        Test().same([0, 0, 0, 0x80   ], T.normalized([0x0000, 0x8000, 0x0000] as [U16], repeating: 0, as:  U8.self))
        Test().same([0, 0, 0, 0, 0x01], T.normalized([0x0000, 0x0000, 0x0001] as [U16], repeating: 0, as:  U8.self))
        
        for bit: Bit in [0, 1] {
            let x = U16(repeating: bit) &<< 8
            let xxxxxx = U16(repeating: bit)
            
            Test().same([0, 0x80         ], T.normalized([0x8000, xxxxxx, xxxxxx] as [U16], repeating: bit, as:  U8.self))
            Test().same([0, 0, 0x01      ], T.normalized([0x0000, x|0x01, xxxxxx] as [U16], repeating: bit, as:  U8.self))
            Test().same([0, 0, 0, 0x80   ], T.normalized([0x0000, 0x8000, xxxxxx] as [U16], repeating: bit, as:  U8.self))
            Test().same([0, 0, 0, 0, 0x01], T.normalized([0x0000, 0x0000, x|0x01] as [U16], repeating: bit, as:  U8.self))
        }
    }
}
