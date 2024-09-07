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
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let fib1e6 = try! Fibonacci<UXL>(1_000_000)
    static let fib1e6r10 = fib1e6.element.description(as:     .decimal)
    static let fib1e6r16 = fib1e6.element.description(as: .hexadecimal)
    
    //=------------------------------------------------------------------------=
    // MARK: Initialization
    //=------------------------------------------------------------------------=
    
    override static func setUp() {
        blackHole(fib1e6)
        blackHole(fib1e6r10)
        blackHole(fib1e6r16)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UXL
    //=------------------------------------------------------------------------=
    
    func testFibonacciUXL1e5() throws {
        blackHole(try Fibonacci<UXL>(blackHoleIdentity(100_000)))
    }
    
    /// ###### 2024-09-07 (MacBook Pro, 13-inch, M1, 2020):
    ///
    ///     0.04 seconds
    ///     0.02 seconds after (#84)
    ///
    func testFibonacciUXL1e6() throws {
        blackHole(try Fibonacci<UXL>(blackHoleIdentity(1_000_000)))
    }
    
    /// ###### 2024-09-07 (MacBook Pro, 13-inch, M1, 2020):
    ///
    ///     1.65 seconds
    ///     0.50 seconds after (#84)
    ///
    func testFibonacciUXL1e7() throws {
        blackHole(try Fibonacci<UXL>(blackHoleIdentity(10_000_000)))
    }
    
    /// ###### 2024-08-08 (MacBook Pro, 13-inch, M1, 2020):
    ///
    /// - `0.99 seconds`
    /// - `0.30 seconds` with `Divider21`
    ///
    func testFibonacciUXL1e6ToTextAsDecimal() throws {
        blackHole(blackHoleIdentity(Self.fib1e6.element).description(as: blackHoleIdentity(.decimal)))
    }
    
    func testFibonacciUXL1e6ToTextAsHexadecimal() throws {
        blackHole(blackHoleIdentity(Self.fib1e6.element).description(as: blackHoleIdentity(.hexadecimal)))
    }
    
    func testFibonacciUXL1e6FromTextAsDecimal() throws {
        blackHole(try! UXL(blackHoleIdentity(Self.fib1e6r10), as: blackHoleIdentity(.decimal)))
    }
    
    func testFibonacciUXL1e6FromTextAsHexadecimal() throws {
        blackHole(try! UXL(blackHoleIdentity(Self.fib1e6r16), as: blackHoleIdentity(.hexadecimal)))
    }
}
