//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import UMNBitIntKit
import UMNCoreKit
import XCTest

//*============================================================================*
// MARK: * Bit Int x Logic
//*============================================================================*

extension BitIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLogicalNot() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(~T.min, T.max as T)
            XCTAssertEqual(~T.max, T.min as T)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLogicalAnd() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(T(bitPattern: ~1 & ~1 as M), T(bitPattern: ~1 as M))
            XCTAssertEqual(T(bitPattern: ~1 & ~0 as M), T(bitPattern: ~1 as M))
            XCTAssertEqual(T(bitPattern: ~1 &  0 as M), T(bitPattern:  0 as M))
            XCTAssertEqual(T(bitPattern: ~1 &  1 as M), T(bitPattern:  0 as M))
            
            XCTAssertEqual(T(bitPattern: ~0 & ~1 as M), T(bitPattern: ~1 as M))
            XCTAssertEqual(T(bitPattern: ~0 & ~0 as M), T(bitPattern: ~0 as M))
            XCTAssertEqual(T(bitPattern: ~0 &  0 as M), T(bitPattern:  0 as M))
            XCTAssertEqual(T(bitPattern: ~0 &  1 as M), T(bitPattern:  1 as M))
            
            XCTAssertEqual(T(bitPattern:  0 & ~1 as M), T(bitPattern:  0 as M))
            XCTAssertEqual(T(bitPattern:  0 & ~0 as M), T(bitPattern:  0 as M))
            XCTAssertEqual(T(bitPattern:  0 &  0 as M), T(bitPattern:  0 as M))
            XCTAssertEqual(T(bitPattern:  0 &  1 as M), T(bitPattern:  0 as M))
            
            XCTAssertEqual(T(bitPattern:  1 & ~1 as M), T(bitPattern:  0 as M))
            XCTAssertEqual(T(bitPattern:  1 & ~0 as M), T(bitPattern:  1 as M))
            XCTAssertEqual(T(bitPattern:  1 &  0 as M), T(bitPattern:  0 as M))
            XCTAssertEqual(T(bitPattern:  1 &  1 as M), T(bitPattern:  1 as M))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLogicalOr() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(T(bitPattern: ~1 | ~1 as M), T(bitPattern: ~1 as M))
            XCTAssertEqual(T(bitPattern: ~1 | ~0 as M), T(bitPattern: ~0 as M))
            XCTAssertEqual(T(bitPattern: ~1 |  0 as M), T(bitPattern: ~1 as M))
            XCTAssertEqual(T(bitPattern: ~1 |  1 as M), T(bitPattern: ~0 as M))
            
            XCTAssertEqual(T(bitPattern: ~0 | ~1 as M), T(bitPattern: ~0 as M))
            XCTAssertEqual(T(bitPattern: ~0 | ~0 as M), T(bitPattern: ~0 as M))
            XCTAssertEqual(T(bitPattern: ~0 |  0 as M), T(bitPattern: ~0 as M))
            XCTAssertEqual(T(bitPattern: ~0 |  1 as M), T(bitPattern: ~0 as M))
            
            XCTAssertEqual(T(bitPattern:  0 | ~1 as M), T(bitPattern: ~1 as M))
            XCTAssertEqual(T(bitPattern:  0 | ~0 as M), T(bitPattern: ~0 as M))
            XCTAssertEqual(T(bitPattern:  0 |  0 as M), T(bitPattern:  0 as M))
            XCTAssertEqual(T(bitPattern:  0 |  1 as M), T(bitPattern:  1 as M))
            
            XCTAssertEqual(T(bitPattern:  1 | ~1 as M), T(bitPattern: ~0 as M))
            XCTAssertEqual(T(bitPattern:  1 | ~0 as M), T(bitPattern: ~0 as M))
            XCTAssertEqual(T(bitPattern:  1 |  0 as M), T(bitPattern:  1 as M))
            XCTAssertEqual(T(bitPattern:  1 |  1 as M), T(bitPattern:  1 as M))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testLogicalXor() {
        func whereIs<T>(_ type: T.Type) where T: SystemInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(T(bitPattern: ~1 ^ ~1 as M), T(bitPattern:  0 as M))
            XCTAssertEqual(T(bitPattern: ~1 ^ ~0 as M), T(bitPattern:  1 as M))
            XCTAssertEqual(T(bitPattern: ~1 ^  0 as M), T(bitPattern: ~1 as M))
            XCTAssertEqual(T(bitPattern: ~1 ^  1 as M), T(bitPattern: ~0 as M))
            
            XCTAssertEqual(T(bitPattern: ~0 ^ ~1 as M), T(bitPattern:  1 as M))
            XCTAssertEqual(T(bitPattern: ~0 ^ ~0 as M), T(bitPattern:  0 as M))
            XCTAssertEqual(T(bitPattern: ~0 ^  0 as M), T(bitPattern: ~0 as M))
            XCTAssertEqual(T(bitPattern: ~0 ^  1 as M), T(bitPattern: ~1 as M))
            
            XCTAssertEqual(T(bitPattern:  0 ^ ~1 as M), T(bitPattern: ~1 as M))
            XCTAssertEqual(T(bitPattern:  0 ^ ~0 as M), T(bitPattern: ~0 as M))
            XCTAssertEqual(T(bitPattern:  0 ^  0 as M), T(bitPattern:  0 as M))
            XCTAssertEqual(T(bitPattern:  0 ^  1 as M), T(bitPattern:  1 as M))
            
            XCTAssertEqual(T(bitPattern:  1 ^ ~1 as M), T(bitPattern: ~0 as M))
            XCTAssertEqual(T(bitPattern:  1 ^ ~0 as M), T(bitPattern: ~1 as M))
            XCTAssertEqual(T(bitPattern:  1 ^  0 as M), T(bitPattern:  1 as M))
            XCTAssertEqual(T(bitPattern:  1 ^  1 as M), T(bitPattern:  0 as M))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
