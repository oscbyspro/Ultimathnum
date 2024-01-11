//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import ModelsKit
import TestKit

//*============================================================================*
// MARK: * Fibonacci
//*============================================================================*

final class FibonacciTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func check<T>(_ value: Fibonacci<T>?, _ expectation: (index: T, element: T, next: T)?, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(value?.index,   expectation?.index,   file: file, line: line)
        XCTAssertEqual(value?.element, expectation?.element, file: file, line: line)
        XCTAssertEqual(value?.next,    expectation?.next,    file: file, line: line)
    }
}
