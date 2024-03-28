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
// MARK: * Minimi Int x Division
//*============================================================================*

extension MinimiIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivision() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test.division( 0 as T,  0 as T, nil)
            Test.division( 0 as T, -1 as T, Division(quotient: 0 as T, remainder: 0 as T))
            Test.division(-1 as T,  0 as T, nil)
            Test.division(-1 as T, -1 as T, nil)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test.division( 0 as T,  0 as T, nil)
            Test.division( 0 as T,  1 as T, Division(quotient: 0 as T, remainder: 0 as T))
            Test.division( 1 as T,  0 as T, nil)
            Test.division( 1 as T,  1 as T, Division(quotient: 1 as T, remainder: 0 as T))
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testDivision2111() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test.division2111(DoubleIntLayout(low: 0, high:  0),  0 as T,  nil) //  0 vs  0
            Test.division2111(DoubleIntLayout(low: 1, high:  0),  0 as T,  nil) //  1 vs  0
            Test.division2111(DoubleIntLayout(low: 0, high: -1),  0 as T,  nil) // -2 vs  0
            Test.division2111(DoubleIntLayout(low: 1, high: -1),  0 as T,  nil) // -1 vs  0
            Test.division2111(DoubleIntLayout(low: 0, high:  0), -1 as T,  Division(quotient:  0 as T, remainder: 0 as T)) //  0 vs -1
            Test.division2111(DoubleIntLayout(low: 1, high:  0), -1 as T,  Division(quotient: -1 as T, remainder: 0 as T)) //  1 vs -1
            Test.division2111(DoubleIntLayout(low: 0, high: -1), -1 as T,  nil) // -2 vs -1
            Test.division2111(DoubleIntLayout(low: 1, high: -1), -1 as T,  Division(quotient: -1 as T, remainder: 0 as T)) // -1 vs -1
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test.division2111(DoubleIntLayout(low: 0, high:  0),  0 as T,  nil) //  0 vs  0
            Test.division2111(DoubleIntLayout(low: 1, high:  0),  0 as T,  nil) //  1 vs  0
            Test.division2111(DoubleIntLayout(low: 0, high:  1),  0 as T,  nil) //  2 vs  0
            Test.division2111(DoubleIntLayout(low: 1, high:  1),  0 as T,  nil) //  3 vs  0
            Test.division2111(DoubleIntLayout(low: 0, high:  0),  1 as T,  Division(quotient:  0 as T, remainder: 0 as T)) //  0 vs  1
            Test.division2111(DoubleIntLayout(low: 1, high:  0),  1 as T,  Division(quotient:  1 as T, remainder: 0 as T)) //  1 vs  1
            Test.division2111(DoubleIntLayout(low: 0, high:  1),  1 as T,  nil) //  2 vs  1
            Test.division2111(DoubleIntLayout(low: 1, high:  1),  1 as T,  nil) //  3 vs  1
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
