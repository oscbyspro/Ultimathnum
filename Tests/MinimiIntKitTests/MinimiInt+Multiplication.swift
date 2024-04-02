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
// MARK: * Minimi Int x Multiplication
//*============================================================================*

extension MinimiIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplication() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X = Doublet<T>
            typealias F = Fallible<Doublet<T>>
            
            Test().multiplication( 0 as T,  0 as T, F(X(low: 0, high:  0)))
            Test().multiplication(-1 as T,  0 as T, F(X(low: 0, high:  0)))
            Test().multiplication( 0 as T, -1 as T, F(X(low: 0, high:  0)))
            Test().multiplication(-1 as T, -1 as T, F(X(low: 1, high:  0), error: true))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias X = Doublet<T>
            typealias F = Fallible<Doublet<T>>
            
            Test().multiplication( 0 as T,  0 as T, F(X(low: 0, high:  0)))
            Test().multiplication( 1 as T,  0 as T, F(X(low: 0, high:  0)))
            Test().multiplication( 0 as T,  1 as T, F(X(low: 0, high:  0)))
            Test().multiplication( 1 as T,  1 as T, F(X(low: 1, high:  0)))
        }
        
        for type in Self.types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
