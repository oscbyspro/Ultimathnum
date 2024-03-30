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
            typealias D = Division<T, T>
            typealias F = Fallible<Division<T, T>>
            
            Test().division( 0 as T,  0 as T, F(D(quotient:  0, remainder:  0), error: true))
            Test().division(-1 as T,  0 as T, F(D(quotient:  0, remainder: -1), error: true))
            Test().division( 0 as T, -1 as T, F(D(quotient:  0, remainder:  0)))
            Test().division(-1 as T, -1 as T, F(D(quotient: -1, remainder:  0), error: true))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias D = Division<T, T>
            typealias F = Fallible<Division<T, T>>
            
            Test().division( 0 as T,  0 as T, F(D(quotient:  0, remainder:  0), error: true))
            Test().division( 0 as T,  1 as T, F(D(quotient:  0, remainder:  0)))
            Test().division( 1 as T,  0 as T, F(D(quotient:  0, remainder:  1), error: true))
            Test().division( 1 as T,  1 as T, F(D(quotient:  1, remainder:  0)))
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testDivision2111() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X = DoubleIntLayout<T>
            typealias D = Division<T, T>
            typealias F = Fallible<Division<T, T>>
            
            Test().division(X(low: 0, high:  0),  0 as T,  F(D(quotient:  0, remainder:  0), error: true)) //  0 vs  0
            Test().division(X(low: 1, high:  0),  0 as T,  F(D(quotient:  0, remainder: -1), error: true)) //  1 vs  0
            Test().division(X(low: 0, high: -1),  0 as T,  F(D(quotient:  0, remainder:  0), error: true)) // -2 vs  0
            Test().division(X(low: 1, high: -1),  0 as T,  F(D(quotient:  0, remainder: -1), error: true)) // -1 vs  0
            Test().division(X(low: 0, high:  0), -1 as T,  F(D(quotient:  0, remainder:  0)))              //  0 vs -1
            Test().division(X(low: 1, high:  0), -1 as T,  F(D(quotient: -1, remainder:  0)))              //  1 vs -1
            Test().division(X(low: 0, high: -1), -1 as T,  F(D(quotient:  0, remainder:  0), error: true)) // -2 vs -1
            Test().division(X(low: 1, high: -1), -1 as T,  F(D(quotient: -1, remainder:  0), error: true)) // -1 vs -1
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X = DoubleIntLayout<T>
            typealias D = Division<T, T>
            typealias F = Fallible<Division<T, T>>
            
            Test().division(X(low: 0, high:  0),  0 as T,  F(D(quotient:  0, remainder:  0), error: true)) //  0 vs  0
            Test().division(X(low: 1, high:  0),  0 as T,  F(D(quotient:  0, remainder:  1), error: true)) //  1 vs  0
            Test().division(X(low: 0, high:  1),  0 as T,  F(D(quotient:  0, remainder:  0), error: true)) //  2 vs  0
            Test().division(X(low: 1, high:  1),  0 as T,  F(D(quotient:  0, remainder:  1), error: true)) //  3 vs  0
            Test().division(X(low: 0, high:  0),  1 as T,  F(D(quotient:  0, remainder:  0)))              //  0 vs  1
            Test().division(X(low: 1, high:  0),  1 as T,  F(D(quotient:  1, remainder:  0)))              //  1 vs  1
            Test().division(X(low: 0, high:  1),  1 as T,  F(D(quotient:  0, remainder:  0), error: true)) //  2 vs  1
            Test().division(X(low: 1, high:  1),  1 as T,  F(D(quotient:  1, remainder:  0), error: true)) //  3 vs  1
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
