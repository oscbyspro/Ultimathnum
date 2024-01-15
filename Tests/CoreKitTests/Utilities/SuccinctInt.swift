//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import MainIntKit
import TestKit

//*============================================================================*
// MARK: * Succinct Int
//*============================================================================*

final class SuccinctIntTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitExactly() {
        checkInitExactly([      ] as [UX], ~0 as UX, true )
        checkInitExactly([      ] as [UX],  0 as UX, true )
        
        checkInitExactly([ 0,  1] as [UX], ~0 as UX, true )
        checkInitExactly([ 0,  1] as [UX],  0 as UX, true )
        checkInitExactly([~0, ~1] as [UX], ~0 as UX, true )
        checkInitExactly([~0, ~1] as [UX],  0 as UX, true )
        
        checkInitExactly([ 1,  0] as [UX], ~0 as UX, true )
        checkInitExactly([ 1,  0] as [UX],  0 as UX, false)
        checkInitExactly([~1, ~0] as [UX], ~0 as UX, false)
        checkInitExactly([~1, ~0] as [UX],  0 as UX, true )
    }
    
    func testInitIsSigned() {
        checkInitIsSigned([ ] as [UX], true,  [ ] as [UX], 0 as UX)
        checkInitIsSigned([ ] as [UX], false, [ ] as [UX], 0 as UX)
        
        checkInitIsSigned([ 0,  0,  0,  0] as [UX], true, [              ] as [UX],  0 as UX)
        checkInitIsSigned([ 1,  0,  0,  0] as [UX], true, [ 1            ] as [UX],  0 as UX)
        checkInitIsSigned([ 1,  2,  0,  0] as [UX], true, [ 1,  2        ] as [UX],  0 as UX)
        checkInitIsSigned([ 1,  2,  3,  0] as [UX], true, [ 1,  2,  3    ] as [UX],  0 as UX)
        checkInitIsSigned([ 1,  2,  3,  4] as [UX], true, [ 1,  2,  3,  4] as [UX],  0 as UX)
        
        checkInitIsSigned([~0, ~0, ~0, ~0] as [UX], true, [              ] as [UX], ~0 as UX)
        checkInitIsSigned([~1, ~0, ~0, ~0] as [UX], true, [~1            ] as [UX], ~0 as UX)
        checkInitIsSigned([~1, ~2, ~0, ~0] as [UX], true, [~1, ~2        ] as [UX], ~0 as UX)
        checkInitIsSigned([~1, ~2, ~3, ~0] as [UX], true, [~1, ~2, ~3    ] as [UX], ~0 as UX)
        checkInitIsSigned([~1, ~2, ~3, ~4] as [UX], true, [~1, ~2, ~3, ~4] as [UX], ~0 as UX)
        
        checkInitIsSigned([ 0,  0,  0,  0] as [UX], false, [              ] as [UX],  0 as UX)
        checkInitIsSigned([ 1,  0,  0,  0] as [UX], false, [ 1            ] as [UX],  0 as UX)
        checkInitIsSigned([ 1,  2,  0,  0] as [UX], false, [ 1,  2        ] as [UX],  0 as UX)
        checkInitIsSigned([ 1,  2,  3,  0] as [UX], false, [ 1,  2,  3    ] as [UX],  0 as UX)
        checkInitIsSigned([ 1,  2,  3,  4] as [UX], false, [ 1,  2,  3,  4] as [UX],  0 as UX)
        
        checkInitIsSigned([~0, ~0, ~0, ~0] as [UX], false, [~0, ~0, ~0, ~0] as [UX],  0 as UX)
        checkInitIsSigned([~1, ~0, ~0, ~0] as [UX], false, [~1, ~0, ~0, ~0] as [UX],  0 as UX)
        checkInitIsSigned([~1, ~2, ~0, ~0] as [UX], false, [~1, ~2, ~0, ~0] as [UX],  0 as UX)
        checkInitIsSigned([~1, ~2, ~3, ~0] as [UX], false, [~1, ~2, ~3, ~0] as [UX],  0 as UX)
        checkInitIsSigned([~1, ~2, ~3, ~4] as [UX], false, [~1, ~2, ~3, ~4] as [UX],  0 as UX)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    private func checkInitExactly(_ body: [UX], _ sign: UX, _ success: Bool, file: StaticString = #file, line: UInt = #line) {
        if  success {
            XCTAssertNoThrow(try SuccinctInt(exactly:   body, sign: sign), file: file, line: line)
            XCTAssertNotNil (    SuccinctInt(unchecked: body, sign: sign), file: file, line: line)
        }
    }

    private func checkInitIsSigned(_ source: [UX], _ isSigned: Bool, _ body: [UX], _ sign: UX?, file: StaticString = #file, line: UInt = #line) {
        var source = source
        
        brr: do {
            XCTAssertEqual(SuccinctInt(source[...], isSigned: isSigned).sign,              sign, file: file, line: line)
            XCTAssertEqual(SuccinctInt(source[...], isSigned: isSigned).body.map({ $0 }),  body, file: file, line: line)
        }
        
        source.withUnsafeBufferPointer { source in
            XCTAssertEqual(SuccinctInt(source, isSigned: isSigned).sign,             sign, file: file, line: line)
            XCTAssertEqual(SuccinctInt(source, isSigned: isSigned).body.map({ $0 }), body, file: file, line: line)
        }
        
        source.withUnsafeBufferPointer { source in
            XCTAssertEqual(SuccinctInt(source[...], isSigned: isSigned).sign,              sign, file: file, line: line)
            XCTAssertEqual(SuccinctInt(source[...], isSigned: isSigned).body.map({ $0 }),  body, file: file, line: line)
        }
        
        source.withUnsafeMutableBufferPointer { source in
            XCTAssertEqual(SuccinctInt(source, isSigned: isSigned).sign,             sign, file: file, line: line)
            XCTAssertEqual(SuccinctInt(source, isSigned: isSigned).body.map({ $0 }), body, file: file, line: line)
        }
        
        source.withUnsafeMutableBufferPointer { source in
            XCTAssertEqual(SuccinctInt(source[...], isSigned: isSigned).sign,              sign, file: file, line: line)
            XCTAssertEqual(SuccinctInt(source[...], isSigned: isSigned).body.map({ $0 }),  body, file: file, line: line)
        }
    }
}
