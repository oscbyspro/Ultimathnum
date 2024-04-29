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
    
    func testSubtraction() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            IntegerInvariants(T.self).subtractionOfMinMax(SystemsIntegerID())
            IntegerInvariants(T.self).subtractionByNegation(SystemsIntegerID())
            IntegerInvariants(T.self).subtractionOfRepeatingBit(BinaryIntegerID())
        }
        
        for type in coreSystemsIntegers {
            whereIs(type)
        }
    }
}
