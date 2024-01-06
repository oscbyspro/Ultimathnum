//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import UMNCoreKit
import UMNTestKit
import XCTest

//*============================================================================*
// MARK: * Bit Int x Division
//*============================================================================*

extension BitIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivision() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.division( 0 as T,  0 as T,  0 as T,  0 as T, (true,  true ))
            Test.division(-1 as T,  0 as T, -1 as T, -1 as T, (true,  true ))
            Test.division( 0 as T, -1 as T,  0 as T,  0 as T, (false, false))
            Test.division(-1 as T, -1 as T, -1 as T,  0 as T, (true,  false))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            Test.division( 0 as T,  0 as T,  0 as T,  0 as T, (true,  true ))
            Test.division( 1 as T,  0 as T,  1 as T,  1 as T, (true,  true ))
            Test.division( 0 as T,  1 as T,  0 as T,  0 as T, (false, false))
            Test.division( 1 as T,  1 as T,  1 as T,  0 as T, (false, false))
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testDivision21() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemInteger {
            typealias X2 = FullWidth<T, T.Magnitude>
            
            Test.division(X2(low: 0, high:  0),  0 as T,  0 as T,  0 as T, (true,  true )) //  0 vs  0
            Test.division(X2(low: 1, high:  0),  0 as T, -1 as T, -1 as T, (true,  true )) //  1 vs  0
            Test.division(X2(low: 0, high: -1),  0 as T,  0 as T,  0 as T, (true,  true )) // -2 vs  0
            Test.division(X2(low: 1, high: -1),  0 as T, -1 as T, -1 as T, (true,  true )) // -1 vs  0
            Test.division(X2(low: 0, high:  0), -1 as T,  0 as T,  0 as T, (false, false)) //  0 vs -1
            Test.division(X2(low: 1, high:  0), -1 as T, -1 as T,  0 as T, (false, false)) //  1 vs -1
            Test.division(X2(low: 0, high: -1), -1 as T,  0 as T,  0 as T, (true,  false)) // -2 vs -1
            Test.division(X2(low: 1, high: -1), -1 as T, -1 as T,  0 as T, (false, false)) // -1 vs -1
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemInteger {
            typealias X2 = FullWidth<T, T.Magnitude>
            
            Test.division(X2(low: 0, high:  0),  0 as T,  0 as T,  0 as T, (true,  true )) //  0 vs  0
            Test.division(X2(low: 1, high:  0),  0 as T,  1 as T,  1 as T, (true,  true )) //  1 vs  0
            Test.division(X2(low: 0, high:  1),  0 as T,  0 as T,  0 as T, (true,  true )) //  2 vs  0
            Test.division(X2(low: 1, high:  1),  0 as T,  1 as T,  1 as T, (true,  true )) //  3 vs  0
            Test.division(X2(low: 0, high:  0),  1 as T,  0 as T,  0 as T, (false, false)) //  0 vs  1
            Test.division(X2(low: 1, high:  0),  1 as T,  1 as T,  0 as T, (false, false)) //  1 vs  1
            Test.division(X2(low: 0, high:  1),  1 as T,  0 as T,  0 as T, (true,  false)) //  2 vs  1
            Test.division(X2(low: 1, high:  1),  1 as T,  1 as T,  0 as T, (true,  false)) //  3 vs  1
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
