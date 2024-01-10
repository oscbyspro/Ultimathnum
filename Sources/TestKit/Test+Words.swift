//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import XCTest

//*============================================================================*
// MARK: * Test x Words
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public static func words<T: Integer>(
    _ integer: T,_ expectation: [Word],
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        let words: T.Words = integer.words
        XCTAssert(integer.words.elementsEqual(expectation), "\(integer).words -> \(Array(words))", file: file, line: line)
    }
}
