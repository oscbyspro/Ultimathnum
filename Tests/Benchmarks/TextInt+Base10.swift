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
// MARK: * Text Int x Radix 10
//*============================================================================*

/// - Important: Please disable code coverage because it is always on by default.
final class TextIntBenchmarksOnRadix10: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let coder = blackHoleIdentity(TextInt.decimal)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    override static func setUp() {
        blackHole(coder)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Decoding
    //=------------------------------------------------------------------------=
    
    func testDecodingOneMillionTimesBinaryIntegerAsUX() throws {
        let encoded = blackHoleIdentity(Self.coder.encode(UX.max))
        
        for _ in 0 as UX ..< blackHoleIdentity(1_000_000) {
            precondition(Self.coder.decode(encoded, as: UX.self) != nil)
        }
    }
    
    func testDecodingOneMillionTimesBinaryIntegerAsUXL() throws {
        let encoded = blackHoleIdentity(Self.coder.encode(UX.max))
        
        for _ in 0 as UX ..< blackHoleIdentity(1_000_000) {
            precondition(Self.coder.decode(encoded, as: UXL.self) != nil)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Encoding
    //=------------------------------------------------------------------------=
    
    func testEncodingFirstOneMillionBinaryIntegerAsUX() throws {
        var counter = UX.zero
        
        for value in 0 as UX ..< blackHoleIdentity(1_000_000) {
            counter += UX(Bit(!Self.coder.encode(value).isEmpty))
        }
        
        XCTAssertEqual(counter,  blackHoleIdentity(1_000_000))
    }
    
    func testEncodingFirstOneMillionBinaryIntegerAsUXL() throws {
        var counter = UX.zero, value = UXL.zero, one = UXL.lsb
        
        for _ in 0 as UX ..< blackHoleIdentity(1_000_000) {
            value  &+= one
            counter += UX(Bit(!Self.coder.encode(value).isEmpty))
        }
        
        XCTAssertEqual(counter,  blackHoleIdentity(1_000_000))
    }
    
    func testEncodingFirstOneMillionSignMagnitudeAsUX() throws {
        var counter = UX.zero
        
        for value in 0 as UX ..< blackHoleIdentity(1_000_000) {
            counter += UX(Bit(!Self.coder.encode(sign: .plus, magnitude: value).isEmpty))
        }
        
        XCTAssertEqual(counter,  blackHoleIdentity(1_000_000))
    }
    
    func testEncodingFirstOneMillionSignMagnitudeAsUXL() throws {
        var counter = UX.zero, value = UXL.zero, increment = UXL.lsb
        
        for _ in 0 as UX ..< blackHoleIdentity(1_000_000) {
            value  &+= increment
            counter += UX(Bit(!Self.coder.encode(sign: .plus, magnitude: value).isEmpty))
        }
        
        XCTAssertEqual(counter,  blackHoleIdentity(1_000_000))
    }
}
