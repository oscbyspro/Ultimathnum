//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Data Int
//*============================================================================*

final class DataIntTests: XCTestCase {
    
    //*========================================================================*
    // MARK: * Canvas
    //*========================================================================*
    
    struct Canvas<Element> where Element: SystemsInteger & UnsignedInteger {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        let test: Test
        let body: [Element]
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        init(_ body: [Element], test: Test) {
            self.test = test
            self.body = body
        }
        
        
        init(_ body: [Element], file: StaticString = #file, line: UInt = #line) {
            self.test = Test(file: file, line: line)
            self.body = body
        }
    }
}
