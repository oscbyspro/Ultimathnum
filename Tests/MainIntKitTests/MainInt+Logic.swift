//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import MainIntKit
import XCTest

//*============================================================================*
// MARK: * Core Int x Logic
//*============================================================================*

extension MainIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLogicalNot() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(~T.min, T.max as T)
            XCTAssertEqual(~T.max, T.min as T)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLogicalAnd() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(~1 & ~1, ~1 as T)
            XCTAssertEqual(~1 & ~0, ~1 as T)
            XCTAssertEqual(~1 &  0,  0 as T)
            XCTAssertEqual(~1 &  1,  0 as T)
            
            XCTAssertEqual(~0 & ~1, ~1 as T)
            XCTAssertEqual(~0 & ~0, ~0 as T)
            XCTAssertEqual(~0 &  0,  0 as T)
            XCTAssertEqual(~0 &  1,  1 as T)
            
            XCTAssertEqual( 0 & ~1,  0 as T)
            XCTAssertEqual( 0 & ~0,  0 as T)
            XCTAssertEqual( 0 &  0,  0 as T)
            XCTAssertEqual( 0 &  1,  0 as T)
            
            XCTAssertEqual( 1 & ~1,  0 as T)
            XCTAssertEqual( 1 & ~0,  1 as T)
            XCTAssertEqual( 1 &  0,  0 as T)
            XCTAssertEqual( 1 &  1,  1 as T)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLogicalOr() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(~1 | ~1, ~1 as T)
            XCTAssertEqual(~1 | ~0, ~0 as T)
            XCTAssertEqual(~1 |  0, ~1 as T)
            XCTAssertEqual(~1 |  1, ~0 as T)
            
            XCTAssertEqual(~0 | ~1, ~0 as T)
            XCTAssertEqual(~0 | ~0, ~0 as T)
            XCTAssertEqual(~0 |  0, ~0 as T)
            XCTAssertEqual(~0 |  1, ~0 as T)
            
            XCTAssertEqual( 0 | ~1, ~1 as T)
            XCTAssertEqual( 0 | ~0, ~0 as T)
            XCTAssertEqual( 0 |  0,  0 as T)
            XCTAssertEqual( 0 |  1,  1 as T)
            
            XCTAssertEqual( 1 | ~1, ~0 as T)
            XCTAssertEqual( 1 | ~0, ~0 as T)
            XCTAssertEqual( 1 |  0,  1 as T)
            XCTAssertEqual( 1 |  1,  1 as T)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLogicalXor() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(~1 ^ ~1,  0 as T)
            XCTAssertEqual(~1 ^ ~0,  1 as T)
            XCTAssertEqual(~1 ^  0, ~1 as T)
            XCTAssertEqual(~1 ^  1, ~0 as T)
            
            XCTAssertEqual(~0 ^ ~1,  1 as T)
            XCTAssertEqual(~0 ^ ~0,  0 as T)
            XCTAssertEqual(~0 ^  0, ~0 as T)
            XCTAssertEqual(~0 ^  1, ~1 as T)
            
            XCTAssertEqual( 0 ^ ~1, ~1 as T)
            XCTAssertEqual( 0 ^ ~0, ~0 as T)
            XCTAssertEqual( 0 ^  0,  0 as T)
            XCTAssertEqual( 0 ^  1,  1 as T)
            
            XCTAssertEqual( 1 ^ ~1, ~0 as T)
            XCTAssertEqual( 1 ^ ~0, ~1 as T)
            XCTAssertEqual( 1 ^  0,  1 as T)
            XCTAssertEqual( 1 ^  1,  0 as T)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
