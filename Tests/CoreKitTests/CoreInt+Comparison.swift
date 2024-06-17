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
            IntegerInvariants(T.self).comparisonOfGenericLowEntropies()
            IntegerInvariants(T.self).comparisonOfGenericMinMaxEsque()
            IntegerInvariants(T.self).comparisonOfGenericRepeatingBit()
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Edge Cases
//=----------------------------------------------------------------------------=

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// 2024-06-16: Checks the use of `init(load:)` or similar.
    func testComparisonDoesNotReinterpretNegativeValuesAsUnsigned() {
        Test().comparison(-1 as I32, 0 as U8,  -1 as Signum) // OK
        Test().comparison(-1 as I32, 0 as U16, -1 as Signum) // OK
        Test().comparison(-1 as I32, 0 as U32, -1 as Signum) // OK
        Test().comparison(-1 as I32, 0 as U64, -1 as Signum) // :(
    }
}
