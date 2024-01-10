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
import TestKit
import XCTest

//*============================================================================*
// MARK: * Main Int x Words
//*============================================================================*

extension MainIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testWords() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.words(-2 as T, [~1] as [Word])
            Test.words(-1 as T, [~0] as [Word])
            Test.words( 0 as T, [ 0] as [Word])
            Test.words( 1 as T, [ 1] as [Word])
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.words( 0 as T, [ 0] as [Word])
            Test.words( 1 as T, [ 1] as [Word])
            Test.words( 2 as T, [ 2] as [Word])
            Test.words( 3 as T, [ 3] as [Word])
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
