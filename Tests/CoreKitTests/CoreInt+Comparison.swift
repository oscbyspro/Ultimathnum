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
// MARK: * Core Int x Comparison
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComparison() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            IntegerInvariants(T.self).comparisonAgainstOneByte()
            IntegerInvariants(T.self).comparisonOfRepeatingBit()
        }
        
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test().comparison( 0 as T,  0 as T,  0 as Signum)
            Test().comparison(-1 as T,  0 as T, -1 as Signum)
            Test().comparison( 0 as T, -1 as T,  1 as Signum)
            Test().comparison(-1 as T, -1 as T,  0 as Signum)
            
            Test().comparison( 0 as T,  0 as T,  0 as Signum)
            Test().comparison(-0 as T,  0 as T,  0 as Signum)
            Test().comparison( 0 as T, -0 as T,  0 as Signum)
            Test().comparison(-0 as T, -0 as T,  0 as Signum)
            
            Test().comparison( 1 as T,  1 as T,  0 as Signum)
            Test().comparison(-1 as T,  1 as T, -1 as Signum)
            Test().comparison( 1 as T, -1 as T,  1 as Signum)
            Test().comparison(-1 as T, -1 as T,  0 as Signum)
            
            Test().comparison( 2 as T,  3 as T, -1 as Signum)
            Test().comparison(-2 as T,  3 as T, -1 as Signum)
            Test().comparison( 2 as T, -3 as T,  1 as Signum)
            Test().comparison(-2 as T, -3 as T,  1 as Signum)
            
            Test().comparison( 3 as T,  2 as T,  1 as Signum)
            Test().comparison(-3 as T,  2 as T, -1 as Signum)
            Test().comparison( 3 as T, -2 as T,  1 as Signum)
            Test().comparison(-3 as T, -2 as T, -1 as Signum)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            Test().comparison( 0 as T,  0 as T,  0 as Signum)
            Test().comparison( 1 as T,  0 as T,  1 as Signum)
            Test().comparison( 0 as T,  1 as T, -1 as Signum)
            Test().comparison( 1 as T,  1 as T,  0 as Signum)
            
            Test().comparison( 0 as T,  0 as T,  0 as Signum)
            Test().comparison( 1 as T,  1 as T,  0 as Signum)
            Test().comparison( 2 as T,  3 as T, -1 as Signum)
            Test().comparison( 3 as T,  2 as T,  1 as Signum)
        }
        
        for type in Self.types {
            whereIs(type)
        }
        
        for type in Self.typesWhereIsSigned {
            whereIsSigned(type)
        }
        
        for type in Self.typesWhereIsUnsigned {
            whereIsUnsigned(type)
        }
    }
}
