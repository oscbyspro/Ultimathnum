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
    _ integer: T,_ expectation: [UX],
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        let words: T.Words = integer.words
        //=--------------------------------------=
        brr: do {
            XCTAssert(words.elementsEqual(expectation), "\(integer).words -> \(Array(words))", file: file, line: line)
        }
        
        brr: do {
            Test.words(words, T.isSigned, integer, file: file, line: line)
        }
    }
    
    public static func words<T: Integer>(
    _ words: some RandomAccessCollection<UX>, _ isSigned: Bool, _ expectation: T?,
    file: StaticString = #file, line: UInt = #line) {
        //=--------------------------------------=
        if  isSigned == T.isSigned {
            XCTAssertEqual(try? T.init(words: words), expectation, file: file, line: line)
        }
        
        brr: do {
            XCTAssertEqual(try? T.init(words: words, isSigned: isSigned), expectation, file: file, line: line)
        }
        
        if  type(of: words) != [UX].self {
            Test.words([UX](words), isSigned, expectation, file: file, line: line)
        }
    }
}
