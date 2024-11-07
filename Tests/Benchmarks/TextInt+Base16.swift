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
// MARK: * Text Int x Radix 16
//*============================================================================*

/// - Important: Please disable code coverage because it is always on by default.
final class TextIntBenchmarksOnRadix16: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    static let formatter = blackHoleIdentity(TextInt.hexadecimal)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    override static func setUp() {
        blackHole(formatter)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Decoding
    //=------------------------------------------------------------------------=
    
    func testDecodingOneMillionTimesBinaryIntegerAsUX() throws {
        let encoded = blackHoleIdentity(Self.formatter.encode(UX.max))
        
        for _ in 0 as UX ..<  1_000_000 {
            precondition((try? Self.formatter.decode(encoded) as UX) != nil)
        }
    }
    
    func testDecodingOneMillionTimesBinaryIntegerAsUXL() throws {
        let encoded = blackHoleIdentity(Self.formatter.encode(UX.max))
        
        for _ in 0 as UX ..<  1_000_000 {
            precondition((try? Self.formatter.decode(encoded) as UXL) != nil)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Encoding
    //=------------------------------------------------------------------------=
    
    func testEncodingFirstOneMillionBinaryIntegerAsUX() throws {
        var counter = UX.zero
        
        for value in 0 as UX ..< 1_000_000 {
            counter += UX(Bit(!Self.formatter.encode(value).isEmpty))
        }
        
        XCTAssertEqual(counter, 1_000_000)
    }
    
    func testEncodingFirstOneMillionBinaryIntegerAsUXL() throws {
        var counter = UX.zero, value = UXL(0), increment = UXL(1)
        
        for _ in 0 as UX ..< 1_000_000 {
            value  &+= increment
            counter += UX(Bit(!Self.formatter.encode(value).isEmpty))
        }
        
        XCTAssertEqual(counter, 1_000_000)
    }
    
    func testEncodingFirstOneMillionSignMagnitudeAsUX() throws {
        var counter = UX.zero
        
        for value in 0 as UX ..< 1_000_000 {
            counter += UX(Bit(!Self.formatter.encode(sign: .plus, magnitude: value).isEmpty))
        }
        
        XCTAssertEqual(counter, 1_000_000)
    }
    
    func testEncodingFirstOneMillionSignMagnitudeAsUXL() throws {
        var counter = UX.zero, value = UXL(0), increment = UXL(1)
        
        for _ in 0 as UX ..< 1_000_000 {
            value  &+= increment
            counter += UX(Bit(!Self.formatter.encode(sign: .plus, magnitude: value).isEmpty))
        }
        
        XCTAssertEqual(counter, 1_000_000)
    }
}
