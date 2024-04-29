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
// MARK: * Core Int x Addition
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddition() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().addition( 0 as T,  0 as T, F( 0 as T))
            Test().addition(-1 as T,  0 as T, F(-1 as T))
            Test().addition( 0 as T, -1 as T, F(-1 as T))
            Test().addition(-1 as T, -1 as T, F(-2 as T))
                                    
            IntegerInvariants(T.self).additionAboutMinMax(SystemsIntegerID())
            IntegerInvariants(T.self).additionAboutRepeatingBit(BinaryIntegerID())
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: SystemsInteger {
            typealias F = Fallible<T>
            
            Test().addition( 0 as T,  0 as T, F( 0 as T))
            Test().addition( 1 as T,  0 as T, F( 1 as T))
            Test().addition( 0 as T,  1 as T, F( 1 as T))
            Test().addition( 1 as T,  1 as T, F( 2 as T))
                        
            IntegerInvariants(T.self).additionAboutMinMax(SystemsIntegerID())
            IntegerInvariants(T.self).additionAboutRepeatingBit(BinaryIntegerID())
        }
        
        for type in coreSystemsIntegers {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}
