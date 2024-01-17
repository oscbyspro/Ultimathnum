//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Core Int
//*============================================================================*

final class CoreIntTests: XCTestCase {
    
    typealias I = any (SystemInteger &   SignedInteger).Type
    typealias U = any (SystemInteger & UnsignedInteger).Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    static let signed:   [I] = [IX.self, I8.self, I16.self, I32.self, I64.self]
    static let unsigned: [U] = [UX.self, U8.self, U16.self, U32.self, U64.self]
    static let types: [any SystemInteger.Type] = signed + unsigned
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMinMax() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(T.min, T.isSigned ?  T.msb :  0)
            XCTAssertEqual(T.max, T.isSigned ? ~T.msb : ~0)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLsbMsb() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(T.lsb.count(1, option: .ascending ), 1)
            XCTAssertEqual(T.lsb.count(0, option: .descending), T.bitWidth - 1)
            XCTAssertEqual(T.msb.count(0, option: .ascending ), T.bitWidth - 1)
            XCTAssertEqual(T.msb.count(1, option: .descending), 1)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testMetaData() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(T.bitWidth.count(1, option: .all), 1)
            XCTAssertEqual(T.isSigned == true,  T.self is any   SignedInteger.Type)
            XCTAssertEqual(T.isSigned == false, T.self is any UnsignedInteger.Type)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
