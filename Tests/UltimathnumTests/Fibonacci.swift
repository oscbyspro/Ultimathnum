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
    
    #if !DEBUG
    static let fib1e6 = try! Fibonacci<UXL>(1_000_000)
    static let fib1e6r10 = fib1e6.element.description(as:     .decimal)
    static let fib1e6r16 = fib1e6.element.description(as: .hexadecimal)
    #endif
    
    //=------------------------------------------------------------------------=
    // MARK: Initialization
    //=------------------------------------------------------------------------=
    
    override static func setUp() {
        #if !DEBUG
        blackHole(fib1e6)
        blackHole(fib1e6r10)
        blackHole(fib1e6r16)
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UXL
    //=------------------------------------------------------------------------=
    
    func testFibonacciUXL1e5() throws {
        #if DEBUG
        throw XCTSkip("benchmark")
        #else
        blackHole(try! Fibonacci<UXL>(blackHoleIdentity(100_000)))
        #endif
    }
    
    func testFibonacciUXL1e6() throws {
        #if DEBUG
        throw XCTSkip("benchmark")
        #else
        blackHole(try! Fibonacci<UXL>(blackHoleIdentity(1_000_000)))
        #endif
    }
    
    func testFibonacciUXL1e7() throws {
        #if DEBUG
        throw XCTSkip("benchmark")
        #else
        blackHole(try! Fibonacci<UXL>(blackHoleIdentity(10_000_000)))
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UXL x Text Encoding
    //=------------------------------------------------------------------------=
    
    func testFibonacciUXL1e6ToTextAsDecimal() throws {
        #if DEBUG
        throw XCTSkip("benchmark")
        #else
        blackHole(blackHoleIdentity(Self.fib1e6.element).description(as: blackHoleIdentity(.decimal)))
        #endif
    }
    
    func testFibonacciUXL1e6ToTextAsHexadecimal() throws {
        #if DEBUG
        throw XCTSkip("benchmark")
        #else
        blackHole(blackHoleIdentity(Self.fib1e6.element).description(as: blackHoleIdentity(.hexadecimal)))
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UXL x Text Decoding
    //=------------------------------------------------------------------------=
    
    func testFibonacciUXL1e6FromTextAsDecimal() throws {
        #if DEBUG
        throw XCTSkip("benchmark")
        #else
        blackHole(try! UXL(blackHoleIdentity(Self.fib1e6r10), as: blackHoleIdentity(.decimal)))
        #endif
    }
    
    func testFibonacciUXL1e6FromTextAsHexadecimal() throws {
        #if DEBUG
        throw XCTSkip("benchmark")
        #else
        blackHole(try! UXL(blackHoleIdentity(Self.fib1e6r16), as: blackHoleIdentity(.hexadecimal)))
        #endif
    }
}
