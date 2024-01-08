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
// MARK: * Bit Int x Shift
//*============================================================================*

extension BitIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testShiftSmartLeft() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(( 0 as T)  << ( 0 as T),  0 as T)
            XCTAssertEqual((-1 as T)  << ( 0 as T), -1 as T)
            XCTAssertEqual(( 0 as T)  << (-1 as T),  0 as T)
            XCTAssertEqual((-1 as T)  << (-1 as T), -1 as T)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(( 0 as T)  << ( 0 as T),  0 as T)
            XCTAssertEqual(( 1 as T)  << ( 0 as T),  1 as T)
            XCTAssertEqual(( 0 as T)  << ( 1 as T),  0 as T)
            XCTAssertEqual(( 1 as T)  << ( 1 as T),  0 as T)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testShiftSmartRight() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(( 0 as T)  >> ( 0 as T),  0 as T)
            XCTAssertEqual((-1 as T)  >> ( 0 as T), -1 as T)
            XCTAssertEqual(( 0 as T)  >> (-1 as T),  0 as T)
            XCTAssertEqual((-1 as T)  >> (-1 as T),  0 as T)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(( 0 as T)  >> ( 0 as T),  0 as T)
            XCTAssertEqual(( 1 as T)  >> ( 0 as T),  1 as T)
            XCTAssertEqual(( 0 as T)  >> ( 1 as T),  0 as T)
            XCTAssertEqual(( 1 as T)  >> ( 1 as T),  0 as T)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    
    func testShiftMaskedLeft() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(( 0 as T) &<< ( 0 as T),  0 as T)
            XCTAssertEqual((-1 as T) &<< ( 0 as T), -1 as T)
            XCTAssertEqual(( 0 as T) &<< (-1 as T),  0 as T)
            XCTAssertEqual((-1 as T) &<< (-1 as T), -1 as T)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(( 0 as T) &<< ( 0 as T),  0 as T)
            XCTAssertEqual(( 1 as T) &<< ( 0 as T),  1 as T)
            XCTAssertEqual(( 0 as T) &<< ( 1 as T),  0 as T)
            XCTAssertEqual(( 1 as T) &<< ( 1 as T),  1 as T)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    
    func testShiftMaskedRight() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(( 0 as T) &>> ( 0 as T),  0 as T)
            XCTAssertEqual((-1 as T) &>> ( 0 as T), -1 as T)
            XCTAssertEqual(( 0 as T) &>> (-1 as T),  0 as T)
            XCTAssertEqual((-1 as T) &>> (-1 as T), -1 as T)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            XCTAssertEqual(( 0 as T) &>> ( 0 as T),  0 as T)
            XCTAssertEqual(( 1 as T) &>> ( 0 as T),  1 as T)
            XCTAssertEqual(( 0 as T) &>> ( 1 as T),  0 as T)
            XCTAssertEqual(( 1 as T) &>> ( 1 as T),  1 as T)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
