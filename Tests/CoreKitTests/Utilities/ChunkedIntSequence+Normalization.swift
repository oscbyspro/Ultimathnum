//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import MainIntKit
import TestKit

//*============================================================================*
// MARK: * Chunked Int Sequence x Normalization
//*============================================================================*

extension ChunkedIntSequenceTests {
            
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNormalizeEqualSequences() {
        XCTAssertEqual([0      ],        Array(T(normalizing: [0, 0, 0]        as [U8], isSigned: true,  as: U8.self)))
        XCTAssertEqual([1      ],        Array(T(normalizing: [1, 0, 0]        as [U8], isSigned: true,  as: U8.self)))
        XCTAssertEqual([1, 2   ],        Array(T(normalizing: [1, 2, 0]        as [U8], isSigned: true,  as: U8.self)))
        XCTAssertEqual([1, 2, 3],        Array(T(normalizing: [1, 2, 3]        as [U8], isSigned: true,  as: U8.self)))
        
        XCTAssertEqual([0      ].map(~), Array(T(normalizing: [0, 0, 0].map(~) as [U8], isSigned: true,  as: U8.self)))
        XCTAssertEqual([1      ].map(~), Array(T(normalizing: [1, 0, 0].map(~) as [U8], isSigned: true,  as: U8.self)))
        XCTAssertEqual([1, 2   ].map(~), Array(T(normalizing: [1, 2, 0].map(~) as [U8], isSigned: true,  as: U8.self)))
        XCTAssertEqual([1, 2, 3].map(~), Array(T(normalizing: [1, 2, 3].map(~) as [U8], isSigned: true,  as: U8.self)))
        
        XCTAssertEqual([0      ],        Array(T(normalizing: [0, 0, 0]        as [U8], isSigned: false, as: U8.self)))
        XCTAssertEqual([1      ],        Array(T(normalizing: [1, 0, 0]        as [U8], isSigned: false, as: U8.self)))
        XCTAssertEqual([1, 2   ],        Array(T(normalizing: [1, 2, 0]        as [U8], isSigned: false, as: U8.self)))
        XCTAssertEqual([1, 2, 3],        Array(T(normalizing: [1, 2, 3]        as [U8], isSigned: false, as: U8.self)))
        
        XCTAssertEqual([0, 0, 0].map(~), Array(T(normalizing: [0, 0, 0].map(~) as [U8], isSigned: false, as: U8.self)))
        XCTAssertEqual([1, 0, 0].map(~), Array(T(normalizing: [1, 0, 0].map(~) as [U8], isSigned: false, as: U8.self)))
        XCTAssertEqual([1, 2, 0].map(~), Array(T(normalizing: [1, 2, 0].map(~) as [U8], isSigned: false, as: U8.self)))
        XCTAssertEqual([1, 2, 3].map(~), Array(T(normalizing: [1, 2, 3].map(~) as [U8], isSigned: false, as: U8.self)))
    }
    
    func testNormalizeMinorSequenceAsMajorSequence() {
        XCTAssertEqual([0x0000        ],        Array(T(normalizing: [0, 0, 0, 0]        as [U8], isSigned: true,  as: U16.self)))
        XCTAssertEqual([0x0000        ],        Array(T(normalizing: [0, 0, 0, 0]        as [U8], isSigned: false, as: U16.self)))
        XCTAssertEqual([0x0000        ].map(~), Array(T(normalizing: [0, 0, 0, 0].map(~) as [U8], isSigned: true,  as: U16.self)))
        XCTAssertEqual([0x0000, 0x0000].map(~), Array(T(normalizing: [0, 0, 0, 0].map(~) as [U8], isSigned: false, as: U16.self)))
                
        XCTAssertEqual([0x8000                ].map(~), Array(T(normalizing: [0, 0x80, 0, 0, 0, 0].map(~) as [U8], isSigned: true, as: U16.self)))
        XCTAssertEqual([0x0000, 0x0001        ].map(~), Array(T(normalizing: [0, 0, 0x01, 0, 0, 0].map(~) as [U8], isSigned: true, as: U16.self)))
        XCTAssertEqual([0x0000, 0x8000        ].map(~), Array(T(normalizing: [0, 0, 0, 0x80, 0, 0].map(~) as [U8], isSigned: true, as: U16.self)))
        XCTAssertEqual([0x0000, 000000, 0x0001].map(~), Array(T(normalizing: [0, 0, 0, 0, 0x01, 0].map(~) as [U8], isSigned: true, as: U16.self)))
        
        for isSigned in [true, false] {
            XCTAssertEqual([0x8000                ], Array(T(normalizing: [0, 0x80, 0, 0, 0, 0] as [U8], isSigned: isSigned, as: U16.self)))
            XCTAssertEqual([0x0000, 0x0001        ], Array(T(normalizing: [0, 0, 0x01, 0, 0, 0] as [U8], isSigned: isSigned, as: U16.self)))
            XCTAssertEqual([0x0000, 0x8000        ], Array(T(normalizing: [0, 0, 0, 0x80, 0, 0] as [U8], isSigned: isSigned, as: U16.self)))
            XCTAssertEqual([0x0000, 000000, 0x0001], Array(T(normalizing: [0, 0, 0, 0, 0x01, 0] as [U8], isSigned: isSigned, as: U16.self)))
        }
    }
    
    func testNormalizeMajorSequenceAsMinorSequence() {
        XCTAssertEqual([0         ],        Array(T(normalizing: [0, 0]        as [U16], isSigned: true,  as: U8.self)))
        XCTAssertEqual([0         ],        Array(T(normalizing: [0, 0]        as [U16], isSigned: false, as: U8.self)))
        XCTAssertEqual([0         ].map(~), Array(T(normalizing: [0, 0].map(~) as [U16], isSigned: true,  as: U8.self)))
        XCTAssertEqual([0, 0, 0, 0].map(~), Array(T(normalizing: [0, 0].map(~) as [U16], isSigned: false, as: U8.self)))
        
        XCTAssertEqual([0, 0x80         ], Array(T(normalizing: [0x8000, 0x0000, 0x0000] as [U16], isSigned: true, as: U8.self)))
        XCTAssertEqual([0, 0, 0x01      ], Array(T(normalizing: [0x0000, 0x0001, 0x0000] as [U16], isSigned: true, as: U8.self)))
        XCTAssertEqual([0, 0, 0, 0x80   ], Array(T(normalizing: [0x0000, 0x8000, 0x0000] as [U16], isSigned: true, as: U8.self)))
        XCTAssertEqual([0, 0, 0, 0, 0x01], Array(T(normalizing: [0x0000, 0x0000, 0x0001] as [U16], isSigned: true, as: U8.self)))
        
        for isSigned in [true, false] {
            XCTAssertEqual([0, 0x80         ], Array(T(normalizing: [0x8000, 0x0000, 0x0000] as [U16], isSigned: isSigned, as: U8.self)))
            XCTAssertEqual([0, 0, 0x01      ], Array(T(normalizing: [0x0000, 0x0001, 0x0000] as [U16], isSigned: isSigned, as: U8.self)))
            XCTAssertEqual([0, 0, 0, 0x80   ], Array(T(normalizing: [0x0000, 0x8000, 0x0000] as [U16], isSigned: isSigned, as: U8.self)))
            XCTAssertEqual([0, 0, 0, 0, 0x01], Array(T(normalizing: [0x0000, 0x0000, 0x0001] as [U16], isSigned: isSigned, as: U8.self)))
        }
    }
}
