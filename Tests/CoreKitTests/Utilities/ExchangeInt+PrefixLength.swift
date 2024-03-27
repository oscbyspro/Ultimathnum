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
        XCTAssertEqual([          ], Array(T([0, 0] as [U8], repeating: 0, as: U8.self).prefix(0)))
        XCTAssertEqual([0         ], Array(T([0, 0] as [U8], repeating: 0, as: U8.self).prefix(1)))
        XCTAssertEqual([0, 0      ], Array(T([0, 0] as [U8], repeating: 0, as: U8.self).prefix(2)))
        XCTAssertEqual([0, 0, 0   ], Array(T([0, 0] as [U8], repeating: 0, as: U8.self).prefix(3)))
        XCTAssertEqual([0, 0, 0, 0], Array(T([0, 0] as [U8], repeating: 0, as: U8.self).prefix(4)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Succinct
    //=------------------------------------------------------------------------=
    
    func testSuccinctEqualSequence() {
        XCTAssertEqual([       ],        Array(T([0, 0, 0]        as [U8], isSigned: true,  as: U8.self).succinct()))
        XCTAssertEqual([1      ],        Array(T([1, 0, 0]        as [U8], isSigned: true,  as: U8.self).succinct()))
        XCTAssertEqual([1, 2   ],        Array(T([1, 2, 0]        as [U8], isSigned: true,  as: U8.self).succinct()))
        XCTAssertEqual([1, 2, 3],        Array(T([1, 2, 3]        as [U8], isSigned: true,  as: U8.self).succinct()))
        
        XCTAssertEqual([       ].map(~), Array(T([0, 0, 0].map(~) as [U8], isSigned: true,  as: U8.self).succinct()))
        XCTAssertEqual([1      ].map(~), Array(T([1, 0, 0].map(~) as [U8], isSigned: true,  as: U8.self).succinct()))
        XCTAssertEqual([1, 2   ].map(~), Array(T([1, 2, 0].map(~) as [U8], isSigned: true,  as: U8.self).succinct()))
        XCTAssertEqual([1, 2, 3].map(~), Array(T([1, 2, 3].map(~) as [U8], isSigned: true,  as: U8.self).succinct()))
        
        XCTAssertEqual([       ],        Array(T([0, 0, 0]        as [U8], isSigned: false, as: U8.self).succinct()))
        XCTAssertEqual([1      ],        Array(T([1, 0, 0]        as [U8], isSigned: false, as: U8.self).succinct()))
        XCTAssertEqual([1, 2   ],        Array(T([1, 2, 0]        as [U8], isSigned: false, as: U8.self).succinct()))
        XCTAssertEqual([1, 2, 3],        Array(T([1, 2, 3]        as [U8], isSigned: false, as: U8.self).succinct()))
        
        XCTAssertEqual([0, 0, 0].map(~), Array(T([0, 0, 0].map(~) as [U8], isSigned: false, as: U8.self).succinct()))
        XCTAssertEqual([1, 0, 0].map(~), Array(T([1, 0, 0].map(~) as [U8], isSigned: false, as: U8.self).succinct()))
        XCTAssertEqual([1, 2, 0].map(~), Array(T([1, 2, 0].map(~) as [U8], isSigned: false, as: U8.self).succinct()))
        XCTAssertEqual([1, 2, 3].map(~), Array(T([1, 2, 3].map(~) as [U8], isSigned: false, as: U8.self).succinct()))
    }
    
    func testSuccinctMajorSequence() {
        XCTAssertEqual([              ],        Array(T([0, 0, 0, 0]        as [U8], isSigned: true,  as: U16.self).succinct()))
        XCTAssertEqual([              ],        Array(T([0, 0, 0, 0]        as [U8], isSigned: false, as: U16.self).succinct()))
        XCTAssertEqual([              ].map(~), Array(T([0, 0, 0, 0].map(~) as [U8], isSigned: true,  as: U16.self).succinct()))
        XCTAssertEqual([0x0000, 0x0000].map(~), Array(T([0, 0, 0, 0].map(~) as [U8], isSigned: false, as: U16.self).succinct()))
                
        XCTAssertEqual([0x8000                ].map(~), Array(T([0, 0x80, 0, 0, 0, 0].map(~) as [U8], isSigned: true, as: U16.self).succinct()))
        XCTAssertEqual([0x0000, 0x0001        ].map(~), Array(T([0, 0, 0x01, 0, 0, 0].map(~) as [U8], isSigned: true, as: U16.self).succinct()))
        XCTAssertEqual([0x0000, 0x8000        ].map(~), Array(T([0, 0, 0, 0x80, 0, 0].map(~) as [U8], isSigned: true, as: U16.self).succinct()))
        XCTAssertEqual([0x0000, 000000, 0x0001].map(~), Array(T([0, 0, 0, 0, 0x01, 0].map(~) as [U8], isSigned: true, as: U16.self).succinct()))
        
        for isSigned in [true, false] {
            XCTAssertEqual([0x8000                ], Array(T([0, 0x80, 0, 0, 0, 0] as [U8], isSigned: isSigned, as: U16.self).succinct()))
            XCTAssertEqual([0x0000, 0x0001        ], Array(T([0, 0, 0x01, 0, 0, 0] as [U8], isSigned: isSigned, as: U16.self).succinct()))
            XCTAssertEqual([0x0000, 0x8000        ], Array(T([0, 0, 0, 0x80, 0, 0] as [U8], isSigned: isSigned, as: U16.self).succinct()))
            XCTAssertEqual([0x0000, 000000, 0x0001], Array(T([0, 0, 0, 0, 0x01, 0] as [U8], isSigned: isSigned, as: U16.self).succinct()))
        }
    }
    
    func testSuccintMinorSequence() {
        XCTAssertEqual([          ],        Array(T([0, 0]        as [U16], isSigned: true,  as: U8.self).succinct()))
        XCTAssertEqual([          ],        Array(T([0, 0]        as [U16], isSigned: false, as: U8.self).succinct()))
        XCTAssertEqual([          ].map(~), Array(T([0, 0].map(~) as [U16], isSigned: true,  as: U8.self).succinct()))
        XCTAssertEqual([0, 0, 0, 0].map(~), Array(T([0, 0].map(~) as [U16], isSigned: false, as: U8.self).succinct()))
        
        XCTAssertEqual([0, 0x80         ],  Array(T([0x8000, 0x0000, 0x0000] as [U16], isSigned: true, as: U8.self).succinct()))
        XCTAssertEqual([0, 0, 0x01      ],  Array(T([0x0000, 0x0001, 0x0000] as [U16], isSigned: true, as: U8.self).succinct()))
        XCTAssertEqual([0, 0, 0, 0x80   ],  Array(T([0x0000, 0x8000, 0x0000] as [U16], isSigned: true, as: U8.self).succinct()))
        XCTAssertEqual([0, 0, 0, 0, 0x01],  Array(T([0x0000, 0x0000, 0x0001] as [U16], isSigned: true, as: U8.self).succinct()))
        
        for isSigned in [true, false] {
            XCTAssertEqual([0, 0x80         ], Array(T([0x8000, 0x0000, 0x0000] as [U16], isSigned: isSigned, as: U8.self).succinct()))
            XCTAssertEqual([0, 0, 0x01      ], Array(T([0x0000, 0x0001, 0x0000] as [U16], isSigned: isSigned, as: U8.self).succinct()))
            XCTAssertEqual([0, 0, 0, 0x80   ], Array(T([0x0000, 0x8000, 0x0000] as [U16], isSigned: isSigned, as: U8.self).succinct()))
            XCTAssertEqual([0, 0, 0, 0, 0x01], Array(T([0x0000, 0x0000, 0x0001] as [U16], isSigned: isSigned, as: U8.self).succinct()))
        }
    }
}
