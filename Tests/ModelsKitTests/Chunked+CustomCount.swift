//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import ModelsKit
import MainIntKit
import TestKit

//*============================================================================*
// MARK: * Chunked x Custom Count
//*============================================================================*

extension ChunkedTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testCustomCount32As64() {
        XCTAssertEqual([1, 2   ], Array(Chunked([1, 0, 2, 0] as [U32], isSigned: false, count: nil, as: U64.self)))
        XCTAssertEqual([       ], Array(Chunked([1, 0, 2, 0] as [U32], isSigned: false, count: 000, as: U64.self)))
        XCTAssertEqual([1      ], Array(Chunked([1, 0, 2, 0] as [U32], isSigned: false, count: 001, as: U64.self)))
        XCTAssertEqual([1, 2   ], Array(Chunked([1, 0, 2, 0] as [U32], isSigned: false, count: 002, as: U64.self)))
        XCTAssertEqual([1, 2, 0], Array(Chunked([1, 0, 2, 0] as [U32], isSigned: false, count: 003, as: U64.self)))
    }
    
    func testCustomCount64As32() {
        XCTAssertEqual([1, 0, 2, 0      ], Array(Chunked([1, 2] as [U64], isSigned: false, count: nil, as: U32.self)))
        XCTAssertEqual([                ], Array(Chunked([1, 2] as [U64], isSigned: false, count: 000, as: U32.self)))
        XCTAssertEqual([1               ], Array(Chunked([1, 2] as [U64], isSigned: false, count: 001, as: U32.self)))
        XCTAssertEqual([1, 0            ], Array(Chunked([1, 2] as [U64], isSigned: false, count: 002, as: U32.self)))
        XCTAssertEqual([1, 0, 2         ], Array(Chunked([1, 2] as [U64], isSigned: false, count: 003, as: U32.self)))
        XCTAssertEqual([1, 0, 2, 0      ], Array(Chunked([1, 2] as [U64], isSigned: false, count: 004, as: U32.self)))
        XCTAssertEqual([1, 0, 2, 0, 0   ], Array(Chunked([1, 2] as [U64], isSigned: false, count: 005, as: U32.self)))
        XCTAssertEqual([1, 0, 2, 0, 0, 0], Array(Chunked([1, 2] as [U64], isSigned: false, count: 006, as: U32.self)))
    }
}
