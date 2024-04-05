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
        Test().same([          ], Array(T([0, 0] as [U8], repeating: 0, as: U8.self).prefix(0)))
        Test().same([0         ], Array(T([0, 0] as [U8], repeating: 0, as: U8.self).prefix(1)))
        Test().same([0, 0      ], Array(T([0, 0] as [U8], repeating: 0, as: U8.self).prefix(2)))
        Test().same([0, 0, 0   ], Array(T([0, 0] as [U8], repeating: 0, as: U8.self).prefix(3)))
        Test().same([0, 0, 0, 0], Array(T([0, 0] as [U8], repeating: 0, as: U8.self).prefix(4)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Succinct
    //=------------------------------------------------------------------------=
    
    func testSuccinctEqualSequence() {
        Test().same([       ],        Array(T([0, 0, 0]        as [U8], isSigned: true,  as: U8.self).succinct()))
        Test().same([1      ],        Array(T([1, 0, 0]        as [U8], isSigned: true,  as: U8.self).succinct()))
        Test().same([1, 2   ],        Array(T([1, 2, 0]        as [U8], isSigned: true,  as: U8.self).succinct()))
        Test().same([1, 2, 3],        Array(T([1, 2, 3]        as [U8], isSigned: true,  as: U8.self).succinct()))
        
        Test().same([       ].map(~), Array(T([0, 0, 0].map(~) as [U8], isSigned: true,  as: U8.self).succinct()))
        Test().same([1      ].map(~), Array(T([1, 0, 0].map(~) as [U8], isSigned: true,  as: U8.self).succinct()))
        Test().same([1, 2   ].map(~), Array(T([1, 2, 0].map(~) as [U8], isSigned: true,  as: U8.self).succinct()))
        Test().same([1, 2, 3].map(~), Array(T([1, 2, 3].map(~) as [U8], isSigned: true,  as: U8.self).succinct()))
        
        Test().same([       ],        Array(T([0, 0, 0]        as [U8], isSigned: false, as: U8.self).succinct()))
        Test().same([1      ],        Array(T([1, 0, 0]        as [U8], isSigned: false, as: U8.self).succinct()))
        Test().same([1, 2   ],        Array(T([1, 2, 0]        as [U8], isSigned: false, as: U8.self).succinct()))
        Test().same([1, 2, 3],        Array(T([1, 2, 3]        as [U8], isSigned: false, as: U8.self).succinct()))
        
        Test().same([0, 0, 0].map(~), Array(T([0, 0, 0].map(~) as [U8], isSigned: false, as: U8.self).succinct()))
        Test().same([1, 0, 0].map(~), Array(T([1, 0, 0].map(~) as [U8], isSigned: false, as: U8.self).succinct()))
        Test().same([1, 2, 0].map(~), Array(T([1, 2, 0].map(~) as [U8], isSigned: false, as: U8.self).succinct()))
        Test().same([1, 2, 3].map(~), Array(T([1, 2, 3].map(~) as [U8], isSigned: false, as: U8.self).succinct()))
    }
    
    func testSuccinctMajorSequence() {
        Test().same([              ],        Array(T([0, 0, 0, 0]        as [U8], isSigned: true,  as: U16.self).succinct()))
        Test().same([              ],        Array(T([0, 0, 0, 0]        as [U8], isSigned: false, as: U16.self).succinct()))
        Test().same([              ].map(~), Array(T([0, 0, 0, 0].map(~) as [U8], isSigned: true,  as: U16.self).succinct()))
        Test().same([0x0000, 0x0000].map(~), Array(T([0, 0, 0, 0].map(~) as [U8], isSigned: false, as: U16.self).succinct()))
                
        Test().same([0x8000                ].map(~), Array(T([0, 0x80, 0, 0, 0, 0].map(~) as [U8], isSigned: true, as: U16.self).succinct()))
        Test().same([0x0000, 0x0001        ].map(~), Array(T([0, 0, 0x01, 0, 0, 0].map(~) as [U8], isSigned: true, as: U16.self).succinct()))
        Test().same([0x0000, 0x8000        ].map(~), Array(T([0, 0, 0, 0x80, 0, 0].map(~) as [U8], isSigned: true, as: U16.self).succinct()))
        Test().same([0x0000, 000000, 0x0001].map(~), Array(T([0, 0, 0, 0, 0x01, 0].map(~) as [U8], isSigned: true, as: U16.self).succinct()))
        
        for isSigned in [true, false] {
            Test().same([0x8000                ], Array(T([0, 0x80, 0, 0, 0, 0] as [U8], isSigned: isSigned, as: U16.self).succinct()))
            Test().same([0x0000, 0x0001        ], Array(T([0, 0, 0x01, 0, 0, 0] as [U8], isSigned: isSigned, as: U16.self).succinct()))
            Test().same([0x0000, 0x8000        ], Array(T([0, 0, 0, 0x80, 0, 0] as [U8], isSigned: isSigned, as: U16.self).succinct()))
            Test().same([0x0000, 000000, 0x0001], Array(T([0, 0, 0, 0, 0x01, 0] as [U8], isSigned: isSigned, as: U16.self).succinct()))
        }
    }
    
    func testSuccintMinorSequence() {
        Test().same([          ],        Array(T([0, 0]        as [U16], isSigned: true,  as: U8.self).succinct()))
        Test().same([          ],        Array(T([0, 0]        as [U16], isSigned: false, as: U8.self).succinct()))
        Test().same([          ].map(~), Array(T([0, 0].map(~) as [U16], isSigned: true,  as: U8.self).succinct()))
        Test().same([0, 0, 0, 0].map(~), Array(T([0, 0].map(~) as [U16], isSigned: false, as: U8.self).succinct()))
        
        Test().same([0, 0x80         ],  Array(T([0x8000, 0x0000, 0x0000] as [U16], isSigned: true, as: U8.self).succinct()))
        Test().same([0, 0, 0x01      ],  Array(T([0x0000, 0x0001, 0x0000] as [U16], isSigned: true, as: U8.self).succinct()))
        Test().same([0, 0, 0, 0x80   ],  Array(T([0x0000, 0x8000, 0x0000] as [U16], isSigned: true, as: U8.self).succinct()))
        Test().same([0, 0, 0, 0, 0x01],  Array(T([0x0000, 0x0000, 0x0001] as [U16], isSigned: true, as: U8.self).succinct()))
        
        for isSigned in [true, false] {
            Test().same([0, 0x80         ], Array(T([0x8000, 0x0000, 0x0000] as [U16], isSigned: isSigned, as: U8.self).succinct()))
            Test().same([0, 0, 0x01      ], Array(T([0x0000, 0x0001, 0x0000] as [U16], isSigned: isSigned, as: U8.self).succinct()))
            Test().same([0, 0, 0, 0x80   ], Array(T([0x0000, 0x8000, 0x0000] as [U16], isSigned: isSigned, as: U8.self).succinct()))
            Test().same([0, 0, 0, 0, 0x01], Array(T([0x0000, 0x0000, 0x0001] as [U16], isSigned: isSigned, as: U8.self).succinct()))
        }
    }
}
