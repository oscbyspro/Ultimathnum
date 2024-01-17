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
// MARK: * Integer Description Format x Encoding
//*============================================================================*

final class IntegerDescriptionFormatTestsOnEncoding: XCTestCase {
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let encoder = Namespace.IntegerDescriptionFormat.Encoder<UX>()
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testEncoding() {
        for count in 0 ..< 4 {
            let zeros = Array(repeating: 0 as UX, count: count)
            
            check(Sign.plus,  [0] + zeros,  "0")
            check(Sign.minus, [0] + zeros,  "0")
            
            check(Sign.plus,  [1] + zeros,  "1")
            check(Sign.minus, [1] + zeros, "-1")
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func check(_ sign: Sign, _ magnitude: [UX], _ expectation: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(encoder.encode(sign: sign, magnitude: magnitude), expectation, file: file, line: line)
    }
}
