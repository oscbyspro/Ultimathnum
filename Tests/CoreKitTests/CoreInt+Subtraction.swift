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
// MARK: * Core Int x Subtraction
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNegation() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().subtraction( 0 as T,  0 as T, F( 0 as T))
            Test().subtraction( 0 as T,  1 as T, F(~0 as T))
            Test().subtraction( 0 as T, -1 as T, F( 1 as T))
            
            Test().subtraction( 0 as T,  T .max, F( T .min + 1))
            Test().subtraction( 0 as T,  T .min, F( T .min + 0, error: true))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().subtraction( 0 as T,  0 as T, F( 0 as T))
            Test().subtraction( 0 as T,  1 as T, F(~0 as T, error: true))
            Test().subtraction( 0 as T,  2 as T, F(~1 as T, error: true))
            
            Test().subtraction( 0 as T,  T .min, F( T .min + 0))
            Test().subtraction( 0 as T,  T .max, F( T .min + 1, error: true))
        }
        
        for type in coreSystemsIntegers {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testSubtraction() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().subtraction( 0 as T,  0 as T, F( 0 as T))
            Test().subtraction(-1 as T,  0 as T, F(-1 as T))
            Test().subtraction( 0 as T, -1 as T, F( 1 as T))
            Test().subtraction(-1 as T, -1 as T, F( 0 as T))
            
            IntegerInvariants(T.self).subtractionAboutMinMax(SystemsIntegerID())
            IntegerInvariants(T.self).subtractionAboutRepeatingBit(BinaryIntegerID())
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().subtraction( 0 as T,  0 as T, F( 0 as T))
            Test().subtraction( 1 as T,  0 as T, F( 1 as T))
            Test().subtraction( 0 as T,  1 as T, F(~0 as T, error: true))
            Test().subtraction( 1 as T,  1 as T, F( 0 as T))
            
            IntegerInvariants(T.self).subtractionAboutMinMax(SystemsIntegerID())
            IntegerInvariants(T.self).subtractionAboutRepeatingBit(BinaryIntegerID())
        }
        
        for type in coreSystemsIntegers {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
