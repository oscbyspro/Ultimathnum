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
// MARK: * Core Int x Multiplication
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplication() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias X = Doublet<T>
            typealias F = Fallible<Doublet<T>>
            
            IntegerInvariants(T.self).multiplicationAboutMsb(SystemsIntegerID())
            IntegerInvariants(T.self).multiplicationAboutRepeatingBit(SystemsIntegerID())
        }
        
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias X = Doublet<T>
            typealias F = Fallible<Doublet<T>>
            
            Test().multiplication( 0 as T,  0 as T, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication( 0 as T, -1 as T, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication(-1 as T,  0 as T, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication(-1 as T, -1 as T, F(X(low:  1 as M, high:  0 as T)))
            
            Test().multiplication( 3 as T,  0 as T, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication( 3 as T, -0 as T, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication(-3 as T,  0 as T, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication(-3 as T, -0 as T, F(X(low:  0 as M, high:  0 as T)))
            
            Test().multiplication( 3 as T,  1 as T, F(X(low:  3 as M, high:  0 as T)))
            Test().multiplication( 3 as T, -1 as T, F(X(low: ~2 as M, high: -1 as T)))
            Test().multiplication(-3 as T,  1 as T, F(X(low: ~2 as M, high: -1 as T)))
            Test().multiplication(-3 as T, -1 as T, F(X(low:  3 as M, high:  0 as T)))
            
            Test().multiplication( 3 as T,  2 as T, F(X(low:  6 as M, high:  0 as T)))
            Test().multiplication( 3 as T, -2 as T, F(X(low: ~5 as M, high: -1 as T)))
            Test().multiplication(-3 as T,  2 as T, F(X(low: ~5 as M, high: -1 as T)))
            Test().multiplication(-3 as T, -2 as T, F(X(low:  6 as M, high:  0 as T)))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias M = T.Magnitude
            typealias X = Doublet<T>
            typealias F = Fallible<Doublet<T>>
            
            Test().multiplication( 0 as T,  0 as T, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication( 0 as T,  1 as T, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication( 1 as T,  0 as T, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication( 1 as T,  1 as T, F(X(low:  1 as M, high:  0 as T)))
            
            Test().multiplication( 3 as T,  0 as T, F(X(low:  0 as M, high:  0 as T)))
            Test().multiplication( 3 as T,  1 as T, F(X(low:  3 as M, high:  0 as T)))
            Test().multiplication( 3 as T,  2 as T, F(X(low:  6 as M, high:  0 as T)))
            Test().multiplication( 3 as T,  3 as T, F(X(low:  9 as M, high:  0 as T)))
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
        
        for type in coreSystemsIntegersWhereIsSigned {
            whereIsSigned(type)
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIsUnsigned(type)
        }
    }
}
