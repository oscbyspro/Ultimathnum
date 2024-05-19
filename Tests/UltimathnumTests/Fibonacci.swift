//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import FibonacciKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Fibonacci
//*============================================================================*

/// - Important: Please disable code coverage because it is always on by default.
final class FibonacciBenchmarks: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UXL
    //=------------------------------------------------------------------------=
    
    func testFibonacciUXL1e6() throws {
        #if DEBUG
        throw XCTSkip("benchmark")
        #else
        blackHole(try! Fibonacci<UXL>(1_000_000))
        #endif
    }
    
    func testFibonacciUXL1e7() throws {
        #if DEBUG
        throw XCTSkip("benchmark")
        #else
        blackHole(try! Fibonacci<UXL>(10_000_000))
        #endif
    }
}
