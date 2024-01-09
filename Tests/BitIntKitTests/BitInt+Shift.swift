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
import TestKit
import XCTest

//*============================================================================*
// MARK: * Bit Int x Shift
//*============================================================================*

extension BitIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testShiftLS() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.shift( 0 as T,  0 as T,  0 as T, .left,  .smart)
            Test.shift( 0 as T, -1 as T,  0 as T, .left,  .smart)
            Test.shift(-1 as T,  0 as T, -1 as T, .left,  .smart)
            Test.shift(-1 as T, -1 as T, -1 as T, .left,  .smart)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.shift( 0 as T,  0 as T,  0 as T, .left,  .smart)
            Test.shift( 0 as T,  1 as T,  0 as T, .left,  .smart)
            Test.shift( 1 as T,  0 as T,  1 as T, .left,  .smart)
            Test.shift( 1 as T,  1 as T,  0 as T, .left,  .smart)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testShiftRS() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.shift( 0 as T,  0 as T,  0 as T, .right, .smart)
            Test.shift( 0 as T, -1 as T,  0 as T, .right, .smart)
            Test.shift(-1 as T,  0 as T, -1 as T, .right, .smart)
            Test.shift(-1 as T, -1 as T,  0 as T, .right, .smart)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.shift( 0 as T,  0 as T,  0 as T, .right, .smart)
            Test.shift( 0 as T,  1 as T,  0 as T, .right, .smart)
            Test.shift( 1 as T,  0 as T,  1 as T, .right, .smart)
            Test.shift( 1 as T,  1 as T,  0 as T, .right, .smart)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testShiftLM() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.shift( 0 as T,  0 as T,  0 as T, .left,  .masked)
            Test.shift( 0 as T, -1 as T,  0 as T, .left,  .masked)
            Test.shift(-1 as T,  0 as T, -1 as T, .left,  .masked)
            Test.shift(-1 as T, -1 as T, -1 as T, .left,  .masked)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.shift( 0 as T,  0 as T,  0 as T, .left,  .masked)
            Test.shift( 0 as T,  1 as T,  0 as T, .left,  .masked)
            Test.shift( 1 as T,  0 as T,  1 as T, .left,  .masked)
            Test.shift( 1 as T,  1 as T,  1 as T, .left,  .masked)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testShiftRM() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.shift( 0 as T,  0 as T,  0 as T, .right, .masked)
            Test.shift( 0 as T, -1 as T,  0 as T, .right, .masked)
            Test.shift(-1 as T,  0 as T, -1 as T, .right, .masked)
            Test.shift(-1 as T, -1 as T, -1 as T, .right, .masked)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.shift( 0 as T,  0 as T,  0 as T, .right, .masked)
            Test.shift( 0 as T,  1 as T,  0 as T, .right, .masked)
            Test.shift( 1 as T,  0 as T,  1 as T, .right, .masked)
            Test.shift( 1 as T,  1 as T,  1 as T, .right, .masked)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
