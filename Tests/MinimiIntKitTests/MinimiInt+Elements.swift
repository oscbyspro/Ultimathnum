//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import MinimiIntKit
import TestKit

//*============================================================================*
// MARK: * Minimi Int x Elements
//*============================================================================*

extension MinimiIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMakeToken() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(( 0 as T).load(as: IX.self),  0 as IX)
            XCTAssertEqual((-1 as T).load(as: IX.self), ~0 as IX)
            XCTAssertEqual(( 0 as T).load(as: UX.self),  0 as UX)
            XCTAssertEqual((-1 as T).load(as: UX.self), ~0 as UX)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            XCTAssertEqual(( 0 as T).load(as: IX.self),  0 as IX)
            XCTAssertEqual(( 1 as T).load(as: IX.self),  1 as IX)
            XCTAssertEqual(( 0 as T).load(as: UX.self),  0 as UX)
            XCTAssertEqual(( 1 as T).load(as: UX.self),  1 as UX)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
