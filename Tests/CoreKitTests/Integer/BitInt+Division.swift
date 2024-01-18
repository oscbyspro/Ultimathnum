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
// MARK: * Bit Int x Division
//*============================================================================*

extension BitIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivision() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test.division( 0 as T,  0 as T,  0 as T,  0 as T, true )
            Test.division( 0 as T, -1 as T,  0 as T,  0 as T, false)
            Test.division(-1 as T,  0 as T, -1 as T, -1 as T, true )
            Test.division(-1 as T, -1 as T, -1 as T,  0 as T, true )
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test.division( 0 as T,  0 as T,  0 as T,  0 as T, true )
            Test.division( 0 as T,  1 as T,  0 as T,  0 as T, false)
            Test.division( 1 as T,  0 as T,  1 as T,  1 as T, true )
            Test.division( 1 as T,  1 as T,  1 as T,  0 as T, false)
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testDivision21() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias D = Doublet<T>
            
            Test.division(D(low: 0, high:  0),  0 as T,  0 as T,  0 as T, true ) //  0 vs  0
            Test.division(D(low: 1, high:  0),  0 as T, -1 as T, -1 as T, true ) //  1 vs  0
            Test.division(D(low: 0, high: -1),  0 as T,  0 as T,  0 as T, true ) // -2 vs  0
            Test.division(D(low: 1, high: -1),  0 as T, -1 as T, -1 as T, true ) // -1 vs  0
            Test.division(D(low: 0, high:  0), -1 as T,  0 as T,  0 as T, false) //  0 vs -1
            Test.division(D(low: 1, high:  0), -1 as T, -1 as T,  0 as T, false) //  1 vs -1
            Test.division(D(low: 0, high: -1), -1 as T,  0 as T,  0 as T, true ) // -2 vs -1
            Test.division(D(low: 1, high: -1), -1 as T, -1 as T,  0 as T, false) // -1 vs -1
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias D = Doublet<T>
            
            Test.division(D(low: 0, high:  0),  0 as T,  0 as T,  0 as T, true ) //  0 vs  0
            Test.division(D(low: 1, high:  0),  0 as T,  1 as T,  1 as T, true ) //  1 vs  0
            Test.division(D(low: 0, high:  1),  0 as T,  0 as T,  0 as T, true ) //  2 vs  0
            Test.division(D(low: 1, high:  1),  0 as T,  1 as T,  1 as T, true ) //  3 vs  0
            Test.division(D(low: 0, high:  0),  1 as T,  0 as T,  0 as T, false) //  0 vs  1
            Test.division(D(low: 1, high:  0),  1 as T,  1 as T,  0 as T, false) //  1 vs  1
            Test.division(D(low: 0, high:  1),  1 as T,  0 as T,  0 as T, true ) //  2 vs  1
            Test.division(D(low: 1, high:  1),  1 as T,  1 as T,  0 as T, true ) //  3 vs  1
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
