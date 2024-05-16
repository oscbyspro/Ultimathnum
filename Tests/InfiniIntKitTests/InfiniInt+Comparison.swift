//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Infinite Int x Comparison
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComparison() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            IntegerInvariants(T.self).comparisonAgainstOneByte()
            IntegerInvariants(T.self).comparisonOfRepeatingBit()
            
            Test().comparison(IXL(load: IX.min), IXL(load: IX.min),  0 as Signum)
            Test().comparison(IXL(load: IX.min), UXL(load: IX.min), -1 as Signum)
            Test().comparison(UXL(load: IX.min), IXL(load: IX.min),  1 as Signum)
            Test().comparison(UXL(load: IX.min), UXL(load: IX.min),  0 as Signum)
            
            Test().comparison(IXL(load: IX.max), IXL(load: IX.max),  0 as Signum)
            Test().comparison(IXL(load: IX.max), UXL(load: IX.max),  0 as Signum)
            Test().comparison(UXL(load: IX.max), IXL(load: IX.max),  0 as Signum)
            Test().comparison(UXL(load: IX.max), UXL(load: IX.max),  0 as Signum)
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
