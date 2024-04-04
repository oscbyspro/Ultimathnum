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
// MARK: * Minimi Int x Subtraction
//*============================================================================*

extension MinimiIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNegation() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().subtraction( 0 as T,  0 as T, F( 0 as T))
            Test().subtraction( 0 as T, -1 as T, F(-1 as T, error: true))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().subtraction( 0 as T,  0 as T, F( 0 as T))
            Test().subtraction( 0 as T,  1 as T, F( 1 as T, error: true))
        }
        
        for type in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testSubtraction() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().subtraction( 0 as T,  0 as T, F( 0 as T))
            Test().subtraction(-1 as T,  0 as T, F(-1 as T))
            Test().subtraction( 0 as T, -1 as T, F(-1 as T, error: true))
            Test().subtraction(-1 as T, -1 as T, F( 0 as T))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().subtraction( 0 as T,  0 as T, F( 0 as T))
            Test().subtraction( 1 as T,  0 as T, F( 1 as T))
            Test().subtraction( 0 as T,  1 as T, F( 1 as T, error: true))
            Test().subtraction( 1 as T,  1 as T, F( 0 as T))
        }
        
        for type in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testDecrementation() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().decrementation(-1 as T, F( 0 as T, error: true))
            Test().decrementation( 0 as T, F(-1 as T))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().decrementation( 0 as T, F( 1 as T, error: true))
            Test().decrementation( 1 as T, F( 0 as T))
        }
        
        for type in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
