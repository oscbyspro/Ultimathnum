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
    
    /// - Note: Generic tests may depend on these results.
    func testComparisonOfSize() {
        for size: Count in [I8 .size, U8 .size] {
            Test().comparison(size, U8 .size, Signum.zero,     id: ComparableID())
            Test().comparison(size, U16.size, Signum.negative, id: ComparableID())
            Test().comparison(size, U32.size, Signum.negative, id: ComparableID())
            Test().comparison(size, U64.size, Signum.negative, id: ComparableID())
        }
        
        for size: Count in [I16.size, U16.size] {
            Test().comparison(size, U8 .size, Signum.positive, id: ComparableID())
            Test().comparison(size, U16.size, Signum.zero,     id: ComparableID())
            Test().comparison(size, U32.size, Signum.negative, id: ComparableID())
            Test().comparison(size, U64.size, Signum.negative, id: ComparableID())
        }
        
        for size: Count in [I32.size, U32.size] {
            Test().comparison(size, U8 .size, Signum.positive, id: ComparableID())
            Test().comparison(size, U16.size, Signum.positive, id: ComparableID())
            Test().comparison(size, U32.size, Signum.zero,     id: ComparableID())
            Test().comparison(size, U64.size, Signum.negative, id: ComparableID())
        }
        
        for size: Count in [I64.size, U64.size] {
            Test().comparison(size, U8 .size, Signum.positive, id: ComparableID())
            Test().comparison(size, U16.size, Signum.positive, id: ComparableID())
            Test().comparison(size, U32.size, Signum.positive, id: ComparableID())
            Test().comparison(size, U64.size, Signum.zero,     id: ComparableID())
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
        Test().comparison(-1 as I32, 0 as U8,  Signum.negative) // OK
        Test().comparison(-1 as I32, 0 as U16, Signum.negative) // OK
        Test().comparison(-1 as I32, 0 as U32, Signum.negative) // OK
        Test().comparison(-1 as I32, 0 as U64, Signum.negative) // :(
    }
}
