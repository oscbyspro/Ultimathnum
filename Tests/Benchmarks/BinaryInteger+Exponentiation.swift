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
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Exponentiation
//*============================================================================*

/// - Important: Please disable code coverage because it is always on by default.
final class BinaryIntegerBenchmarksOnExponentiation: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testExponentiationAsU64() throws {
        typealias T = U64
        
        for base: UX in 0..<128 {
            for exponent: UX in 0..<1000 {
                blackHole(T(load: base).power(exponent))
            }
        }
    }
    
    func testExponentiationAsU256() throws {
        typealias T = U256
        
        for base: UX in 0..<128 {
            for exponent: UX in 0..<1000 {
                blackHole(T(load: base).power(exponent))
            }
        }
    }
    
    func testExponentiationAsUXL() throws {
        typealias T = UXL
        
        for base: UX in 0..<128 {
            for exponent: UX in 0..<1000 {
                blackHole(T(load: base).power(exponent))
            }
        }
    }
}
