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
    
    #if !DEBUG
    static let formatter = blackHoleIdentity(TextInt.hexadecimal)
    #endif
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    override static func setUp() {
        #if !DEBUG
        blackHole(formatter)
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Encoding
    //=------------------------------------------------------------------------=
    
    func testEncodingFirstOneMillionBinaryIntegerAsUX() throws {
        #if DEBUG
        throw XCTSkip("benchmark")
        #else
        var counter = UX.zero
        
        for value in 0 as UX ..< 1_000_000 {
            counter += UX(Bit(!Self.formatter.encode(value).isEmpty))
        }
        
        Test().same(counter, 1_000_000)
        #endif
    }
    
    func testEncodingFirstOneMillionBinaryIntegerAsUXL() throws {
        #if DEBUG
        throw XCTSkip("benchmark")
        #else
        var counter = UX.zero, value = UXL(0), increment = UXL(1)
        
        for _ in 0 as UX ..< 1_000_000 {
            value  &+= increment
            counter += UX(Bit(!Self.formatter.encode(value).isEmpty))
        }
        
        Test().same(counter, 1_000_000)
        #endif
    }
    
    func testEncodingFirstOneMillionSignMagnitudeAsUX() throws {
        #if DEBUG
        throw XCTSkip("benchmark")
        #else
        var counter = UX.zero
        
        for value in 0 as UX ..< 1_000_000 {
            counter += UX(Bit(!Self.formatter.encode(sign: .plus, magnitude: value).isEmpty))
        }
        
        Test().same(counter, 1_000_000)
        #endif
    }
    
    func testEncodingFirstOneMillionSignMagnitudeAsUXL() throws {
        #if DEBUG
        throw XCTSkip("benchmark")
        #else
        var counter = UX.zero, value = UXL(0), increment = UXL(1)
        
        for _ in 0 as UX ..< 1_000_000 {
            value  &+= increment
            counter += UX(Bit(!Self.formatter.encode(sign: .plus, magnitude: value).isEmpty))
        }
        
        Test().same(counter, 1_000_000)
        #endif
    }
}
