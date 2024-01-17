//=----------------------------------------------------------------------------=
// This source file is part of the Iltimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Chunked Int x Sign Extension
//*============================================================================*

extension ChunkedIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubscriptSignExtension() {
        XCTAssertEqual(T([ 0] as [U32], isSigned: false, as: U32.self)[144],  0)
        XCTAssertEqual(T([ 0] as [U32], isSigned: true,  as: U32.self)[144],  0)
        XCTAssertEqual(T([~0] as [U32], isSigned: false, as: U32.self)[144],  0)
        XCTAssertEqual(T([~0] as [U32], isSigned: true,  as: U32.self)[144], ~0)
        
        XCTAssertEqual(T([ 0] as [U32], isSigned: false, as: U64.self)[144],  0)
        XCTAssertEqual(T([ 0] as [U32], isSigned: true,  as: U64.self)[144],  0)
        XCTAssertEqual(T([~0] as [U32], isSigned: false, as: U64.self)[144],  0)
        XCTAssertEqual(T([~0] as [U32], isSigned: true,  as: U64.self)[144], ~0)
        
        XCTAssertEqual(T([ 0] as [U64], isSigned: false, as: U32.self)[144],  0)
        XCTAssertEqual(T([ 0] as [U64], isSigned: true,  as: U32.self)[144],  0)
        XCTAssertEqual(T([~0] as [U64], isSigned: false, as: U32.self)[144],  0)
        XCTAssertEqual(T([~0] as [U64], isSigned: true,  as: U32.self)[144], ~0)
        
        XCTAssertEqual(T([ 0] as [U64], isSigned: false, as: U64.self)[144],  0)
        XCTAssertEqual(T([ 0] as [U64], isSigned: true,  as: U64.self)[144],  0)
        XCTAssertEqual(T([~0] as [U64], isSigned: false, as: U64.self)[144],  0)
        XCTAssertEqual(T([~0] as [U64], isSigned: true,  as: U64.self)[144], ~0)
    }
    
    func testMajorSequenceFromIncompleteMinorSequence() {
        checkOneWayOnly([                          ] as [U32], [                       ] as [U64], isSigned: true )
        checkOneWayOnly([ 1                        ] as [U32], [ 1                     ] as [U64], isSigned: true )
        checkOneWayOnly([ 1,  0,  2                ] as [U32], [ 1,  2                 ] as [U64], isSigned: true )
        checkOneWayOnly([ 1,  0,  2,  0,  3        ] as [U32], [ 1,  2,  3             ] as [U64], isSigned: true )
        checkOneWayOnly([ 1,  0,  2,  0,  3,  0,  4] as [U32], [ 1,  2,  3,  4         ] as [U64], isSigned: true )
        
        checkOneWayOnly([                          ] as [U32], [                       ] as [U64], isSigned: true )
        checkOneWayOnly([~1                        ] as [U32], [~1                     ] as [U64], isSigned: true )
        checkOneWayOnly([~1, ~0, ~2                ] as [U32], [~1, ~2                 ] as [U64], isSigned: true )
        checkOneWayOnly([~1, ~0, ~2, ~0, ~3        ] as [U32], [~1, ~2, ~3             ] as [U64], isSigned: true )
        checkOneWayOnly([~1, ~0, ~2, ~0, ~3, ~0, ~4] as [U32], [~1, ~2, ~3, ~4         ] as [U64], isSigned: true )
        
        checkOneWayOnly([                          ] as [U32], [                       ] as [U64], isSigned: false)
        checkOneWayOnly([ 1                        ] as [U32], [ 1                     ] as [U64], isSigned: false)
        checkOneWayOnly([ 1,  0,  2                ] as [U32], [ 1,  2                 ] as [U64], isSigned: false)
        checkOneWayOnly([ 1,  0,  2,  0,  3        ] as [U32], [ 1,  2,  3             ] as [U64], isSigned: false)
        checkOneWayOnly([ 1,  0,  2,  0,  3,  0,  4] as [U32], [ 1,  2,  3,  4         ] as [U64], isSigned: false)
        
        checkOneWayOnly([                          ] as [U32], [                       ] as [U64], isSigned: false)
        checkOneWayOnly([~1                        ] as [U32], [             0xfffffffe] as [U64], isSigned: false)
        checkOneWayOnly([~1, ~0, ~2                ] as [U32], [~1,          0xfffffffd] as [U64], isSigned: false)
        checkOneWayOnly([~1, ~0, ~2, ~0, ~3        ] as [U32], [~1, ~2,      0xfffffffc] as [U64], isSigned: false)
        checkOneWayOnly([~1, ~0, ~2, ~0, ~3, ~0, ~4] as [U32], [~1, ~2, ~3,  0xfffffffb] as [U64], isSigned: false)
    }
}
