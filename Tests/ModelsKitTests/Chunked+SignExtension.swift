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
// MARK: * Chunked x Sign Extension
//*============================================================================*

extension ChunkedTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubscriptSignExtension() {
        XCTAssertEqual(Chunked([ 0] as [U32], isSigned: false, as: U32.self)[144],  0)
        XCTAssertEqual(Chunked([ 0] as [U32], isSigned: true,  as: U32.self)[144],  0)
        XCTAssertEqual(Chunked([~0] as [U32], isSigned: false, as: U32.self)[144],  0)
        XCTAssertEqual(Chunked([~0] as [U32], isSigned: true,  as: U32.self)[144], ~0)
        
        XCTAssertEqual(Chunked([ 0] as [U32], isSigned: false, as: U64.self)[144],  0)
        XCTAssertEqual(Chunked([ 0] as [U32], isSigned: true,  as: U64.self)[144],  0)
        XCTAssertEqual(Chunked([~0] as [U32], isSigned: false, as: U64.self)[144],  0)
        XCTAssertEqual(Chunked([~0] as [U32], isSigned: true,  as: U64.self)[144], ~0)
        
        XCTAssertEqual(Chunked([ 0] as [U64], isSigned: false, as: U32.self)[144],  0)
        XCTAssertEqual(Chunked([ 0] as [U64], isSigned: true,  as: U32.self)[144],  0)
        XCTAssertEqual(Chunked([~0] as [U64], isSigned: false, as: U32.self)[144],  0)
        XCTAssertEqual(Chunked([~0] as [U64], isSigned: true,  as: U32.self)[144], ~0)
        
        XCTAssertEqual(Chunked([ 0] as [U64], isSigned: false, as: U64.self)[144],  0)
        XCTAssertEqual(Chunked([ 0] as [U64], isSigned: true,  as: U64.self)[144],  0)
        XCTAssertEqual(Chunked([~0] as [U64], isSigned: false, as: U64.self)[144],  0)
        XCTAssertEqual(Chunked([~0] as [U64], isSigned: true,  as: U64.self)[144], ~0)
    }
    
    func testMajorSequenceFromIncompleteMinorSequence() {
        checkOneWay([                          ] as [U32], [                       ] as [U64], isSigned: true )
        checkOneWay([ 1                        ] as [U32], [ 1                     ] as [U64], isSigned: true )
        checkOneWay([ 1,  0,  2                ] as [U32], [ 1,  2                 ] as [U64], isSigned: true )
        checkOneWay([ 1,  0,  2,  0,  3        ] as [U32], [ 1,  2,  3             ] as [U64], isSigned: true )
        checkOneWay([ 1,  0,  2,  0,  3,  0,  4] as [U32], [ 1,  2,  3,  4         ] as [U64], isSigned: true )
        
        checkOneWay([                          ] as [U32], [                       ] as [U64], isSigned: true )
        checkOneWay([~1                        ] as [U32], [~1                     ] as [U64], isSigned: true )
        checkOneWay([~1, ~0, ~2                ] as [U32], [~1, ~2                 ] as [U64], isSigned: true )
        checkOneWay([~1, ~0, ~2, ~0, ~3        ] as [U32], [~1, ~2, ~3             ] as [U64], isSigned: true )
        checkOneWay([~1, ~0, ~2, ~0, ~3, ~0, ~4] as [U32], [~1, ~2, ~3, ~4         ] as [U64], isSigned: true )
        
        checkOneWay([                          ] as [U32], [                       ] as [U64], isSigned: false)
        checkOneWay([ 1                        ] as [U32], [ 1                     ] as [U64], isSigned: false)
        checkOneWay([ 1,  0,  2                ] as [U32], [ 1,  2                 ] as [U64], isSigned: false)
        checkOneWay([ 1,  0,  2,  0,  3        ] as [U32], [ 1,  2,  3             ] as [U64], isSigned: false)
        checkOneWay([ 1,  0,  2,  0,  3,  0,  4] as [U32], [ 1,  2,  3,  4         ] as [U64], isSigned: false)
        
        checkOneWay([                          ] as [U32], [                       ] as [U64], isSigned: false)
        checkOneWay([~1                        ] as [U32], [             0xfffffffe] as [U64], isSigned: false)
        checkOneWay([~1, ~0, ~2                ] as [U32], [~1,          0xfffffffd] as [U64], isSigned: false)
        checkOneWay([~1, ~0, ~2, ~0, ~3        ] as [U32], [~1, ~2,      0xfffffffc] as [U64], isSigned: false)
        checkOneWay([~1, ~0, ~2, ~0, ~3, ~0, ~4] as [U32], [~1, ~2, ~3,  0xfffffffb] as [U64], isSigned: false)
    }
}
