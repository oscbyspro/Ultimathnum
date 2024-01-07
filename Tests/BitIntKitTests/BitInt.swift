//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import BitIntKit
import CoreKit
import XCTest

//*============================================================================*
// MARK: * Bit Int
//*============================================================================*

final class BitIntTests: XCTestCase {
    
    typealias I = any (SystemInteger &   SignedInteger).Type
    typealias U = any (SystemInteger & UnsignedInteger).Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    static let signed:   [I] = [BitInt.self]
    static let unsigned: [U] = [BitInt.Magnitude.self]
    static let types: [any SystemInteger.Type] = signed + unsigned
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMinMax() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(T.min, T.isSigned ? -1 : 0)
            XCTAssertEqual(T.max, T.isSigned ?  0 : 1)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLsbMsb() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(T.lsb, T.isSigned ? -1 : 1)
            XCTAssertEqual(T.msb, T.isSigned ? -1 : 1)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testMetaData() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(T.bitWidth, 1)
            XCTAssertEqual(T.isSigned == true,  T.self is any   SignedInteger.Type)
            XCTAssertEqual(T.isSigned == false, T.self is any UnsignedInteger.Type)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
