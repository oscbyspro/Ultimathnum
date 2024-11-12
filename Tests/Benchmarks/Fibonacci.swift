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
    
    static let fib1e6 = IXL.fibonacci(1_000_000)
    static let fib1e6r10 = fib1e6.description(as:     .decimal)
    static let fib1e6r16 = fib1e6.description(as: .hexadecimal)
    
    //=------------------------------------------------------------------------=
    // MARK: Initialization
    //=------------------------------------------------------------------------=
    
    override static func setUp() {
        blackHole(fib1e6)
        blackHole(fib1e6r10)
        blackHole(fib1e6r16)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x IXL
    //=------------------------------------------------------------------------=
    
    func testFibonacciIXL1e5() throws {
        let index:   IXL = blackHoleIdentity(100_000)
        let element: IXL = IXL.fibonacci(index)
        XCTAssertEqual(element.entropy(), Count(69_425))
    }
    
    /// ###### 2024-09-07 (MacBook Pro, 13-inch, M1, 2020):
    ///
    ///     0.04 seconds
    ///     0.02 seconds after (#84)
    ///
    func testFibonacciIXL1e6() throws {
        let index:   IXL = blackHoleIdentity(1_000_000)
        let element: IXL = IXL.fibonacci(index)
        XCTAssertEqual(element.entropy(), Count(694_242))
    }
    
    /// ###### 2024-09-07 (MacBook Pro, 13-inch, M1, 2020):
    ///
    ///     1.65 seconds
    ///     0.50 seconds after (#84)
    ///
    func testFibonacciIXL1e7() throws {
        let index:   IXL = blackHoleIdentity(10_000_000)
        let element: IXL = IXL.fibonacci(index)
        XCTAssertEqual(element.entropy(), Count(6_942_419))
    }
    
    /// ###### 2024-08-08 (MacBook Pro, 13-inch, M1, 2020):
    ///
    /// - `0.99 seconds`
    /// - `0.30 seconds` with `Divider21`
    ///
    func testFibonacciIXL1e6ToTextAsDecimal() throws {
        let data = blackHoleIdentity(Self.fib1e6)
        let format = blackHoleIdentity(TextInt.decimal)
        let text = data.description(as: format)
        XCTAssertEqual(text.utf8.count, 208988)
    }
    
    func testFibonacciIXL1e6ToTextAsHexadecimal() throws {
        let data = blackHoleIdentity(Self.fib1e6)
        let format = blackHoleIdentity(TextInt.hexadecimal)
        let text = data.description(as: format)
        XCTAssertEqual(text.utf8.count, 173561)
    }
    
    func testFibonacciIXL1e6FromTextAsDecimal() throws {
        let text = blackHoleIdentity(Self.fib1e6r10)
        let format = blackHoleIdentity(TextInt.decimal)
        let data = try IXL.init(text, as: format)
        XCTAssertEqual(data, Self.fib1e6)
    }
    
    func testFibonacciIXL1e6FromTextAsHexadecimal() throws {
        let text = blackHoleIdentity(Self.fib1e6r16)
        let format = blackHoleIdentity(TextInt.hexadecimal)
        let data = try IXL.init(text, as: format)
        XCTAssertEqual(data, Self.fib1e6)
    }
}
