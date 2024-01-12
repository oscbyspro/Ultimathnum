//=----------------------------------------------------------------------------=
// This source file is part of the Iltimathnum open source project.
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
        XCTAssertEqual(Chunked([ 0] as [I32], isSigned: false, as: I32.self)[144],  0)
        XCTAssertEqual(Chunked([ 0] as [I32], isSigned: true,  as: I32.self)[144],  0)
        XCTAssertEqual(Chunked([~0] as [I32], isSigned: false, as: I32.self)[144],  0)
        XCTAssertEqual(Chunked([~0] as [I32], isSigned: true,  as: I32.self)[144], ~0)
        
        XCTAssertEqual(Chunked([ 0] as [I32], isSigned: false, as: I64.self)[144],  0)
        XCTAssertEqual(Chunked([ 0] as [I32], isSigned: true,  as: I64.self)[144],  0)
        XCTAssertEqual(Chunked([~0] as [I32], isSigned: false, as: I64.self)[144],  0)
        XCTAssertEqual(Chunked([~0] as [I32], isSigned: true,  as: I64.self)[144], ~0)
        
        XCTAssertEqual(Chunked([ 0] as [I64], isSigned: false, as: I32.self)[144],  0)
        XCTAssertEqual(Chunked([ 0] as [I64], isSigned: true,  as: I32.self)[144],  0)
        XCTAssertEqual(Chunked([~0] as [I64], isSigned: false, as: I32.self)[144],  0)
        XCTAssertEqual(Chunked([~0] as [I64], isSigned: true,  as: I32.self)[144], ~0)
        
        XCTAssertEqual(Chunked([ 0] as [I64], isSigned: false, as: I64.self)[144],  0)
        XCTAssertEqual(Chunked([ 0] as [I64], isSigned: true,  as: I64.self)[144],  0)
        XCTAssertEqual(Chunked([~0] as [I64], isSigned: false, as: I64.self)[144],  0)
        XCTAssertEqual(Chunked([~0] as [I64], isSigned: true,  as: I64.self)[144], ~0)
    }
    
    func testMajorSequenceFromIncompleteMinorSequence() {
        checkOneWayOnly([                          ] as [I32], [                       ] as [I64], isSigned: true )
        checkOneWayOnly([ 1                        ] as [I32], [ 1                     ] as [I64], isSigned: true )
        checkOneWayOnly([ 1,  0,  2                ] as [I32], [ 1,  2                 ] as [I64], isSigned: true )
        checkOneWayOnly([ 1,  0,  2,  0,  3        ] as [I32], [ 1,  2,  3             ] as [I64], isSigned: true )
        checkOneWayOnly([ 1,  0,  2,  0,  3,  0,  4] as [I32], [ 1,  2,  3,  4         ] as [I64], isSigned: true )
        
        checkOneWayOnly([                          ] as [I32], [                       ] as [I64], isSigned: true )
        checkOneWayOnly([~1                        ] as [I32], [~1                     ] as [I64], isSigned: true )
        checkOneWayOnly([~1, ~0, ~2                ] as [I32], [~1, ~2                 ] as [I64], isSigned: true )
        checkOneWayOnly([~1, ~0, ~2, ~0, ~3        ] as [I32], [~1, ~2, ~3             ] as [I64], isSigned: true )
        checkOneWayOnly([~1, ~0, ~2, ~0, ~3, ~0, ~4] as [I32], [~1, ~2, ~3, ~4         ] as [I64], isSigned: true )
        
        checkOneWayOnly([                          ] as [I32], [                       ] as [I64], isSigned: false)
        checkOneWayOnly([ 1                        ] as [I32], [ 1                     ] as [I64], isSigned: false)
        checkOneWayOnly([ 1,  0,  2                ] as [I32], [ 1,  2                 ] as [I64], isSigned: false)
        checkOneWayOnly([ 1,  0,  2,  0,  3        ] as [I32], [ 1,  2,  3             ] as [I64], isSigned: false)
        checkOneWayOnly([ 1,  0,  2,  0,  3,  0,  4] as [I32], [ 1,  2,  3,  4         ] as [I64], isSigned: false)
        
        checkOneWayOnly([                          ] as [I32], [                       ] as [I64], isSigned: false)
        checkOneWayOnly([~1                        ] as [I32], [             0xfffffffe] as [I64], isSigned: false)
        checkOneWayOnly([~1, ~0, ~2                ] as [I32], [~1,          0xfffffffd] as [I64], isSigned: false)
        checkOneWayOnly([~1, ~0, ~2, ~0, ~3        ] as [I32], [~1, ~2,      0xfffffffc] as [I64], isSigned: false)
        checkOneWayOnly([~1, ~0, ~2, ~0, ~3, ~0, ~4] as [I32], [~1, ~2, ~3,  0xfffffffb] as [I64], isSigned: false)
    }
}
